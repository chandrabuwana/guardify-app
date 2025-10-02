// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:guardify_app/core/di/external_dependencies_module.dart'
    as _i267;
import 'package:guardify_app/features/attendance/data/datasources/attendance_local_data_source.dart'
    as _i1007;
import 'package:guardify_app/features/attendance/data/datasources/attendance_remote_data_source.dart'
    as _i109;
import 'package:guardify_app/features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i289;
import 'package:guardify_app/features/attendance/domain/repositories/attendance_repository.dart'
    as _i311;
import 'package:guardify_app/features/attendance/domain/usecases/check_attendance_status_usecase.dart'
    as _i202;
import 'package:guardify_app/features/attendance/domain/usecases/check_in_usecase.dart'
    as _i865;
import 'package:guardify_app/features/attendance/domain/usecases/check_out_usecase.dart'
    as _i968;
import 'package:guardify_app/features/attendance/domain/usecases/get_attendance_history_usecase.dart'
    as _i624;
import 'package:guardify_app/features/attendance/domain/usecases/get_attendance_status_usecase.dart'
    as _i385;
import 'package:guardify_app/features/attendance/domain/usecases/submit_attendance_usecase.dart'
    as _i974;
import 'package:guardify_app/features/attendance/domain/usecases/validate_attendance_usecase.dart'
    as _i601;
import 'package:guardify_app/features/attendance/presentation/bloc/attendance_bloc.dart'
    as _i908;
import 'package:guardify_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i296;
import 'package:guardify_app/features/bmi/data/datasources/bmi_local_data_source.dart'
    as _i826;
import 'package:guardify_app/features/bmi/data/repositories/bmi_repository_impl.dart'
    as _i989;
import 'package:guardify_app/features/bmi/domain/repositories/bmi_repository.dart'
    as _i814;
import 'package:guardify_app/features/bmi/domain/usecases/calculate_bmi.dart'
    as _i283;
import 'package:guardify_app/features/bmi/domain/usecases/get_bmi_history.dart'
    as _i817;
import 'package:guardify_app/features/bmi/domain/usecases/get_user_profile.dart'
    as _i283;
import 'package:guardify_app/features/bmi/domain/usecases/manage_pinned_profiles.dart'
    as _i572;
import 'package:guardify_app/features/bmi/domain/usecases/search_user_profiles.dart'
    as _i708;
import 'package:guardify_app/features/bmi/presentation/bloc/bmi_bloc.dart'
    as _i21;
import 'package:guardify_app/features/company_regulations/data/datasources/document_local_datasource.dart'
    as _i313;
import 'package:guardify_app/features/company_regulations/data/datasources/document_remote_datasource.dart'
    as _i125;
import 'package:guardify_app/features/company_regulations/data/repositories/document_repository_impl.dart'
    as _i117;
import 'package:guardify_app/features/company_regulations/domain/repositories/document_repository.dart'
    as _i695;
import 'package:guardify_app/features/company_regulations/domain/usecases/download_document_usecase.dart'
    as _i179;
import 'package:guardify_app/features/company_regulations/domain/usecases/filter_documents_usecase.dart'
    as _i1037;
import 'package:guardify_app/features/company_regulations/domain/usecases/get_documents_usecase.dart'
    as _i718;
import 'package:guardify_app/features/company_regulations/domain/usecases/search_documents_usecase.dart'
    as _i1020;
import 'package:guardify_app/features/company_regulations/presentation/bloc/document_bloc.dart'
    as _i286;
import 'package:guardify_app/features/home/presentation/bloc/home_bloc.dart'
    as _i890;
import 'package:guardify_app/features/panic_button/data/datasources/panic_button_datasource.dart'
    as _i460;
import 'package:guardify_app/features/panic_button/data/datasources/panic_button_local_datasource.dart'
    as _i754;
import 'package:guardify_app/features/panic_button/data/repositories/panic_button_repository_impl.dart'
    as _i908;
import 'package:guardify_app/features/panic_button/domain/repositories/panic_button_repository.dart'
    as _i228;
import 'package:guardify_app/features/panic_button/domain/usecases/activate_panic_button_usecase.dart'
    as _i491;
import 'package:guardify_app/features/panic_button/domain/usecases/get_verification_items_usecase.dart'
    as _i4;
import 'package:guardify_app/features/panic_button/presentation/bloc/panic_button_bloc.dart'
    as _i893;
import 'package:guardify_app/features/patrol/data/datasources/patrol_remote_data_source.dart'
    as _i1037;
import 'package:guardify_app/features/patrol/data/datasources/patrol_remote_data_source_impl.dart'
    as _i681;
import 'package:guardify_app/features/patrol/data/repositories/patrol_repository_impl.dart'
    as _i369;
import 'package:guardify_app/features/patrol/domain/repositories/patrol_repository.dart'
    as _i824;
import 'package:guardify_app/features/patrol/domain/usecases/add_patrol_location.dart'
    as _i198;
import 'package:guardify_app/features/patrol/domain/usecases/get_patrol_progress.dart'
    as _i820;
import 'package:guardify_app/features/patrol/domain/usecases/get_patrol_routes.dart'
    as _i759;
import 'package:guardify_app/features/patrol/domain/usecases/submit_attendance.dart'
    as _i861;
import 'package:guardify_app/features/patrol/domain/usecases/verify_location.dart'
    as _i9;
import 'package:guardify_app/features/patrol/presentation/bloc/attendance_bloc.dart'
    as _i849;
import 'package:guardify_app/features/patrol/presentation/bloc/patrol_bloc.dart'
    as _i416;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final externalDependenciesModule = _$ExternalDependenciesModule();
    gh.factory<_i296.AuthBloc>(() => _i296.AuthBloc());
    gh.factory<_i890.HomeBloc>(() => _i890.HomeBloc());
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => externalDependenciesModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => externalDependenciesModule.dio);
    gh.lazySingleton<_i460.PanicButtonDataSource>(
        () => _i754.PanicButtonLocalDataSource());
    gh.lazySingleton<_i228.PanicButtonRepository>(() =>
        _i908.PanicButtonRepositoryImpl(gh<_i460.PanicButtonDataSource>()));
    gh.factory<_i1037.PatrolRemoteDataSource>(
        () => _i681.PatrolRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.factory<_i491.ActivatePanicButtonUseCase>(() =>
        _i491.ActivatePanicButtonUseCase(gh<_i228.PanicButtonRepository>()));
    gh.factory<_i4.GetVerificationItemsUseCase>(() =>
        _i4.GetVerificationItemsUseCase(gh<_i228.PanicButtonRepository>()));
    gh.lazySingleton<_i125.DocumentRemoteDataSource>(
        () => _i125.DocumentRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
    gh.factory<_i826.BMILocalDataSource>(
        () => _i826.BMILocalDataSource(gh<_i460.SharedPreferences>()));
    gh.factory<_i824.PatrolRepository>(
        () => _i369.PatrolRepositoryImpl(gh<_i1037.PatrolRemoteDataSource>()));
    gh.lazySingleton<_i109.AttendanceRemoteDataSource>(
        () => _i109.AttendanceRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
    gh.factory<_i893.PanicButtonBloc>(() => _i893.PanicButtonBloc(
          activatePanicButtonUseCase: gh<_i491.ActivatePanicButtonUseCase>(),
          getVerificationItemsUseCase: gh<_i4.GetVerificationItemsUseCase>(),
        ));
    gh.lazySingleton<_i313.DocumentLocalDataSource>(() =>
        _i313.DocumentLocalDataSourceImpl(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i1007.AttendanceLocalDataSource>(() =>
        _i1007.AttendanceLocalDataSourceImpl(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.factory<_i814.BMIRepository>(
        () => _i989.BMIRepositoryImpl(gh<_i826.BMILocalDataSource>()));
    gh.lazySingleton<_i695.DocumentRepository>(
        () => _i117.DocumentRepositoryImpl(
              remoteDataSource: gh<_i125.DocumentRemoteDataSource>(),
              localDataSource: gh<_i313.DocumentLocalDataSource>(),
            ));
    gh.factory<_i198.AddPatrolLocation>(
        () => _i198.AddPatrolLocation(gh<_i824.PatrolRepository>()));
    gh.factory<_i820.GetPatrolProgress>(
        () => _i820.GetPatrolProgress(gh<_i824.PatrolRepository>()));
    gh.factory<_i759.GetPatrolRoutes>(
        () => _i759.GetPatrolRoutes(gh<_i824.PatrolRepository>()));
    gh.factory<_i861.SubmitAttendance>(
        () => _i861.SubmitAttendance(gh<_i824.PatrolRepository>()));
    gh.factory<_i9.VerifyLocation>(
        () => _i9.VerifyLocation(gh<_i824.PatrolRepository>()));
    gh.factory<_i179.DownloadDocumentUseCase>(
        () => _i179.DownloadDocumentUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i1037.FilterDocumentsUseCase>(
        () => _i1037.FilterDocumentsUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i718.GetDocumentsUseCase>(
        () => _i718.GetDocumentsUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i1020.SearchDocumentsUseCase>(
        () => _i1020.SearchDocumentsUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i416.PatrolBloc>(() => _i416.PatrolBloc(
          getPatrolRoutes: gh<_i759.GetPatrolRoutes>(),
          getPatrolProgress: gh<_i820.GetPatrolProgress>(),
        ));
    gh.factory<_i311.AttendanceRepository>(() => _i289.AttendanceRepositoryImpl(
          remoteDataSource: gh<_i109.AttendanceRemoteDataSource>(),
          localDataSource: gh<_i1007.AttendanceLocalDataSource>(),
        ));
    gh.factory<_i286.DocumentBloc>(() => _i286.DocumentBloc(
          getDocumentsUseCase: gh<_i718.GetDocumentsUseCase>(),
          searchDocumentsUseCase: gh<_i1020.SearchDocumentsUseCase>(),
          filterDocumentsUseCase: gh<_i1037.FilterDocumentsUseCase>(),
          downloadDocumentUseCase: gh<_i179.DownloadDocumentUseCase>(),
        ));
    gh.factory<_i283.CalculateBMI>(
        () => _i283.CalculateBMI(gh<_i814.BMIRepository>()));
    gh.factory<_i817.GetBMIHistory>(
        () => _i817.GetBMIHistory(gh<_i814.BMIRepository>()));
    gh.factory<_i283.GetUserProfile>(
        () => _i283.GetUserProfile(gh<_i814.BMIRepository>()));
    gh.factory<_i572.ManagePinnedProfiles>(
        () => _i572.ManagePinnedProfiles(gh<_i814.BMIRepository>()));
    gh.factory<_i708.SearchUserProfiles>(
        () => _i708.SearchUserProfiles(gh<_i814.BMIRepository>()));
    gh.factory<_i202.CheckAttendanceStatusUseCase>(() =>
        _i202.CheckAttendanceStatusUseCase(gh<_i311.AttendanceRepository>()));
    gh.factory<_i865.CheckInUseCase>(
        () => _i865.CheckInUseCase(gh<_i311.AttendanceRepository>()));
    gh.factory<_i968.CheckOutUseCase>(
        () => _i968.CheckOutUseCase(gh<_i311.AttendanceRepository>()));
    gh.factory<_i624.GetAttendanceHistoryUseCase>(() =>
        _i624.GetAttendanceHistoryUseCase(gh<_i311.AttendanceRepository>()));
    gh.factory<_i385.GetAttendanceStatusUseCase>(() =>
        _i385.GetAttendanceStatusUseCase(gh<_i311.AttendanceRepository>()));
    gh.factory<_i974.SubmitAttendanceUseCase>(
        () => _i974.SubmitAttendanceUseCase(gh<_i311.AttendanceRepository>()));
    gh.factory<_i601.ValidateAttendanceUseCase>(() =>
        _i601.ValidateAttendanceUseCase(gh<_i311.AttendanceRepository>()));
    gh.factory<_i849.PatrolAttendanceBloc>(() => _i849.PatrolAttendanceBloc(
          submitAttendance: gh<_i861.SubmitAttendance>(),
          verifyLocation: gh<_i9.VerifyLocation>(),
          repository: gh<_i824.PatrolRepository>(),
        ));
    gh.factory<_i21.BMIBloc>(() => _i21.BMIBloc(
          getUserProfile: gh<_i283.GetUserProfile>(),
          searchUserProfiles: gh<_i708.SearchUserProfiles>(),
          managePinnedProfiles: gh<_i572.ManagePinnedProfiles>(),
          calculateBMI: gh<_i283.CalculateBMI>(),
          getBMIHistory: gh<_i817.GetBMIHistory>(),
        ));
    gh.factory<_i908.AttendanceBloc>(() => _i908.AttendanceBloc(
          checkInUseCase: gh<_i865.CheckInUseCase>(),
          checkOutUseCase: gh<_i968.CheckOutUseCase>(),
          getAttendanceStatusUseCase: gh<_i385.GetAttendanceStatusUseCase>(),
        ));
    return this;
  }
}

class _$ExternalDependenciesModule extends _i267.ExternalDependenciesModule {}
