import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/bmi_record.dart';
import '../../domain/entities/bmi_input.dart';
import '../../domain/repositories/bmi_repository.dart';
import '../datasources/bmi_local_data_source.dart';
import '../models/user_profile_model.dart';
import '../models/bmi_record_model.dart';

@Injectable(as: BMIRepository)
class BMIRepositoryImpl implements BMIRepository {
  final BMILocalDataSource localDataSource;

  BMIRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    try {
      // Try to get from cache first
      UserProfileModel? profile =
          await localDataSource.getCachedUserProfile(userId);

      // If not in cache, generate mock data and try again
      if (profile == null) {
        await localDataSource.generateMockData();
        profile = await localDataSource.getCachedUserProfile(userId);
      }

      if (profile == null) {
        return Left(ServerFailure('User profile not found'));
      }

      // Check if user is pinned
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfile =
          profile.copyWith(isPinned: pinnedIds.contains(userId));

      return Right(updatedProfile.toEntity());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> searchUserProfiles(
      String query) async {
    try {
      final profiles = await localDataSource.getCachedUserProfiles();

      if (profiles.isEmpty) {
        await localDataSource.generateMockData();
        final newProfiles = await localDataSource.getCachedUserProfiles();
        return Right(newProfiles.map((p) => p.toEntity()).toList());
      }

      // Filter profiles by query
      final filteredProfiles = profiles.where((profile) {
        return profile.name.toLowerCase().contains(query.toLowerCase()) ||
            profile.role.displayName
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();

      // Get pinned IDs and update profiles
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfiles = filteredProfiles.map((profile) {
        return profile.copyWith(isPinned: pinnedIds.contains(profile.id));
      }).toList();

      return Right(updatedProfiles.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getAllUserProfiles() async {
    try {
      final profiles = await localDataSource.getCachedUserProfiles();

      if (profiles.isEmpty) {
        await localDataSource.generateMockData();
        final newProfiles = await localDataSource.getCachedUserProfiles();
        return Right(newProfiles.map((p) => p.toEntity()).toList());
      }

      // Get pinned IDs and update profiles
      final pinnedIds = await localDataSource.getPinnedUserIds();
      final updatedProfiles = profiles.map((profile) {
        return profile.copyWith(isPinned: pinnedIds.contains(profile.id));
      }).toList();

      return Right(updatedProfiles.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure());
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
      final records = await localDataSource.getBMIRecords(userId);
      return Right(records.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure());
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
