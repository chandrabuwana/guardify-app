// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:guardify_app/core/di/external_dependencies_module.dart'
    as _i267;
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
    gh.lazySingleton<_i460.PanicButtonDataSource>(
        () => _i754.PanicButtonLocalDataSource());
    gh.lazySingleton<_i228.PanicButtonRepository>(() =>
        _i908.PanicButtonRepositoryImpl(gh<_i460.PanicButtonDataSource>()));
    gh.factory<_i491.ActivatePanicButtonUseCase>(() =>
        _i491.ActivatePanicButtonUseCase(gh<_i228.PanicButtonRepository>()));
    gh.factory<_i4.GetVerificationItemsUseCase>(() =>
        _i4.GetVerificationItemsUseCase(gh<_i228.PanicButtonRepository>()));
    gh.factory<_i826.BMILocalDataSource>(
        () => _i826.BMILocalDataSource(gh<_i460.SharedPreferences>()));
    gh.factory<_i893.PanicButtonBloc>(() => _i893.PanicButtonBloc(
          activatePanicButtonUseCase: gh<_i491.ActivatePanicButtonUseCase>(),
          getVerificationItemsUseCase: gh<_i4.GetVerificationItemsUseCase>(),
        ));
    gh.factory<_i814.BMIRepository>(
        () => _i989.BMIRepositoryImpl(gh<_i826.BMILocalDataSource>()));
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
    gh.factory<_i21.BMIBloc>(() => _i21.BMIBloc(
          getUserProfile: gh<_i283.GetUserProfile>(),
          searchUserProfiles: gh<_i708.SearchUserProfiles>(),
          managePinnedProfiles: gh<_i572.ManagePinnedProfiles>(),
          calculateBMI: gh<_i283.CalculateBMI>(),
          getBMIHistory: gh<_i817.GetBMIHistory>(),
        ));
    return this;
  }
}

class _$ExternalDependenciesModule extends _i267.ExternalDependenciesModule {}
