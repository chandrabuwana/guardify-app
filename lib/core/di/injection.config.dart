// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/attendance/data/datasources/attendance_local_data_source.dart'
    as _i769;
import '../../features/attendance/data/datasources/attendance_rekap_remote_data_source.dart'
    as _i832;
import '../../features/attendance/data/datasources/attendance_remote_data_source.dart'
    as _i680;
import '../../features/attendance/data/repositories/attendance_rekap_repository_impl.dart'
    as _i195;
import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i719;
import '../../features/attendance/domain/repositories/attendance_rekap_repository.dart'
    as _i117;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i477;
import '../../features/attendance/domain/usecases/check_attendance_status_usecase.dart'
    as _i85;
import '../../features/attendance/domain/usecases/check_in_usecase.dart'
    as _i895;
import '../../features/attendance/domain/usecases/check_out_usecase.dart'
    as _i751;
import '../../features/attendance/domain/usecases/get_attendance_history_usecase.dart'
    as _i1041;
import '../../features/attendance/domain/usecases/get_attendance_rekap_detail_usecase.dart'
    as _i737;
import '../../features/attendance/domain/usecases/get_attendance_rekap_usecase.dart'
    as _i665;
import '../../features/attendance/domain/usecases/get_attendance_status_usecase.dart'
    as _i566;
import '../../features/attendance/domain/usecases/submit_attendance_usecase.dart'
    as _i1041;
import '../../features/attendance/domain/usecases/update_attendance_rekap_usecase.dart'
    as _i926;
import '../../features/attendance/domain/usecases/validate_attendance_usecase.dart'
    as _i1023;
import '../../features/attendance/presentation/bloc/attendance_bloc.dart'
    as _i700;
import '../../features/attendance/presentation/bloc/attendance_rekap_bloc.dart'
    as _i598;
import '../../features/attendance/presentation/bloc/attendance_rekap_detail_bloc.dart'
    as _i513;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_use_case.dart' as _i37;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/bmi/data/datasources/bmi_local_data_source.dart'
    as _i341;
import '../../features/bmi/data/datasources/bmi_remote_data_source.dart'
    as _i394;
import '../../features/bmi/data/repositories/bmi_repository_impl.dart' as _i10;
import '../../features/bmi/domain/repositories/bmi_repository.dart' as _i804;
import '../../features/bmi/domain/usecases/calculate_bmi.dart' as _i815;
import '../../features/bmi/domain/usecases/get_bmi_history.dart' as _i931;
import '../../features/bmi/domain/usecases/get_user_profile.dart' as _i547;
import '../../features/bmi/domain/usecases/get_user_profiles_paginated.dart'
    as _i301;
import '../../features/bmi/domain/usecases/manage_pinned_profiles.dart'
    as _i724;
import '../../features/bmi/domain/usecases/search_user_profiles.dart' as _i263;
import '../../features/bmi/presentation/bloc/bmi_bloc.dart' as _i186;
import '../../features/chat/data/datasources/chat_remote_data_source.dart'
    as _i980;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/data/services/signalr_chat_service.dart' as _i374;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/chat/presentation/bloc/chat_bloc.dart' as _i65;
import '../../features/company_regulations/data/datasources/document_local_datasource.dart'
    as _i995;
import '../../features/company_regulations/data/datasources/document_remote_datasource.dart'
    as _i950;
import '../../features/company_regulations/data/repositories/document_repository_impl.dart'
    as _i86;
import '../../features/company_regulations/domain/repositories/document_repository.dart'
    as _i875;
import '../../features/company_regulations/domain/usecases/download_document_usecase.dart'
    as _i347;
import '../../features/company_regulations/domain/usecases/filter_documents_usecase.dart'
    as _i641;
import '../../features/company_regulations/domain/usecases/get_documents_usecase.dart'
    as _i368;
import '../../features/company_regulations/domain/usecases/search_documents_usecase.dart'
    as _i463;
import '../../features/company_regulations/presentation/bloc/document_bloc.dart'
    as _i1030;
import '../../features/cuti/data/datasources/cuti_remote_datasource.dart'
    as _i730;
import '../../features/cuti/data/datasources/cuti_remote_datasource_impl.dart'
    as _i560;
import '../../features/cuti/data/repositories/cuti_repository_impl.dart'
    as _i524;
import '../../features/cuti/domain/repositories/cuti_repository.dart' as _i326;
import '../../features/cuti/domain/usecases/buat_ajuan_cuti.dart' as _i114;
import '../../features/cuti/domain/usecases/delete_cuti.dart' as _i106;
import '../../features/cuti/domain/usecases/edit_cuti.dart' as _i98;
import '../../features/cuti/domain/usecases/filter_cuti.dart' as _i248;
import '../../features/cuti/domain/usecases/get_cuti_kuota.dart' as _i875;
import '../../features/cuti/domain/usecases/get_daftar_cuti_anggota.dart'
    as _i51;
import '../../features/cuti/domain/usecases/get_daftar_cuti_saya.dart' as _i592;
import '../../features/cuti/domain/usecases/get_detail_cuti.dart' as _i241;
import '../../features/cuti/domain/usecases/get_leave_request_type_list.dart'
    as _i540;
import '../../features/cuti/domain/usecases/get_rekap_cuti.dart' as _i850;
import '../../features/cuti/domain/usecases/update_status_cuti.dart' as _i231;
import '../../features/cuti/presentation/bloc/cuti_bloc.dart' as _i83;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/laporan_kegiatan/data/datasources/laporan_kegiatan_remote_data_source.dart'
    as _i104;
import '../../features/laporan_kegiatan/data/repositories/laporan_kegiatan_repository_impl.dart'
    as _i1049;
import '../../features/laporan_kegiatan/domain/repositories/laporan_kegiatan_repository.dart'
    as _i198;
import '../../features/laporan_kegiatan/domain/usecases/get_laporan_detail.dart'
    as _i313;
import '../../features/laporan_kegiatan/domain/usecases/get_laporan_list.dart'
    as _i830;
import '../../features/laporan_kegiatan/domain/usecases/update_status_laporan.dart'
    as _i96;
import '../../features/laporan_kegiatan/domain/usecases/verif_laporan.dart'
    as _i956;
import '../../features/laporan_kegiatan/presentation/bloc/laporan_kegiatan_bloc.dart'
    as _i996;
import '../../features/laporan_kejadian/data/datasources/incident_remote_datasource.dart'
    as _i667;
import '../../features/laporan_kejadian/data/datasources/incident_remote_datasource_impl.dart'
    as _i830;
import '../../features/laporan_kejadian/data/repositories/incident_repository_impl.dart'
    as _i723;
import '../../features/laporan_kejadian/domain/repositories/incident_repository.dart'
    as _i110;
import '../../features/laporan_kejadian/domain/usecases/create_incident_report.dart'
    as _i589;
import '../../features/laporan_kejadian/domain/usecases/edit_incident.dart'
    as _i609;
import '../../features/laporan_kejadian/domain/usecases/get_incident_detail.dart'
    as _i328;
import '../../features/laporan_kejadian/domain/usecases/get_incident_list.dart'
    as _i507;
import '../../features/laporan_kejadian/domain/usecases/get_incident_locations.dart'
    as _i156;
import '../../features/laporan_kejadian/domain/usecases/get_incident_types.dart'
    as _i893;
import '../../features/laporan_kejadian/domain/usecases/get_my_tasks.dart'
    as _i667;
import '../../features/laporan_kejadian/domain/usecases/get_user_list.dart'
    as _i558;
import '../../features/laporan_kejadian/domain/usecases/update_incident_status.dart'
    as _i109;
import '../../features/laporan_kejadian/presentation/bloc/incident_bloc.dart'
    as _i529;
import '../../features/news/data/datasources/news_remote_datasource.dart'
    as _i173;
import '../../features/news/data/datasources/news_remote_datasource_impl.dart'
    as _i303;
import '../../features/news/data/repositories/news_repository_impl.dart'
    as _i164;
import '../../features/news/domain/repositories/news_repository.dart' as _i258;
import '../../features/news/presentation/bloc/news_bloc.dart' as _i476;
import '../../features/panic_button/data/datasources/panic_button_datasource.dart'
    as _i438;
import '../../features/panic_button/data/datasources/panic_button_remote_data_source_impl.dart'
    as _i1041;
import '../../features/panic_button/data/repositories/panic_button_repository_impl.dart'
    as _i265;
import '../../features/panic_button/domain/repositories/panic_button_repository.dart'
    as _i67;
import '../../features/panic_button/domain/usecases/activate_panic_button_usecase.dart'
    as _i802;
import '../../features/panic_button/domain/usecases/get_verification_items_usecase.dart'
    as _i248;
import '../../features/panic_button/presentation/bloc/panic_button_bloc.dart'
    as _i713;
import '../../features/patrol/data/datasources/patrol_remote_data_source.dart'
    as _i518;
import '../../features/patrol/data/datasources/patrol_remote_data_source_impl.dart'
    as _i718;
import '../../features/patrol/data/repositories/patrol_repository_impl.dart'
    as _i196;
import '../../features/patrol/domain/repositories/patrol_repository.dart'
    as _i498;
import '../../features/patrol/domain/usecases/add_patrol_location.dart'
    as _i964;
import '../../features/patrol/domain/usecases/get_patrol_progress.dart'
    as _i959;
import '../../features/patrol/domain/usecases/get_patrol_routes.dart' as _i835;
import '../../features/patrol/domain/usecases/get_patrol_routes_paginated.dart'
    as _i865;
import '../../features/patrol/domain/usecases/submit_attendance.dart' as _i971;
import '../../features/patrol/domain/usecases/verify_location.dart' as _i791;
import '../../features/patrol/presentation/bloc/attendance_bloc.dart' as _i699;
import '../../features/patrol/presentation/bloc/patrol_bloc.dart' as _i0;
import '../../features/personnel/data/datasources/personnel_remote_data_source.dart'
    as _i59;
import '../../features/personnel/data/repositories/personnel_repository_impl.dart'
    as _i741;
import '../../features/personnel/domain/repositories/personnel_repository.dart'
    as _i7;
import '../../features/personnel/domain/usecases/approve_personnel_use_case.dart'
    as _i482;
import '../../features/personnel/domain/usecases/get_personnel_by_status_use_case.dart'
    as _i410;
import '../../features/personnel/domain/usecases/get_personnel_detail_use_case.dart'
    as _i462;
import '../../features/personnel/domain/usecases/revise_personnel_use_case.dart'
    as _i1005;
import '../../features/personnel/presentation/bloc/personnel_bloc.dart'
    as _i416;
import '../../features/profile/data/datasources/profile_local_datasource.dart'
    as _i1046;
import '../../features/profile/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/profile/data/datasources/profile_remote_datasource_impl.dart'
    as _i857;
import '../../features/profile/data/datasources/profile_remote_datasource_mock.dart'
    as _i815;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/get_profile_details_usecase.dart'
    as _i888;
import '../../features/profile/domain/usecases/logout_usecase.dart' as _i17;
import '../../features/profile/domain/usecases/update_name_usecase.dart'
    as _i253;
import '../../features/profile/domain/usecases/update_profile_details_usecase.dart'
    as _i42;
import '../../features/profile/domain/usecases/update_profile_photo_usecase.dart'
    as _i669;
import '../../features/profile/presentation/bloc/profile_bloc.dart' as _i469;
import '../../features/schedule/data/datasources/schedule_remote_data_source.dart'
    as _i738;
import '../../features/schedule/data/repositories/schedule_repository_impl.dart'
    as _i688;
import '../../features/schedule/domain/repositories/schedule_repository.dart'
    as _i736;
import '../../features/schedule/domain/usecases/get_current_shift.dart'
    as _i206;
import '../../features/schedule/domain/usecases/get_current_task.dart' as _i420;
import '../../features/schedule/domain/usecases/get_daily_agenda.dart' as _i123;
import '../../features/schedule/domain/usecases/get_monthly_schedule.dart'
    as _i401;
import '../../features/schedule/domain/usecases/get_schedule_detail.dart'
    as _i310;
import '../../features/schedule/domain/usecases/get_schedule_pengawas.dart'
    as _i969;
import '../../features/schedule/domain/usecases/get_shift_detail.dart' as _i143;
import '../../features/schedule/domain/usecases/get_shift_now.dart' as _i666;
import '../../features/schedule/presentation/bloc/schedule_bloc.dart' as _i1063;
import '../../features/shift/data/datasources/shift_remote_data_source.dart'
    as _i824;
import '../../features/test_result/data/datasources/test_result_api_data_source.dart'
    as _i525;
import '../../features/test_result/data/datasources/test_result_remote_data_source.dart'
    as _i268;
import '../../features/test_result/data/repositories/test_result_repository_impl.dart'
    as _i128;
import '../../features/test_result/domain/repositories/test_result_repository.dart'
    as _i87;
import '../../features/test_result/domain/usecases/get_member_test_results_usecase.dart'
    as _i727;
import '../../features/test_result/domain/usecases/get_member_tests_by_pic_usecase.dart'
    as _i609;
import '../../features/test_result/domain/usecases/get_my_test_results_usecase.dart'
    as _i247;
import '../../features/test_result/domain/usecases/get_test_summary_usecase.dart'
    as _i888;
import '../../features/test_result/presentation/bloc/test_result_bloc.dart'
    as _i852;
import '../../features/tugas_lanjutan/data/datasources/tugas_lanjutan_remote_data_source.dart'
    as _i745;
import '../../features/tugas_lanjutan/data/repositories/tugas_lanjutan_repository_impl.dart'
    as _i890;
import '../../features/tugas_lanjutan/domain/repositories/tugas_lanjutan_repository.dart'
    as _i506;
import '../../features/tugas_lanjutan/domain/usecases/get_progress_summary.dart'
    as _i303;
import '../../features/tugas_lanjutan/domain/usecases/get_tugas_lanjutan_detail.dart'
    as _i268;
import '../../features/tugas_lanjutan/domain/usecases/get_tugas_lanjutan_list.dart'
    as _i648;
import '../../features/tugas_lanjutan/domain/usecases/selesaikan_tugas.dart'
    as _i729;
import '../../features/tugas_lanjutan/presentation/bloc/tugas_lanjutan_bloc.dart'
    as _i806;
import '../network/network_manager.dart' as _i474;
import '../services/api_log_service.dart' as _i448;
import '../services/location_service.dart' as _i669;
import '../services/location_update_service.dart' as _i542;
import 'injection_module.dart' as _i212;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final injectionModule = _$InjectionModule();
  await gh.lazySingletonAsync<_i460.SharedPreferences>(
    () => injectionModule.sharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i361.Dio>(() => injectionModule.dio);
  gh.lazySingleton<_i474.NetworkManager>(() => _i474.NetworkManager());
  gh.lazySingleton<_i669.LocationService>(() => _i669.LocationService());
  gh.lazySingleton<_i374.SignalRChatService>(() => _i374.SignalRChatService());
  gh.lazySingleton<_i327.ProfileRemoteDataSource>(
      () => _i857.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i824.ShiftRemoteDataSource>(
      () => _i824.ShiftRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i448.ApiLogService>(
      () => _i448.ApiLogService(gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i173.NewsRemoteDataSource>(
      () => _i303.NewsRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i730.CutiRemoteDataSource>(
      () => _i560.CutiRemoteDataSourceImpl(gh<_i474.NetworkManager>()));
  gh.factory<_i518.PatrolRemoteDataSource>(
      () => _i718.PatrolRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => injectionModule.authRemoteDataSource(gh<_i361.Dio>()));
  gh.lazySingleton<_i394.BmiRemoteDataSource>(
      () => injectionModule.bmiRemoteDataSource(gh<_i361.Dio>()));
  gh.lazySingleton<_i525.TestResultApiDataSource>(
      () => injectionModule.testResultApiDataSource(gh<_i361.Dio>()));
  gh.lazySingleton<_i980.ChatRemoteDataSource>(
      () => _i980.ChatRemoteDataSource(gh<_i361.Dio>()));
  gh.lazySingleton<_i59.PersonnelRemoteDataSource>(
      () => _i59.PersonnelRemoteDataSource(gh<_i361.Dio>()));
  gh.factory<_i438.PanicButtonDataSource>(
      () => _i1041.PanicButtonRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i667.IncidentRemoteDataSource>(
      () => _i830.IncidentRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i745.TugasLanjutanRemoteDataSource>(
      () => _i745.TugasLanjutanRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i738.ScheduleRemoteDataSource>(
      () => _i738.ScheduleRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i327.ProfileRemoteDataSource>(
    () => _i815.ProfileRemoteDataSourceMock(),
    instanceName: 'mock',
  );
  gh.lazySingleton<_i832.AttendanceRekapRemoteDataSource>(
      () => _i832.AttendanceRekapRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i950.DocumentRemoteDataSource>(
      () => _i950.DocumentRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i268.TestResultRemoteDataSource>(() =>
      _i268.TestResultRemoteDataSourceImpl(
          gh<_i525.TestResultApiDataSource>()));
  gh.lazySingleton<_i110.IncidentRepository>(
      () => _i723.IncidentRepositoryImpl(gh<_i667.IncidentRemoteDataSource>()));
  gh.factory<_i341.BMILocalDataSource>(
      () => _i341.BMILocalDataSource(gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i326.CutiRepository>(() => _i524.CutiRepositoryImpl(
      remoteDataSource: gh<_i730.CutiRemoteDataSource>()));
  gh.factory<_i498.PatrolRepository>(
      () => _i196.PatrolRepositoryImpl(gh<_i518.PatrolRemoteDataSource>()));
  gh.lazySingleton<_i7.PersonnelRepository>(() => _i741.PersonnelRepositoryImpl(
      remoteDataSource: gh<_i59.PersonnelRemoteDataSource>()));
  gh.lazySingleton<_i1046.ProfileLocalDataSource>(
      () => _i1046.ProfileLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i104.LaporanKegiatanRemoteDataSource>(
      () => _i104.LaporanKegiatanRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i258.NewsRepository>(
      () => _i164.NewsRepositoryImpl(gh<_i173.NewsRemoteDataSource>()));
  gh.lazySingleton<_i198.LaporanKegiatanRepository>(() =>
      _i1049.LaporanKegiatanRepositoryImpl(
          remoteDataSource: gh<_i104.LaporanKegiatanRemoteDataSource>()));
  gh.lazySingleton<_i995.DocumentLocalDataSource>(() =>
      _i995.DocumentLocalDataSourceImpl(
          sharedPreferences: gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i769.AttendanceLocalDataSource>(() =>
      _i769.AttendanceLocalDataSourceImpl(
          sharedPreferences: gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i420.ChatRepository>(
      () => injectionModule.chatRepository(gh<_i980.ChatRemoteDataSource>()));
  gh.factory<_i504.ChatRepositoryImpl>(
      () => _i504.ChatRepositoryImpl(gh<_i980.ChatRemoteDataSource>()));
  gh.factory<_i156.GetIncidentLocations>(
      () => _i156.GetIncidentLocations(gh<_i110.IncidentRepository>()));
  gh.factory<_i109.UpdateIncidentStatus>(
      () => _i109.UpdateIncidentStatus(gh<_i110.IncidentRepository>()));
  gh.factory<_i507.GetIncidentList>(
      () => _i507.GetIncidentList(gh<_i110.IncidentRepository>()));
  gh.factory<_i667.GetMyTasks>(
      () => _i667.GetMyTasks(gh<_i110.IncidentRepository>()));
  gh.factory<_i589.CreateIncidentReport>(
      () => _i589.CreateIncidentReport(gh<_i110.IncidentRepository>()));
  gh.factory<_i893.GetIncidentTypes>(
      () => _i893.GetIncidentTypes(gh<_i110.IncidentRepository>()));
  gh.factory<_i328.GetIncidentDetail>(
      () => _i328.GetIncidentDetail(gh<_i110.IncidentRepository>()));
  gh.factory<_i609.EditIncident>(
      () => _i609.EditIncident(gh<_i110.IncidentRepository>()));
  gh.factory<_i558.GetUserList>(
      () => _i558.GetUserList(gh<_i110.IncidentRepository>()));
  gh.factory<_i65.ChatBloc>(() => _i65.ChatBloc(
        gh<_i420.ChatRepository>(),
        gh<_i374.SignalRChatService>(),
      ));
  gh.lazySingleton<_i787.AuthRepository>(
      () => injectionModule.authRepository(gh<_i107.AuthRemoteDataSource>()));
  gh.lazySingleton<_i37.LoginRepository>(
      () => injectionModule.loginRepository(gh<_i107.AuthRemoteDataSource>()));
  gh.lazySingleton<_i67.PanicButtonRepository>(
      () => _i265.PanicButtonRepositoryImpl(gh<_i438.PanicButtonDataSource>()));
  gh.lazySingleton<_i736.ScheduleRepository>(() => _i688.ScheduleRepositoryImpl(
      remoteDataSource: gh<_i738.ScheduleRemoteDataSource>()));
  gh.factory<_i802.ActivatePanicButtonUseCase>(
      () => _i802.ActivatePanicButtonUseCase(gh<_i67.PanicButtonRepository>()));
  gh.factory<_i248.GetVerificationItemsUseCase>(() =>
      _i248.GetVerificationItemsUseCase(gh<_i67.PanicButtonRepository>()));
  gh.factory<_i529.IncidentBloc>(() => _i529.IncidentBloc(
        getIncidentList: gh<_i507.GetIncidentList>(),
        getMyTasks: gh<_i667.GetMyTasks>(),
        getIncidentDetail: gh<_i328.GetIncidentDetail>(),
        createIncidentReport: gh<_i589.CreateIncidentReport>(),
        getIncidentLocations: gh<_i156.GetIncidentLocations>(),
        getIncidentTypes: gh<_i893.GetIncidentTypes>(),
        updateIncidentStatus: gh<_i109.UpdateIncidentStatus>(),
        editIncident: gh<_i609.EditIncident>(),
      ));
  gh.factory<_i476.NewsBloc>(
      () => injectionModule.newsBloc(gh<_i258.NewsRepository>()));
  gh.lazySingleton<_i87.TestResultRepository>(() =>
      _i128.TestResultRepositoryImpl(
          remoteDataSource: gh<_i268.TestResultRemoteDataSource>()));
  gh.factory<_i401.GetMonthlySchedule>(
      () => _i401.GetMonthlySchedule(gh<_i736.ScheduleRepository>()));
  gh.factory<_i310.GetScheduleDetail>(
      () => _i310.GetScheduleDetail(gh<_i736.ScheduleRepository>()));
  gh.factory<_i420.GetCurrentTask>(
      () => _i420.GetCurrentTask(gh<_i736.ScheduleRepository>()));
  gh.factory<_i969.GetSchedulePengawas>(
      () => _i969.GetSchedulePengawas(gh<_i736.ScheduleRepository>()));
  gh.factory<_i123.GetDailyAgenda>(
      () => _i123.GetDailyAgenda(gh<_i736.ScheduleRepository>()));
  gh.factory<_i206.GetCurrentShift>(
      () => _i206.GetCurrentShift(gh<_i736.ScheduleRepository>()));
  gh.factory<_i143.GetShiftDetail>(
      () => _i143.GetShiftDetail(gh<_i736.ScheduleRepository>()));
  gh.factory<_i666.GetShiftNow>(
      () => _i666.GetShiftNow(gh<_i736.ScheduleRepository>()));
  gh.lazySingleton<_i680.AttendanceRemoteDataSource>(
      () => _i680.AttendanceRemoteDataSourceImpl(
            dio: gh<_i361.Dio>(),
            scheduleRemoteDataSource: gh<_i738.ScheduleRemoteDataSource>(),
          ));
  gh.lazySingleton<_i875.DocumentRepository>(() => _i86.DocumentRepositoryImpl(
        remoteDataSource: gh<_i950.DocumentRemoteDataSource>(),
        localDataSource: gh<_i995.DocumentLocalDataSource>(),
      ));
  gh.factory<_i956.VerifLaporan>(
      () => _i956.VerifLaporan(gh<_i198.LaporanKegiatanRepository>()));
  gh.factory<_i830.GetLaporanList>(
      () => _i830.GetLaporanList(gh<_i198.LaporanKegiatanRepository>()));
  gh.factory<_i96.UpdateStatusLaporan>(
      () => _i96.UpdateStatusLaporan(gh<_i198.LaporanKegiatanRepository>()));
  gh.factory<_i313.GetLaporanDetail>(
      () => _i313.GetLaporanDetail(gh<_i198.LaporanKegiatanRepository>()));
  gh.factory<_i117.AttendanceRekapRepository>(() =>
      _i195.AttendanceRekapRepositoryImpl(
          remoteDataSource: gh<_i832.AttendanceRekapRemoteDataSource>()));
  gh.factory<_i713.PanicButtonBloc>(() => _i713.PanicButtonBloc(
        activatePanicButtonUseCase: gh<_i802.ActivatePanicButtonUseCase>(),
        getVerificationItemsUseCase: gh<_i248.GetVerificationItemsUseCase>(),
        panicButtonRepository: gh<_i67.PanicButtonRepository>(),
      ));
  gh.factory<_i592.GetDaftarCutiSaya>(
      () => _i592.GetDaftarCutiSaya(gh<_i326.CutiRepository>()));
  gh.factory<_i241.GetDetailCuti>(
      () => _i241.GetDetailCuti(gh<_i326.CutiRepository>()));
  gh.factory<_i98.EditCuti>(() => _i98.EditCuti(gh<_i326.CutiRepository>()));
  gh.factory<_i106.DeleteCuti>(
      () => _i106.DeleteCuti(gh<_i326.CutiRepository>()));
  gh.factory<_i248.FilterCuti>(
      () => _i248.FilterCuti(gh<_i326.CutiRepository>()));
  gh.factory<_i850.GetRekapCuti>(
      () => _i850.GetRekapCuti(gh<_i326.CutiRepository>()));
  gh.factory<_i231.UpdateStatusCuti>(
      () => _i231.UpdateStatusCuti(gh<_i326.CutiRepository>()));
  gh.factory<_i540.GetLeaveRequestTypeList>(
      () => _i540.GetLeaveRequestTypeList(gh<_i326.CutiRepository>()));
  gh.factory<_i51.GetDaftarCutiAnggota>(
      () => _i51.GetDaftarCutiAnggota(gh<_i326.CutiRepository>()));
  gh.factory<_i114.BuatAjuanCuti>(
      () => _i114.BuatAjuanCuti(gh<_i326.CutiRepository>()));
  gh.factory<_i875.GetCutiKuota>(
      () => _i875.GetCutiKuota(gh<_i326.CutiRepository>()));
  gh.lazySingleton<_i506.TugasLanjutanRepository>(
      () => _i890.TugasLanjutanRepositoryImpl(
            gh<_i745.TugasLanjutanRemoteDataSource>(),
            gh<_i420.GetCurrentTask>(),
            gh<_i206.GetCurrentShift>(),
          ));
  gh.factory<_i996.LaporanKegiatanBloc>(() => _i996.LaporanKegiatanBloc(
        getLaporanList: gh<_i830.GetLaporanList>(),
        getLaporanDetail: gh<_i313.GetLaporanDetail>(),
        updateStatusLaporan: gh<_i96.UpdateStatusLaporan>(),
        verifLaporan: gh<_i956.VerifLaporan>(),
      ));
  gh.factory<_i1063.ScheduleBloc>(() => _i1063.ScheduleBloc(
        getMonthlySchedule: gh<_i401.GetMonthlySchedule>(),
        getShiftDetail: gh<_i143.GetShiftDetail>(),
        getDailyAgenda: gh<_i123.GetDailyAgenda>(),
        getScheduleDetail: gh<_i310.GetScheduleDetail>(),
        getSchedulePengawas: gh<_i969.GetSchedulePengawas>(),
      ));
  gh.factory<_i462.GetPersonnelDetailUseCase>(
      () => _i462.GetPersonnelDetailUseCase(gh<_i7.PersonnelRepository>()));
  gh.factory<_i1005.RevisePersonnelUseCase>(
      () => _i1005.RevisePersonnelUseCase(gh<_i7.PersonnelRepository>()));
  gh.factory<_i410.GetPersonnelByStatusUseCase>(
      () => _i410.GetPersonnelByStatusUseCase(gh<_i7.PersonnelRepository>()));
  gh.factory<_i482.ApprovePersonnelUseCase>(
      () => _i482.ApprovePersonnelUseCase(gh<_i7.PersonnelRepository>()));
  gh.factory<_i865.GetPatrolRoutesPaginated>(
      () => _i865.GetPatrolRoutesPaginated(gh<_i498.PatrolRepository>()));
  gh.factory<_i964.AddPatrolLocation>(
      () => _i964.AddPatrolLocation(gh<_i498.PatrolRepository>()));
  gh.factory<_i959.GetPatrolProgress>(
      () => _i959.GetPatrolProgress(gh<_i498.PatrolRepository>()));
  gh.factory<_i791.VerifyLocation>(
      () => _i791.VerifyLocation(gh<_i498.PatrolRepository>()));
  gh.factory<_i971.SubmitAttendance>(
      () => _i971.SubmitAttendance(gh<_i498.PatrolRepository>()));
  gh.factory<_i835.GetPatrolRoutes>(
      () => _i835.GetPatrolRoutes(gh<_i498.PatrolRepository>()));
  gh.factory<_i37.LoginUseCase>(
      () => _i37.LoginUseCase(gh<_i37.LoginRepository>()));
  gh.factory<_i463.SearchDocumentsUseCase>(
      () => _i463.SearchDocumentsUseCase(gh<_i875.DocumentRepository>()));
  gh.factory<_i641.FilterDocumentsUseCase>(
      () => _i641.FilterDocumentsUseCase(gh<_i875.DocumentRepository>()));
  gh.factory<_i368.GetDocumentsUseCase>(
      () => _i368.GetDocumentsUseCase(gh<_i875.DocumentRepository>()));
  gh.factory<_i347.DownloadDocumentUseCase>(
      () => _i347.DownloadDocumentUseCase(gh<_i875.DocumentRepository>()));
  gh.factory<_i804.BMIRepository>(() => _i10.BMIRepositoryImpl(
        gh<_i341.BMILocalDataSource>(),
        gh<_i394.BmiRemoteDataSource>(),
      ));
  gh.factory<_i83.CutiBloc>(() => _i83.CutiBloc(
        getCutiKuota: gh<_i875.GetCutiKuota>(),
        getDaftarCutiSaya: gh<_i592.GetDaftarCutiSaya>(),
        getDaftarCutiAnggota: gh<_i51.GetDaftarCutiAnggota>(),
        buatAjuanCuti: gh<_i114.BuatAjuanCuti>(),
        updateStatusCuti: gh<_i231.UpdateStatusCuti>(),
        filterCuti: gh<_i248.FilterCuti>(),
        getDetailCuti: gh<_i241.GetDetailCuti>(),
        getRekapCuti: gh<_i850.GetRekapCuti>(),
        getLeaveRequestTypeList: gh<_i540.GetLeaveRequestTypeList>(),
        editCuti: gh<_i98.EditCuti>(),
        deleteCuti: gh<_i106.DeleteCuti>(),
      ));
  gh.factory<_i0.PatrolBloc>(() => _i0.PatrolBloc(
        getPatrolRoutes: gh<_i835.GetPatrolRoutes>(),
        getPatrolRoutesPaginated: gh<_i865.GetPatrolRoutesPaginated>(),
        getPatrolProgress: gh<_i959.GetPatrolProgress>(),
        addPatrolLocation: gh<_i964.AddPatrolLocation>(),
        patrolRepository: gh<_i498.PatrolRepository>(),
      ));
  gh.factory<_i727.GetMemberTestResultsUseCase>(
      () => _i727.GetMemberTestResultsUseCase(gh<_i87.TestResultRepository>()));
  gh.factory<_i609.GetMemberTestsByPicUseCase>(
      () => _i609.GetMemberTestsByPicUseCase(gh<_i87.TestResultRepository>()));
  gh.factory<_i888.GetTestSummaryUseCase>(
      () => _i888.GetTestSummaryUseCase(gh<_i87.TestResultRepository>()));
  gh.factory<_i247.GetMyTestResultsUseCase>(
      () => _i247.GetMyTestResultsUseCase(gh<_i87.TestResultRepository>()));
  gh.lazySingleton<_i894.ProfileRepository>(() => _i334.ProfileRepositoryImpl(
        remoteDataSource: gh<_i327.ProfileRemoteDataSource>(),
        localDataSource: gh<_i1046.ProfileLocalDataSource>(),
        authRepository: gh<_i787.AuthRepository>(),
      ));
  gh.factory<_i477.AttendanceRepository>(() => _i719.AttendanceRepositoryImpl(
        remoteDataSource: gh<_i680.AttendanceRemoteDataSource>(),
        localDataSource: gh<_i769.AttendanceLocalDataSource>(),
      ));
  gh.factory<_i1030.DocumentBloc>(() => _i1030.DocumentBloc(
        getDocumentsUseCase: gh<_i368.GetDocumentsUseCase>(),
        searchDocumentsUseCase: gh<_i463.SearchDocumentsUseCase>(),
        filterDocumentsUseCase: gh<_i641.FilterDocumentsUseCase>(),
        downloadDocumentUseCase: gh<_i347.DownloadDocumentUseCase>(),
      ));
  gh.factory<_i202.HomeBloc>(() => _i202.HomeBloc(
        gh<_i865.GetPatrolRoutesPaginated>(),
        gh<_i206.GetCurrentShift>(),
        gh<_i420.GetCurrentTask>(),
        gh<_i666.GetShiftNow>(),
      ));
  gh.factory<_i301.GetUserProfilesPaginated>(
      () => _i301.GetUserProfilesPaginated(gh<_i804.BMIRepository>()));
  gh.factory<_i547.GetUserProfile>(
      () => _i547.GetUserProfile(gh<_i804.BMIRepository>()));
  gh.factory<_i815.CalculateBMI>(
      () => _i815.CalculateBMI(gh<_i804.BMIRepository>()));
  gh.factory<_i263.SearchUserProfiles>(
      () => _i263.SearchUserProfiles(gh<_i804.BMIRepository>()));
  gh.factory<_i931.GetBMIHistory>(
      () => _i931.GetBMIHistory(gh<_i804.BMIRepository>()));
  gh.factory<_i724.ManagePinnedProfiles>(
      () => _i724.ManagePinnedProfiles(gh<_i804.BMIRepository>()));
  gh.factory<_i566.GetAttendanceStatusUseCase>(
      () => _i566.GetAttendanceStatusUseCase(gh<_i477.AttendanceRepository>()));
  gh.factory<_i1041.SubmitAttendanceUseCase>(
      () => _i1041.SubmitAttendanceUseCase(gh<_i477.AttendanceRepository>()));
  gh.factory<_i1041.GetAttendanceHistoryUseCase>(() =>
      _i1041.GetAttendanceHistoryUseCase(gh<_i477.AttendanceRepository>()));
  gh.factory<_i895.CheckInUseCase>(
      () => _i895.CheckInUseCase(gh<_i477.AttendanceRepository>()));
  gh.factory<_i751.CheckOutUseCase>(
      () => _i751.CheckOutUseCase(gh<_i477.AttendanceRepository>()));
  gh.factory<_i85.CheckAttendanceStatusUseCase>(() =>
      _i85.CheckAttendanceStatusUseCase(gh<_i477.AttendanceRepository>()));
  gh.factory<_i1023.ValidateAttendanceUseCase>(
      () => _i1023.ValidateAttendanceUseCase(gh<_i477.AttendanceRepository>()));
  gh.factory<_i729.SelesaikanTugas>(
      () => _i729.SelesaikanTugas(gh<_i506.TugasLanjutanRepository>()));
  gh.factory<_i268.GetTugasLanjutanDetail>(
      () => _i268.GetTugasLanjutanDetail(gh<_i506.TugasLanjutanRepository>()));
  gh.factory<_i303.GetProgressSummary>(
      () => _i303.GetProgressSummary(gh<_i506.TugasLanjutanRepository>()));
  gh.factory<_i648.GetTugasLanjutanList>(
      () => _i648.GetTugasLanjutanList(gh<_i506.TugasLanjutanRepository>()));
  gh.factory<_i926.UpdateAttendanceRekapUseCase>(() =>
      _i926.UpdateAttendanceRekapUseCase(
          gh<_i117.AttendanceRekapRepository>()));
  gh.factory<_i665.GetAttendanceRekapUseCase>(() =>
      _i665.GetAttendanceRekapUseCase(gh<_i117.AttendanceRekapRepository>()));
  gh.factory<_i737.GetAttendanceRekapDetailUseCase>(() =>
      _i737.GetAttendanceRekapDetailUseCase(
          gh<_i117.AttendanceRekapRepository>()));
  gh.factory<_i699.PatrolAttendanceBloc>(() => _i699.PatrolAttendanceBloc(
        submitAttendance: gh<_i971.SubmitAttendance>(),
        verifyLocation: gh<_i791.VerifyLocation>(),
        repository: gh<_i498.PatrolRepository>(),
      ));
  gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
        gh<_i37.LoginUseCase>(),
        gh<_i107.AuthRemoteDataSource>(),
      ));
  gh.factory<_i888.GetProfileDetailsUseCase>(
      () => _i888.GetProfileDetailsUseCase(gh<_i894.ProfileRepository>()));
  gh.factory<_i253.UpdateNameUseCase>(
      () => _i253.UpdateNameUseCase(gh<_i894.ProfileRepository>()));
  gh.factory<_i17.LogoutUseCase>(
      () => _i17.LogoutUseCase(gh<_i894.ProfileRepository>()));
  gh.factory<_i42.UpdateProfileDetailsUseCase>(
      () => _i42.UpdateProfileDetailsUseCase(gh<_i894.ProfileRepository>()));
  gh.factory<_i669.UpdateProfilePhotoUseCase>(
      () => _i669.UpdateProfilePhotoUseCase(gh<_i894.ProfileRepository>()));
  gh.factory<_i416.PersonnelBloc>(() => _i416.PersonnelBloc(
        getPersonnelByStatusUseCase: gh<_i410.GetPersonnelByStatusUseCase>(),
        getPersonnelDetailUseCase: gh<_i462.GetPersonnelDetailUseCase>(),
        approvePersonnelUseCase: gh<_i482.ApprovePersonnelUseCase>(),
        revisePersonnelUseCase: gh<_i1005.RevisePersonnelUseCase>(),
      ));
  gh.factory<_i513.AttendanceRekapDetailBloc>(() =>
      _i513.AttendanceRekapDetailBloc(
        getAttendanceRekapDetailUseCase:
            gh<_i737.GetAttendanceRekapDetailUseCase>(),
        updateAttendanceRekapUseCase: gh<_i926.UpdateAttendanceRekapUseCase>(),
      ));
  gh.factory<_i186.BMIBloc>(() => _i186.BMIBloc(
        getUserProfile: gh<_i547.GetUserProfile>(),
        searchUserProfiles: gh<_i263.SearchUserProfiles>(),
        getUserProfilesPaginated: gh<_i301.GetUserProfilesPaginated>(),
        managePinnedProfiles: gh<_i724.ManagePinnedProfiles>(),
        calculateBMI: gh<_i815.CalculateBMI>(),
        getBMIHistory: gh<_i931.GetBMIHistory>(),
      ));
  gh.factory<_i852.TestResultBloc>(() => _i852.TestResultBloc(
        getMyResultsUseCase: gh<_i247.GetMyTestResultsUseCase>(),
        getMemberResultsUseCase: gh<_i727.GetMemberTestResultsUseCase>(),
        getSummaryUseCase: gh<_i888.GetTestSummaryUseCase>(),
        getMemberTestsByPicUseCase: gh<_i609.GetMemberTestsByPicUseCase>(),
      ));
  gh.factory<_i598.AttendanceRekapBloc>(() => _i598.AttendanceRekapBloc(
      getAttendanceRekapUseCase: gh<_i665.GetAttendanceRekapUseCase>()));
  gh.lazySingleton<_i542.LocationUpdateService>(
      () => _i542.LocationUpdateService(
            dio: gh<_i361.Dio>(),
            attendanceRepository: gh<_i477.AttendanceRepository>(),
            getAttendanceStatusUseCase: gh<_i566.GetAttendanceStatusUseCase>(),
          ));
  gh.factory<_i806.TugasLanjutanBloc>(() => _i806.TugasLanjutanBloc(
        getTugasLanjutanList: gh<_i648.GetTugasLanjutanList>(),
        getTugasLanjutanDetail: gh<_i268.GetTugasLanjutanDetail>(),
        selesaikanTugas: gh<_i729.SelesaikanTugas>(),
        getProgressSummary: gh<_i303.GetProgressSummary>(),
      ));
  gh.factory<_i700.AttendanceBloc>(() => _i700.AttendanceBloc(
        checkInUseCase: gh<_i895.CheckInUseCase>(),
        checkOutUseCase: gh<_i751.CheckOutUseCase>(),
        getAttendanceStatusUseCase: gh<_i566.GetAttendanceStatusUseCase>(),
      ));
  gh.factory<_i469.ProfileBloc>(() => _i469.ProfileBloc(
        getProfileDetailsUseCase: gh<_i888.GetProfileDetailsUseCase>(),
        updateProfileDetailsUseCase: gh<_i42.UpdateProfileDetailsUseCase>(),
        updateNameUseCase: gh<_i253.UpdateNameUseCase>(),
        updateProfilePhotoUseCase: gh<_i669.UpdateProfilePhotoUseCase>(),
        logoutUseCase: gh<_i17.LogoutUseCase>(),
        profileRepository: gh<_i894.ProfileRepository>(),
      ));
  return getIt;
}

class _$InjectionModule extends _i212.InjectionModule {}
