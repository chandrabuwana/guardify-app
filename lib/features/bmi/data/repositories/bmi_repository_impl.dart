import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/bmi_record.dart';
import '../../domain/entities/bmi_input.dart';
import '../../../../core/domain/entities/paginated_response.dart';
import '../../domain/repositories/bmi_repository.dart';
import '../datasources/bmi_local_data_source.dart';
import '../datasources/bmi_remote_data_source.dart';
import '../models/bmi_record_model.dart';
import '../models/bmi_api_response_model.dart';
import '../mappers/bmi_mapper.dart';

@Injectable(as: BMIRepository)
class BMIRepositoryImpl implements BMIRepository {
  final BMILocalDataSource localDataSource;
  final BmiRemoteDataSource remoteDataSource;

  BMIRepositoryImpl(this.localDataSource, this.remoteDataSource);

  List<UserProfile> _mapBmiRecordsToUniqueUserProfiles(
    List<BmiDataModel> bmiRecords,
  ) {
    final Map<String, BmiDataModel> latestByUserId = {};

    for (final record in bmiRecords) {
      final userId = record.user?.id ?? record.userId;
      if (userId.isEmpty) continue;

      final currentDate = record.updateDate ?? record.createDate;
      final existing = latestByUserId[userId];
      if (existing == null) {
        latestByUserId[userId] = record;
        continue;
      }

      final existingDate = existing.updateDate ?? existing.createDate;

      if (existingDate == null && currentDate != null) {
        latestByUserId[userId] = record;
        continue;
      }

      if (existingDate != null && currentDate != null) {
        if (currentDate.isAfter(existingDate)) {
          latestByUserId[userId] = record;
        }
      }
    }

    return latestByUserId.values.map((r) => BmiMapper.toUserProfile(r)).toList();
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    try {
      // Call Bmi/list API to get user's BMI data (for detail page)
      final request = BmiListRequestModel(
        filter: [
          FilterModel(field: 'UserId', search: userId),
        ],
        sort: SortModel(field: '', type: 0),
        start: 0,
        length: 0, // Get all BMI records for this user
      );

      final response = await remoteDataSource.getBmiList(request);

      if (!response.succeeded) {
        return Left(ServerFailure(response.message));
      }

      // If no BMI data, return user profile without BMI info
      if (response.list.isEmpty) {
        // Try to get user info from User/list API
        final userRequest = UserListRequestModel(
          filter: [
            FilterModel(field: 'Id', search: userId),
          ],
          sort: SortModel(field: '', type: 0),
          start: 0,
          length: 0,
        );
        final userResponse = await remoteDataSource.getUserList(userRequest);
        if (userResponse.succeeded == true && userResponse.list.isNotEmpty) {
          final userProfile = BmiMapper.userListItemToUserProfile(userResponse.list.first);
          final pinnedIds = await localDataSource.getPinnedUserIds();
          return Right(userProfile.copyWith(isPinned: pinnedIds.contains(userId)));
        }
        return Left(ServerFailure('User not found'));
      }

      // Use the latest BMI record (first in list, sorted by date)
      // Convert to UserProfile using mapper
      final userProfile = BmiMapper.toUserProfile(response.list.first);

      // Check if user is pinned
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfile =
          userProfile.copyWith(isPinned: pinnedIds.contains(userId));

      return Right(updatedProfile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> searchUserProfiles(
      String query) async {
    try {
      final request = BmiListRequestModel(
        filter: [
          FilterModel(field: 'fullname', search: query),
        ],
        sort: SortModel(field: '', type: 0),
        start: 1,
        length: 20,
      );

      final response = await remoteDataSource.getBmiList(request);

      if (!response.succeeded) {
        return Left(ServerFailure(response.message));
      }

      final userProfiles = _mapBmiRecordsToUniqueUserProfiles(response.list);

      // Get pinned IDs and update profiles
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfiles = userProfiles.map((profile) {
        return profile.copyWith(isPinned: pinnedIds.contains(profile.id));
      }).toList();

      return Right(updatedProfiles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getAllUserProfiles() async {
    try {
      final request = BmiListRequestModel(
        filter: [
          FilterModel(field: '', search: ''),
        ],
        sort: SortModel(field: '', type: 0),
        start: 0,
        length: 0,
      );

      final response = await remoteDataSource.getBmiList(request);

      if (!response.succeeded) {
        return Left(ServerFailure(response.message));
      }

      final userProfiles = _mapBmiRecordsToUniqueUserProfiles(response.list);

      // Get pinned IDs and update profiles
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfiles = userProfiles.map((profile) {
        return profile.copyWith(isPinned: pinnedIds.contains(profile.id));
      }).toList();

      return Right(updatedProfiles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<UserProfile>>>
      getUserProfilesPaginated({
    required int page,
    required int pageSize,
  }) async {
    try {
      // API expects Start as page number (1-based), not record offset
      final start = page;
      final validLength = pageSize > 0 ? pageSize : 10;
 
      final request = BmiListRequestModel(
        filter: [
          FilterModel(field: '', search: ''),
        ],
        sort: SortModel(field: '', type: 0),
        start: start,
        length: validLength,
      );

      final response = await remoteDataSource.getBmiList(request);

      if (!response.succeeded) {
        return Left(ServerFailure(response.message));
      }

      final userProfiles = _mapBmiRecordsToUniqueUserProfiles(response.list);

      // Get pinned IDs and update profiles
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfiles = userProfiles.map((profile) {
        return profile.copyWith(isPinned: pinnedIds.contains(profile.id));
      }).toList();

      // Calculate if there's more data
      // ALWAYS use Count (total records) for hasMore calculation, not Filtered
      // Filtered is the count of items in current page response, not total available
      // Count is the total number of records available in database
      // Example: count=23 (total), filtered=10 (current page), pageSize=10
      // Page 1: Start=1, Length=10 -> hasMore = (1 + 10 - 1) < 23 = true
      // Page 2: Start=11, Length=10 -> hasMore = (11 + 10 - 1) < 23 = true  
      // Page 3: Start=21, Length=10 -> hasMore = (21 + 10 - 1) < 23 = false
      // If API returns total records in Count, estimate loaded records as (page * limit)
      final estimatedLoaded = page * validLength;
      
      // Always use count (total records) for determining if there's more data
      // Count represents total available records, filtered is just current page count
      final totalAvailable = response.count > 0 ? response.count : response.filtered;
      final hasMore = totalAvailable > 0
          ? estimatedLoaded < totalAvailable
          : response.list.length == validLength;

      final paginatedResponse = PaginatedResponse<UserProfile>(
        data: updatedProfiles,
        totalCount: response.count,
        filteredCount: response.filtered,
        currentPage: page,
        pageSize: pageSize,
        hasMore: hasMore,
      );

      return Right(paginatedResponse);
    } catch (e, stackTrace) {
      print('Error in getUserProfilesPaginated: $e');
      print('Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getPinnedUserProfiles() async {
    try {
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final allProfiles = await localDataSource.getCachedUserProfiles();

      final pinnedProfiles = allProfiles.where((profile) {
        return pinnedIds.contains(profile.id);
      }).toList();

      final updatedProfiles = pinnedProfiles.map((profile) {
        return profile.copyWith(isPinned: true);
      }).toList();

      return Right(updatedProfiles.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> togglePinUserProfile(
      String userId, bool isPinned) async {
    try {
      await localDataSource.togglePinUser(userId, isPinned);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<BMIRecord>>> getBMIHistory(String userId) async {
    try {
      // Call Bmi/list API to get user's BMI history (for detail page)
      final request = BmiListRequestModel(
        filter: [
          FilterModel(field: 'UserId', search: userId),
        ],
        sort: SortModel(field: '', type: 0),
        start: 0,
        length: 0, // Get all records
      );

      final response = await remoteDataSource.getBmiList(request);

      if (!response.succeeded) {
        return Left(ServerFailure(response.message));
      }

      // Convert to list of BMIRecord using mapper
      final records = BmiMapper.toBMIRecordList(response.list);

      return Right(records);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BMIRecord>> addBMIRecord({
    required String userId,
    required BMIInput input,
    String? recordedBy,
  }) async {
    try {
      // Generate unique ID
      final recordId = 'record_${DateTime.now().millisecondsSinceEpoch}';

      // Create BMI record
      final record = BMIRecord.create(
        id: recordId,
        userId: userId,
        weight: input.weight,
        height: input.height,
        notes: input.notes,
        recordedBy: recordedBy,
      );

      // Save to local storage
      await localDataSource.saveBMIRecord(BMIRecordModel.fromEntity(record));

      // Update user profile with latest BMI data
      final profile = await localDataSource.getCachedUserProfile(userId);
      if (profile != null) {
        final updatedProfile = profile.copyWith(
          currentWeight: input.weight,
          height: input.height,
          currentBMI: record.bmi,
          currentBMIStatus: record.status,
          lastUpdated: record.recordedAt,
        );
        await localDataSource.updateCachedUserProfile(updatedProfile);
      }

      return Right(record);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserBMI({
    required String userId,
    required BMIInput input,
  }) async {
    try {
      final profile = await localDataSource.getCachedUserProfile(userId);
      if (profile == null) {
        return Left(ServerFailure('User profile not found'));
      }

      // Calculate BMI
      final bmi = input.bmi;
      final status = BMIStatus.fromBMI(bmi);

      // Update profile
      final updatedProfile = profile.copyWith(
        currentWeight: input.weight,
        height: input.height,
        currentBMI: bmi,
        currentBMIStatus: status,
        lastUpdated: DateTime.now(),
      );

      await localDataSource.updateCachedUserProfile(updatedProfile);
      return Right(updatedProfile.toEntity());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteBMIRecord(String recordId) async {
    try {
      // Note: We need userId to delete, for now we'll search through all users
      // In a real app, you'd include userId in the method signature
      final allProfiles = await localDataSource.getCachedUserProfiles();

      for (final profile in allProfiles) {
        final records = await localDataSource.getBMIRecords(profile.id);
        if (records.any((r) => r.id == recordId)) {
          await localDataSource.deleteBMIRecord(recordId, profile.id);
          break;
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> filterByCategory(
      String category) async {
    try {
      final request = BmiListRequestModel(
        filter: [
          FilterModel(field: 'Category', search: category),
        ],
        sort: SortModel(field: '', type: 0),
        start: 1,
        length: 20,
      );

      final response = await remoteDataSource.getBmiList(request);

      if (!response.succeeded) {
        return Left(ServerFailure(response.message));
      }

      final userProfiles = _mapBmiRecordsToUniqueUserProfiles(response.list);

      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfiles = userProfiles.map((profile) {
        return profile.copyWith(isPinned: pinnedIds.contains(profile.id));
      }).toList();

      return Right(updatedProfiles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> filterByJabatan(
      String jabatan) async {
    try {
      final request = BmiListRequestModel(
        filter: [
          FilterModel(field: 'Jabatan', search: jabatan),
        ],
        sort: SortModel(field: '', type: 0),
        start: 1,
        length: 20,
      );

      final response = await remoteDataSource.getBmiList(request);

      if (!response.succeeded) {
        return Left(ServerFailure(response.message));
      }

      final userProfiles = _mapBmiRecordsToUniqueUserProfiles(response.list);

      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfiles = userProfiles.map((profile) {
        return profile.copyWith(isPinned: pinnedIds.contains(profile.id));
      }).toList();

      return Right(updatedProfiles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBMIStatistics(
      String userId) async {
    try {
      final records = await localDataSource.getBMIRecords(userId);

      if (records.isEmpty) {
        return const Right({
          'total_records': 0,
          'average_bmi': 0.0,
          'latest_bmi': 0.0,
          'bmi_trend': 'stable',
        });
      }

      final totalRecords = records.length;
      final averageBMI =
          records.map((r) => r.bmi).reduce((a, b) => a + b) / totalRecords;
      final latestBMI = records.first.bmi;

      // Calculate trend
      String trend = 'stable';
      if (records.length >= 2) {
        final previousBMI = records[1].bmi;
        if (latestBMI > previousBMI + 0.5) {
          trend = 'increasing';
        } else if (latestBMI < previousBMI - 0.5) {
          trend = 'decreasing';
        }
      }

      return Right({
        'total_records': totalRecords,
        'average_bmi': averageBMI,
        'latest_bmi': latestBMI,
        'bmi_trend': trend,
      });
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
