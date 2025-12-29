import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/entities/paginated_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_location.dart';
import '../../domain/entities/patrol_attendance.dart';
import '../../domain/entities/patrol_progress.dart';
import '../../domain/repositories/patrol_repository.dart';
import '../datasources/patrol_remote_data_source.dart';
import '../datasources/patrol_remote_data_source_impl.dart';
import '../models/patrol_attendance_model.dart';
import '../models/patrol_location_model.dart';
import '../models/route_detail_api_response.dart';
import '../models/patrol_check_point_request.dart';
import '../../../auth/data/models/role_model.dart';
import '../mappers/route_detail_mapper.dart';
import '../mappers/area_mapper.dart';

@Injectable(as: PatrolRepository)
class PatrolRepositoryImpl implements PatrolRepository {
  final PatrolRemoteDataSource remoteDataSource;

  PatrolRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<PatrolRoute>>>
      getPatrolRoutesPaginated({
    required int page,
    required int pageSize,
  }) async {
    try {
      print(
          '[PatrolRepository] Fetching patrol routes (RouteDetail/list) - page: $page, pageSize: $pageSize');

      // Use /RouteDetail/list endpoint (has complete route info with locations)
      final response = await remoteDataSource.getRouteDetailList(
        start: page,
        length: pageSize,
      );

      // Convert RouteDetailModel list to PatrolRoute list
      final paginatedRoutes = RouteDetailMapper.toPaginatedPatrolRoutes(
        response,
        page,
        pageSize,
      );

      print(
          '[PatrolRepository] Success: ${paginatedRoutes.data.length} routes loaded from /RouteDetail/list');
      return Right(paginatedRoutes);
    } catch (e) {
      print('[PatrolRepository] Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PatrolRoute>>> getPatrolRoutes() async {
    try {
      final routes = await remoteDataSource.getPatrolRoutes();
      return Right(routes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatrolRoute>> getRouteDetailById(
      String routeId) async {
    try {
      print('[PatrolRepository] Fetching route details for ID: $routeId');

      // Fetch route details from /RouteDetail/list filtered by route ID
      final response = await remoteDataSource.getRouteDetailList(
        start: 0,
        length: 100, // Get all locations for this route
        filter: [
          FilterModel(field: 'IdRoute', search: routeId),
        ],
      );

      if (response.list == null || response.list!.isEmpty) {
        return Left(ServerFailure('Route not found'));
      }

      // Convert to PatrolRoute with locations
      final routes = RouteDetailMapper.toPaginatedPatrolRoutes(
        response,
        0,
        100,
      );

      if (routes.data.isEmpty) {
        return Left(ServerFailure('Failed to parse route details'));
      }

      print(
          '[PatrolRepository] Route details loaded: ${routes.data.first.locations.length} locations');
      return Right(routes.data.first);
    } catch (e) {
      print('[PatrolRepository] Error fetching route details: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatrolRoute>> getPatrolRouteById(String id) async {
    try {
      final route = await remoteDataSource.getPatrolRouteById(id);
      return Right(route);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatrolProgress>> getPatrolProgress(
      String routeId) async {
    try {
      final progressData = await remoteDataSource.getPatrolProgress(routeId);
      final progress = PatrolProgress(
        completedCount: progressData['completed'] ?? 0,
        totalCount: progressData['total'] ?? 0,
      );
      return Right(progress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitAttendance(
      PatrolAttendance attendance) async {
    try {
      final attendanceModel = PatrolAttendanceModel(
        id: attendance.id,
        patrolLocationId: attendance.patrolLocationId,
        userId: attendance.userId,
        timestamp: attendance.timestamp,
        currentLatitude: attendance.currentLatitude,
        currentLongitude: attendance.currentLongitude,
        currentAddress: attendance.currentAddress,
        proofImagePath: attendance.proofImagePath,
        notes: attendance.notes,
        isLocationVerified: attendance.isLocationVerified,
        status: attendance.status,
      );

      final result = await remoteDataSource.submitAttendance(attendanceModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyLocation(
    double currentLat,
    double currentLng,
    double targetLat,
    double targetLng,
  ) async {
    try {
      final result = await remoteDataSource.verifyLocation(
        currentLat,
        currentLng,
        targetLat,
        targetLng,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatrolLocation>> addPatrolLocation(
    String routeId,
    PatrolLocation location,
  ) async {
    try {
      final locationModel = PatrolLocationModel(
        id: location.id,
        name: location.name,
        description: location.description,
        latitude: location.latitude,
        longitude: location.longitude,
        address: location.address,
        status: location.status,
        completedAt: location.completedAt,
        proofImagePath: location.proofImagePath,
        notes: location.notes,
        isAdditional: location.isAdditional,
      );

      final result =
          await remoteDataSource.addPatrolLocation(routeId, locationModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProofImage(String imagePath) async {
    try {
      final result = await remoteDataSource.uploadProofImage(imagePath);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentLocation() async {
    try {
      // Mock current location for development
      await Future.delayed(const Duration(seconds: 1));

      // Mock location coordinates (Jakarta area)
      const mockLat = -6.173056780703297;
      const mockLng = 106.78692883979942;

      final address = 'Current Location: $mockLat, $mockLng';
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PatrolLocation>>> getAreasByIdAreas(String idAreas) async {
    try {
      print('[PatrolRepository] Fetching areas for IdAreas: $idAreas');

      // Use filter field "IdAreas" as per API specification
      final response = await remoteDataSource.getAreaList(
        start: 0,
        length: 0, // Length set to 0 as per API requirement
        filter: [
          FilterModel(field: 'IdAreas', search: idAreas),
        ],
      );

      if (response.list.isEmpty) {
        return Left(ServerFailure('No areas found for IdAreas: $idAreas'));
      }

      // Convert AreaModel list to PatrolLocation list
      final locations = AreaMapper.toPatrolLocations(response.list);
      print('[PatrolRepository] Success: ${locations.length} areas loaded for IdAreas: $idAreas');
      return Right(locations);
    } catch (e) {
      print('[PatrolRepository] Error fetching areas by IdAreas: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PatrolLocation>>> getAllAreas() async {
    try {
      print('[PatrolRepository] Fetching all areas for dropdown');

      // Get all areas without filter (empty filter)
      final response = await remoteDataSource.getAreaList(
        start: 0,
        length: 0, // Length set to 0 to get all records
        filter: [],
      );

      // Convert AreaModel list to PatrolLocation list
      final locations = AreaMapper.toPatrolLocations(response.list);
      print('[PatrolRepository] Success: ${locations.length} areas loaded');
      return Right(locations);
    } catch (e) {
      print('[PatrolRepository] Error fetching all areas: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  static const double _hardcodedLatitude = -6.12407;
  static const double _hardcodedLongitude = 106.8831;

  @override
  Future<Either<Failure, bool>> submitCheckPoint({
    required String idShiftDetail,
    required String idAreas,
    String? photoPath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      print('[PatrolRepository] Submitting check point...');
      print('  - IdShiftDetail: $idShiftDetail');
      print('  - IdAreas: $idAreas');
      print('  - Photo path: $photoPath');

      // Use hardcoded lat/lng
      final finalLatitude = _hardcodedLatitude;
      final finalLongitude = _hardcodedLongitude;

      // Build photo patroli
      PhotoPatroliModel? photoPatroli;
      if (photoPath != null && photoPath.isNotEmpty) {
        final encodedPhoto = await _encodePhoto(photoPath);
        if (encodedPhoto != null) {
          photoPatroli = PhotoPatroliModel(
            filename: encodedPhoto['Filename'] as String,
            mimeType: encodedPhoto['MimeType'] as String,
            base64: encodedPhoto['Base64'] as String,
          );
        }
      }

      // Build token payload
      final tokenPayload = await _buildTokenPayload();
      if (tokenPayload == null) {
        return Left(ServerFailure('Token information not available'));
      }

      // Resolve device name
      final deviceName = await _resolveDeviceName();

      // Build request
      final request = PatrolCheckPointRequest(
        idShiftDetail: idShiftDetail,
        photoPatroli: photoPatroli,
        idAreas: idAreas,
        deviceName: deviceName,
        latitude: finalLatitude,
        longitude: finalLongitude,
        token: tokenPayload,
      );

      // Submit
      final result = await remoteDataSource.submitCheckPoint(request);
      return Right(result);
    } on CheckPointException catch (e) {
      print('[PatrolRepository] CheckPointException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('[PatrolRepository] Error submitting check point: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<String> _resolveDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown Device';
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceName = '${info.manufacturer} ${info.model}';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        final machine = info.utsname.machine;
        deviceName = machine.isNotEmpty ? machine : 'iPhone';
      }
    } catch (_) {}
    return deviceName;
  }

  Future<Map<String, dynamic>?> _encodePhoto(String path) async {
    if (path.isEmpty) return null;
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);
      final filename = path.split(RegExp(r'[\/\\]')).last;
      final ext = filename.contains('.') ? filename.split('.').last.toLowerCase() : '';
      final mime = _guessMimeType(ext);
      return {
        'Filename': filename,
        'MimeType': mime,
        'Base64': base64Str,
      };
    } catch (_) {
      return null;
    }
  }

  String _guessMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }

  Future<TokenModel?> _buildTokenPayload() async {
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
    final roleId = await SecurityManager.readSecurely('user_role_id');
    final roleName = await SecurityManager.readSecurely('user_role_name');
    final username = await SecurityManager.readSecurely('user_username');
    final fullName = await SecurityManager.readSecurely('user_fullname');
    final mail = await SecurityManager.readSecurely('user_mail');

    final hasUserInfo = [
      userId,
      roleId,
      roleName,
      username,
      fullName,
      mail,
    ].any((value) => value != null && value.isNotEmpty);

    if (!hasUserInfo) return null;

    return TokenModel(
      id: userId ?? '',
      role: [
        RoleModel(
          id: roleId ?? '',
          nama: roleName ?? '',
        ),
      ],
      username: username ?? '',
      fullName: fullName ?? '',
      mail: mail ?? '',
    );
  }
}
