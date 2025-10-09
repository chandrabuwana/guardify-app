import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../constants/app_constants.dart';

/// Injection Module - Centralized Dependency Registration
/// Semua dependencies diregister di sini untuk memudahkan maintenance
@module
abstract class InjectionModule {
  // ========================================
  // External Dependencies (Third Party)
  // ========================================
  
  /// SharedPreferences - Persistent Storage
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// Dio - HTTP Client
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    
    // Base Configuration
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // ValidateStatus - Jangan throw exception untuk 4xx error
    // Biarkan kita handle sendiri di repository
    dio.options.validateStatus = (status) {
      // Accept semua status code, handle error di repository layer
      return status != null && status < 500;
    };
    
    // Headers
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Interceptors (optional: untuk logging, auth token, dll)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
    
    return dio;
  }

  // ========================================
  // Auth Feature Dependencies
  // ========================================
  
  /// Auth Remote Data Source
  @lazySingleton
  AuthRemoteDataSource authRemoteDataSource(Dio dio) {
    return AuthRemoteDataSource(dio);
  }

  /// Auth Repository Implementation
  @lazySingleton
  AuthRepository authRepository(AuthRemoteDataSource remoteDataSource) {
    return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  /// Login Repository (for LoginUseCase)
  @lazySingleton
  LoginRepository loginRepository(AuthRemoteDataSource remoteDataSource) {
    return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  // ========================================
  // Tambahkan dependencies feature lain di sini
  // Contoh:
  // - Profile Feature
  // - Attendance Feature
  // - Patrol Feature
  // - dll
  // ========================================
}
