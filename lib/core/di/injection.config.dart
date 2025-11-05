// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:guardify_app/core/di/injection_module.dart' as _i381;
import 'package:guardify_app/core/network/network_manager.dart' as _i39;
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
import 'package:guardify_app/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i650;
import 'package:guardify_app/features/auth/domain/repositories/auth_repository.dart'
    as _i144;
import 'package:guardify_app/features/auth/domain/usecases/login_use_case.dart'
    as _i551;
import 'package:guardify_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i296;
import 'package:guardify_app/features/bmi/data/datasources/bmi_local_data_source.dart'
    as _i826;
import 'package:guardify_app/features/bmi/data/datasources/bmi_remote_data_source.dart'
    as _i163;
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
import 'package:guardify_app/features/bmi/domain/usecases/get_user_profiles_paginated.dart'
    as _i1059;
import 'package:guardify_app/features/bmi/domain/usecases/manage_pinned_profiles.dart'
    as _i572;
import 'package:guardify_app/features/bmi/domain/usecases/search_user_profiles.dart'
    as _i708;
import 'package:guardify_app/features/bmi/presentation/bloc/bmi_bloc.dart'
    as _i21;
import 'package:guardify_app/features/chat/data/repositories/chat_repository_impl.dart'
    as _i255;
import 'package:guardify_app/features/chat/domain/repositories/chat_repository.dart'
    as _i523;
import 'package:guardify_app/features/chat/presentation/bloc/chat_bloc.dart'
    as _i313;
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
import 'package:guardify_app/features/cuti/data/datasources/cuti_remote_datasource.dart'
    as _i783;
import 'package:guardify_app/features/cuti/data/datasources/cuti_remote_datasource_impl.dart'
    as _i222;
import 'package:guardify_app/features/cuti/data/repositories/cuti_repository_impl.dart'
    as _i591;
import 'package:guardify_app/features/cuti/domain/repositories/cuti_repository.dart'
    as _i825;
import 'package:guardify_app/features/cuti/domain/usecases/buat_ajuan_cuti.dart'
    as _i341;
import 'package:guardify_app/features/cuti/domain/usecases/filter_cuti.dart'
    as _i639;
import 'package:guardify_app/features/cuti/domain/usecases/get_cuti_kuota.dart'
    as _i1067;
import 'package:guardify_app/features/cuti/domain/usecases/get_daftar_cuti_anggota.dart'
    as _i722;
import 'package:guardify_app/features/cuti/domain/usecases/get_daftar_cuti_saya.dart'
    as _i1023;
import 'package:guardify_app/features/cuti/domain/usecases/get_detail_cuti.dart'
    as _i505;
import 'package:guardify_app/features/cuti/domain/usecases/get_rekap_cuti.dart'
    as _i515;
import 'package:guardify_app/features/cuti/domain/usecases/update_status_cuti.dart'
    as _i688;
import 'package:guardify_app/features/cuti/presentation/bloc/cuti_bloc.dart'
    as _i215;
import 'package:guardify_app/features/home/presentation/bloc/home_bloc.dart'
    as _i890;
import 'package:guardify_app/features/laporan_kegiatan/data/datasources/laporan_kegiatan_remote_data_source.dart'
    as _i590;
import 'package:guardify_app/features/laporan_kegiatan/data/repositories/laporan_kegiatan_repository_impl.dart'
    as _i713;
import 'package:guardify_app/features/laporan_kegiatan/domain/repositories/laporan_kegiatan_repository.dart'
    as _i352;
import 'package:guardify_app/features/laporan_kegiatan/domain/usecases/get_laporan_detail.dart'
    as _i272;
import 'package:guardify_app/features/laporan_kegiatan/domain/usecases/get_laporan_list.dart'
    as _i970;
import 'package:guardify_app/features/laporan_kegiatan/domain/usecases/update_status_laporan.dart'
    as _i189;
import 'package:guardify_app/features/laporan_kegiatan/presentation/bloc/laporan_kegiatan_bloc.dart'
    as _i945;
import 'package:guardify_app/features/news/data/datasources/news_remote_datasource.dart'
    as _i606;
import 'package:guardify_app/features/news/data/datasources/news_remote_datasource_impl.dart'
    as _i116;
import 'package:guardify_app/features/news/data/repositories/news_repository_impl.dart'
    as _i203;
import 'package:guardify_app/features/news/domain/repositories/news_repository.dart'
    as _i54;
import 'package:guardify_app/features/news/presentation/bloc/news_bloc.dart'
    as _i505;
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
import 'package:guardify_app/features/patrol/domain/usecases/get_patrol_routes_paginated.dart'
    as _i238;
import 'package:guardify_app/features/patrol/domain/usecases/submit_attendance.dart'
    as _i861;
import 'package:guardify_app/features/patrol/domain/usecases/verify_location.dart'
    as _i9;
import 'package:guardify_app/features/patrol/presentation/bloc/attendance_bloc.dart'
    as _i849;
import 'package:guardify_app/features/patrol/presentation/bloc/patrol_bloc.dart'
    as _i416;
import 'package:guardify_app/features/profile/data/datasources/profile_local_datasource.dart'
    as _i895;
import 'package:guardify_app/features/profile/data/datasources/profile_remote_datasource.dart'
    as _i220;
import 'package:guardify_app/features/profile/data/datasources/profile_remote_datasource_impl.dart'
    as _i1020;
import 'package:guardify_app/features/profile/data/datasources/profile_remote_datasource_mock.dart'
    as _i945;
import 'package:guardify_app/features/profile/data/repositories/profile_repository_impl.dart'
    as _i422;
import 'package:guardify_app/features/profile/domain/repositories/profile_repository.dart'
    as _i252;
import 'package:guardify_app/features/profile/domain/usecases/get_profile_details_usecase.dart'
    as _i264;
import 'package:guardify_app/features/profile/domain/usecases/logout_usecase.dart'
    as _i936;
import 'package:guardify_app/features/profile/domain/usecases/update_name_usecase.dart'
    as _i1045;
import 'package:guardify_app/features/profile/domain/usecases/update_profile_details_usecase.dart'
    as _i409;
import 'package:guardify_app/features/profile/domain/usecases/update_profile_photo_usecase.dart'
    as _i508;
import 'package:guardify_app/features/profile/presentation/bloc/profile_bloc.dart'
    as _i641;
import 'package:guardify_app/features/schedule/data/datasources/schedule_remote_data_source.dart'
    as _i563;
import 'package:guardify_app/features/schedule/data/repositories/schedule_repository_impl.dart'
    as _i343;
import 'package:guardify_app/features/schedule/domain/repositories/schedule_repository.dart'
    as _i752;
import 'package:guardify_app/features/schedule/domain/usecases/get_daily_agenda.dart'
    as _i369;
import 'package:guardify_app/features/schedule/domain/usecases/get_monthly_schedule.dart'
    as _i1034;
import 'package:guardify_app/features/schedule/domain/usecases/get_shift_detail.dart'
    as _i947;
import 'package:guardify_app/features/schedule/presentation/bloc/schedule_bloc.dart'
    as _i1003;
import 'package:guardify_app/features/test_result/data/datasources/test_result_api_data_source.dart'
    as _i836;
import 'package:guardify_app/features/test_result/data/datasources/test_result_remote_data_source.dart'
    as _i652;
import 'package:guardify_app/features/test_result/data/repositories/test_result_repository_impl.dart'
    as _i717;
import 'package:guardify_app/features/test_result/domain/repositories/test_result_repository.dart'
    as _i422;
import 'package:guardify_app/features/test_result/domain/usecases/get_member_test_results_usecase.dart'
    as _i930;
import 'package:guardify_app/features/test_result/domain/usecases/get_member_tests_by_pic_usecase.dart'
    as _i332;
import 'package:guardify_app/features/test_result/domain/usecases/get_my_test_results_usecase.dart'
    as _i743;
import 'package:guardify_app/features/test_result/domain/usecases/get_test_summary_usecase.dart'
    as _i227;
import 'package:guardify_app/features/test_result/presentation/bloc/test_result_bloc.dart'
    as _i1060;
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
    final injectionModule = _$InjectionModule();
    gh.factory<_i255.ChatRepositoryImpl>(() => _i255.ChatRepositoryImpl());
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => injectionModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => injectionModule.dio);
    gh.lazySingleton<_i523.ChatRepository>(
        () => injectionModule.chatRepository());
    gh.lazySingleton<_i39.NetworkManager>(() => _i39.NetworkManager());
    gh.lazySingleton<_i220.ProfileRemoteDataSource>(
        () => _i1020.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i460.PanicButtonDataSource>(
        () => _i754.PanicButtonLocalDataSource());
    gh.lazySingleton<_i228.PanicButtonRepository>(() =>
        _i908.PanicButtonRepositoryImpl(gh<_i460.PanicButtonDataSource>()));
    gh.lazySingleton<_i606.NewsRemoteDataSource>(
        () => _i116.NewsRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.factory<_i563.ScheduleRemoteDataSource>(
        () => _i563.ScheduleRemoteDataSourceImpl());
    gh.lazySingleton<_i783.CutiRemoteDataSource>(
        () => _i222.CutiRemoteDataSourceImpl(gh<_i39.NetworkManager>()));
    gh.factory<_i1037.PatrolRemoteDataSource>(
        () => _i681.PatrolRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.factory<_i491.ActivatePanicButtonUseCase>(() =>
        _i491.ActivatePanicButtonUseCase(gh<_i228.PanicButtonRepository>()));
    gh.factory<_i4.GetVerificationItemsUseCase>(() =>
        _i4.GetVerificationItemsUseCase(gh<_i228.PanicButtonRepository>()));
    gh.lazySingleton<_i590.LaporanKegiatanRemoteDataSource>(
        () => _i590.LaporanKegiatanRemoteDataSourceImpl());
    gh.lazySingleton<_i650.AuthRemoteDataSource>(
        () => injectionModule.authRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i163.BmiRemoteDataSource>(
        () => injectionModule.bmiRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i836.TestResultApiDataSource>(
        () => injectionModule.testResultApiDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i220.ProfileRemoteDataSource>(
      () => _i945.ProfileRemoteDataSourceMock(),
      instanceName: 'mock',
    );
    gh.factory<_i313.ChatBloc>(
        () => injectionModule.chatBloc(gh<_i523.ChatRepository>()));
    gh.lazySingleton<_i125.DocumentRemoteDataSource>(
        () => _i125.DocumentRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
    gh.lazySingleton<_i652.TestResultRemoteDataSource>(() =>
        _i652.TestResultRemoteDataSourceImpl(
            gh<_i836.TestResultApiDataSource>()));
    gh.factory<_i826.BMILocalDataSource>(
        () => _i826.BMILocalDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i825.CutiRepository>(() => _i591.CutiRepositoryImpl(
        remoteDataSource: gh<_i783.CutiRemoteDataSource>()));
    gh.factory<_i824.PatrolRepository>(
        () => _i369.PatrolRepositoryImpl(gh<_i1037.PatrolRemoteDataSource>()));
    gh.lazySingleton<_i895.ProfileLocalDataSource>(
        () => _i895.ProfileLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i54.NewsRepository>(
        () => _i203.NewsRepositoryImpl(gh<_i606.NewsRemoteDataSource>()));
    gh.lazySingleton<_i352.LaporanKegiatanRepository>(() =>
        _i713.LaporanKegiatanRepositoryImpl(
            remoteDataSource: gh<_i590.LaporanKegiatanRemoteDataSource>()));
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
    gh.lazySingleton<_i144.AuthRepository>(
        () => injectionModule.authRepository(gh<_i650.AuthRemoteDataSource>()));
    gh.lazySingleton<_i551.LoginRepository>(() =>
        injectionModule.loginRepository(gh<_i650.AuthRemoteDataSource>()));
    gh.lazySingleton<_i752.ScheduleRepository>(() =>
        _i343.ScheduleRepositoryImpl(
            remoteDataSource: gh<_i563.ScheduleRemoteDataSource>()));
    gh.factory<_i505.NewsBloc>(
        () => injectionModule.newsBloc(gh<_i54.NewsRepository>()));
    gh.lazySingleton<_i422.TestResultRepository>(() =>
        _i717.TestResultRepositoryImpl(
            remoteDataSource: gh<_i652.TestResultRemoteDataSource>()));
    gh.factory<_i369.GetDailyAgenda>(
        () => _i369.GetDailyAgenda(gh<_i752.ScheduleRepository>()));
    gh.factory<_i1034.GetMonthlySchedule>(
        () => _i1034.GetMonthlySchedule(gh<_i752.ScheduleRepository>()));
    gh.factory<_i947.GetShiftDetail>(
        () => _i947.GetShiftDetail(gh<_i752.ScheduleRepository>()));
    gh.factory<_i1003.ScheduleBloc>(() => _i1003.ScheduleBloc(
          getMonthlySchedule: gh<_i1034.GetMonthlySchedule>(),
          getShiftDetail: gh<_i947.GetShiftDetail>(),
          getDailyAgenda: gh<_i369.GetDailyAgenda>(),
        ));
    gh.lazySingleton<_i695.DocumentRepository>(
        () => _i117.DocumentRepositoryImpl(
              remoteDataSource: gh<_i125.DocumentRemoteDataSource>(),
              localDataSource: gh<_i313.DocumentLocalDataSource>(),
            ));
    gh.factory<_i272.GetLaporanDetail>(
        () => _i272.GetLaporanDetail(gh<_i352.LaporanKegiatanRepository>()));
    gh.factory<_i970.GetLaporanList>(
        () => _i970.GetLaporanList(gh<_i352.LaporanKegiatanRepository>()));
    gh.factory<_i189.UpdateStatusLaporan>(
        () => _i189.UpdateStatusLaporan(gh<_i352.LaporanKegiatanRepository>()));
    gh.factory<_i341.BuatAjuanCuti>(
        () => _i341.BuatAjuanCuti(gh<_i825.CutiRepository>()));
    gh.factory<_i639.FilterCuti>(
        () => _i639.FilterCuti(gh<_i825.CutiRepository>()));
    gh.factory<_i1067.GetCutiKuota>(
        () => _i1067.GetCutiKuota(gh<_i825.CutiRepository>()));
    gh.factory<_i722.GetDaftarCutiAnggota>(
        () => _i722.GetDaftarCutiAnggota(gh<_i825.CutiRepository>()));
    gh.factory<_i1023.GetDaftarCutiSaya>(
        () => _i1023.GetDaftarCutiSaya(gh<_i825.CutiRepository>()));
    gh.factory<_i505.GetDetailCuti>(
        () => _i505.GetDetailCuti(gh<_i825.CutiRepository>()));
    gh.factory<_i515.GetRekapCuti>(
        () => _i515.GetRekapCuti(gh<_i825.CutiRepository>()));
    gh.factory<_i688.UpdateStatusCuti>(
        () => _i688.UpdateStatusCuti(gh<_i825.CutiRepository>()));
    gh.factory<_i198.AddPatrolLocation>(
        () => _i198.AddPatrolLocation(gh<_i824.PatrolRepository>()));
    gh.factory<_i820.GetPatrolProgress>(
        () => _i820.GetPatrolProgress(gh<_i824.PatrolRepository>()));
    gh.factory<_i759.GetPatrolRoutes>(
        () => _i759.GetPatrolRoutes(gh<_i824.PatrolRepository>()));
    gh.factory<_i238.GetPatrolRoutesPaginated>(
        () => _i238.GetPatrolRoutesPaginated(gh<_i824.PatrolRepository>()));
    gh.factory<_i861.SubmitAttendance>(
        () => _i861.SubmitAttendance(gh<_i824.PatrolRepository>()));
    gh.factory<_i9.VerifyLocation>(
        () => _i9.VerifyLocation(gh<_i824.PatrolRepository>()));
    gh.factory<_i551.LoginUseCase>(
        () => _i551.LoginUseCase(gh<_i551.LoginRepository>()));
    gh.factory<_i179.DownloadDocumentUseCase>(
        () => _i179.DownloadDocumentUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i1037.FilterDocumentsUseCase>(
        () => _i1037.FilterDocumentsUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i718.GetDocumentsUseCase>(
        () => _i718.GetDocumentsUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i1020.SearchDocumentsUseCase>(
        () => _i1020.SearchDocumentsUseCase(gh<_i695.DocumentRepository>()));
    gh.factory<_i814.BMIRepository>(() => _i989.BMIRepositoryImpl(
          gh<_i826.BMILocalDataSource>(),
          gh<_i163.BmiRemoteDataSource>(),
        ));
    gh.factory<_i215.CutiBloc>(() => _i215.CutiBloc(
          getCutiKuota: gh<_i1067.GetCutiKuota>(),
          getDaftarCutiSaya: gh<_i1023.GetDaftarCutiSaya>(),
          getDaftarCutiAnggota: gh<_i722.GetDaftarCutiAnggota>(),
          buatAjuanCuti: gh<_i341.BuatAjuanCuti>(),
          updateStatusCuti: gh<_i688.UpdateStatusCuti>(),
          filterCuti: gh<_i639.FilterCuti>(),
          getDetailCuti: gh<_i505.GetDetailCuti>(),
          getRekapCuti: gh<_i515.GetRekapCuti>(),
        ));
    gh.factory<_i332.GetMemberTestsByPicUseCase>(() =>
        _i332.GetMemberTestsByPicUseCase(gh<_i422.TestResultRepository>()));
    gh.factory<_i930.GetMemberTestResultsUseCase>(() =>
        _i930.GetMemberTestResultsUseCase(gh<_i422.TestResultRepository>()));
    gh.factory<_i743.GetMyTestResultsUseCase>(
        () => _i743.GetMyTestResultsUseCase(gh<_i422.TestResultRepository>()));
    gh.factory<_i227.GetTestSummaryUseCase>(
        () => _i227.GetTestSummaryUseCase(gh<_i422.TestResultRepository>()));
    gh.lazySingleton<_i252.ProfileRepository>(() => _i422.ProfileRepositoryImpl(
          remoteDataSource: gh<_i220.ProfileRemoteDataSource>(),
          localDataSource: gh<_i895.ProfileLocalDataSource>(),
          authRepository: gh<_i144.AuthRepository>(),
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
    gh.factory<_i1059.GetUserProfilesPaginated>(
        () => _i1059.GetUserProfilesPaginated(gh<_i814.BMIRepository>()));
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
    gh.factory<_i890.HomeBloc>(
        () => _i890.HomeBloc(gh<_i238.GetPatrolRoutesPaginated>()));
    gh.factory<_i416.PatrolBloc>(() => _i416.PatrolBloc(
          getPatrolRoutes: gh<_i759.GetPatrolRoutes>(),
          getPatrolRoutesPaginated: gh<_i238.GetPatrolRoutesPaginated>(),
          getPatrolProgress: gh<_i820.GetPatrolProgress>(),
          addPatrolLocation: gh<_i198.AddPatrolLocation>(),
        ));
    gh.factory<_i945.LaporanKegiatanBloc>(() => _i945.LaporanKegiatanBloc(
          getLaporanList: gh<_i970.GetLaporanList>(),
          getLaporanDetail: gh<_i272.GetLaporanDetail>(),
          updateStatusLaporan: gh<_i189.UpdateStatusLaporan>(),
        ));
    gh.factory<_i849.PatrolAttendanceBloc>(() => _i849.PatrolAttendanceBloc(
          submitAttendance: gh<_i861.SubmitAttendance>(),
          verifyLocation: gh<_i9.VerifyLocation>(),
          repository: gh<_i824.PatrolRepository>(),
        ));
    gh.factory<_i264.GetProfileDetailsUseCase>(
        () => _i264.GetProfileDetailsUseCase(gh<_i252.ProfileRepository>()));
    gh.factory<_i936.LogoutUseCase>(
        () => _i936.LogoutUseCase(gh<_i252.ProfileRepository>()));
    gh.factory<_i1045.UpdateNameUseCase>(
        () => _i1045.UpdateNameUseCase(gh<_i252.ProfileRepository>()));
    gh.factory<_i409.UpdateProfileDetailsUseCase>(
        () => _i409.UpdateProfileDetailsUseCase(gh<_i252.ProfileRepository>()));
    gh.factory<_i508.UpdateProfilePhotoUseCase>(
        () => _i508.UpdateProfilePhotoUseCase(gh<_i252.ProfileRepository>()));
    gh.factory<_i296.AuthBloc>(() => _i296.AuthBloc(gh<_i551.LoginUseCase>()));
    gh.factory<_i21.BMIBloc>(() => _i21.BMIBloc(
          getUserProfile: gh<_i283.GetUserProfile>(),
          searchUserProfiles: gh<_i708.SearchUserProfiles>(),
          getUserProfilesPaginated: gh<_i1059.GetUserProfilesPaginated>(),
          managePinnedProfiles: gh<_i572.ManagePinnedProfiles>(),
          calculateBMI: gh<_i283.CalculateBMI>(),
          getBMIHistory: gh<_i817.GetBMIHistory>(),
        ));
    gh.factory<_i1060.TestResultBloc>(() => _i1060.TestResultBloc(
          getMyResultsUseCase: gh<_i743.GetMyTestResultsUseCase>(),
          getMemberResultsUseCase: gh<_i930.GetMemberTestResultsUseCase>(),
          getSummaryUseCase: gh<_i227.GetTestSummaryUseCase>(),
          getMemberTestsByPicUseCase: gh<_i332.GetMemberTestsByPicUseCase>(),
        ));
    gh.factory<_i908.AttendanceBloc>(() => _i908.AttendanceBloc(
          checkInUseCase: gh<_i865.CheckInUseCase>(),
          checkOutUseCase: gh<_i968.CheckOutUseCase>(),
          getAttendanceStatusUseCase: gh<_i385.GetAttendanceStatusUseCase>(),
        ));
    gh.factory<_i641.ProfileBloc>(() => _i641.ProfileBloc(
          getProfileDetailsUseCase: gh<_i264.GetProfileDetailsUseCase>(),
          updateProfileDetailsUseCase: gh<_i409.UpdateProfileDetailsUseCase>(),
          updateNameUseCase: gh<_i1045.UpdateNameUseCase>(),
          updateProfilePhotoUseCase: gh<_i508.UpdateProfilePhotoUseCase>(),
          logoutUseCase: gh<_i936.LogoutUseCase>(),
          profileRepository: gh<_i252.ProfileRepository>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i381.InjectionModule {}
