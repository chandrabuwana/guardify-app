import 'package:dartz/dartz.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/user_profile.dart';
import '../entities/bmi_record.dart';
import '../entities/bmi_input.dart';
import '../../../../core/domain/entities/paginated_response.dart';

/// Repository interface untuk BMI feature
abstract class BMIRepository {
  /// Get user profile dengan BMI data
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);

  /// Search user profiles (untuk role non-anggota)
  Future<Either<Failure, List<UserProfile>>> searchUserProfiles(String query);

  /// Get semua user profiles (untuk role non-anggota)
  Future<Either<Failure, List<UserProfile>>> getAllUserProfiles();

  /// Get user profiles dengan pagination (untuk role non-anggota)
  Future<Either<Failure, PaginatedResponse<UserProfile>>>
      getUserProfilesPaginated({
    required int page,
    required int pageSize,
  });

  /// Get pinned user profiles dari local storage
  Future<Either<Failure, List<UserProfile>>> getPinnedUserProfiles();

  /// Pin/unpin user profile di local storage
  Future<Either<Failure, void>> togglePinUserProfile(
      String userId, bool isPinned);

  /// Get BMI history untuk user tertentu
  Future<Either<Failure, List<BMIRecord>>> getBMIHistory(String userId);

  /// Add BMI record baru
  Future<Either<Failure, BMIRecord>> addBMIRecord({
    required String userId,
    required BMIInput input,
    String? recordedBy,
  });

  /// Update user profile BMI data
  Future<Either<Failure, UserProfile>> updateUserBMI({
    required String userId,
    required BMIInput input,
  });

  /// Delete BMI record
  Future<Either<Failure, void>> deleteBMIRecord(String recordId);

  /// Filter user profiles by BMI category
  Future<Either<Failure, List<UserProfile>>> filterByCategory(String category);

  /// Filter user profiles by jabatan
  Future<Either<Failure, List<UserProfile>>> filterByJabatan(String jabatan);

  /// Get BMI statistics untuk user
  Future<Either<Failure, Map<String, dynamic>>> getBMIStatistics(String userId);
}
