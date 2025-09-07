// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
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

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i890.HomeBloc>(() => _i890.HomeBloc());
    gh.lazySingleton<_i460.PanicButtonDataSource>(
        () => _i754.PanicButtonLocalDataSource());
    gh.lazySingleton<_i228.PanicButtonRepository>(() =>
        _i908.PanicButtonRepositoryImpl(gh<_i460.PanicButtonDataSource>()));
    gh.factory<_i491.ActivatePanicButtonUseCase>(() =>
        _i491.ActivatePanicButtonUseCase(gh<_i228.PanicButtonRepository>()));
    gh.factory<_i4.GetVerificationItemsUseCase>(() =>
        _i4.GetVerificationItemsUseCase(gh<_i228.PanicButtonRepository>()));
    gh.factory<_i893.PanicButtonBloc>(() => _i893.PanicButtonBloc(
          activatePanicButtonUseCase: gh<_i491.ActivatePanicButtonUseCase>(),
          getVerificationItemsUseCase: gh<_i4.GetVerificationItemsUseCase>(),
        ));
    return this;
  }
}
