import 'package:get_it/get_it.dart';
import 'data/datasources/test_result_remote_data_source.dart';
import 'data/repositories/test_result_repository_impl.dart';
import 'domain/repositories/test_result_repository.dart';
import 'domain/usecases/get_my_test_results_usecase.dart';
import 'domain/usecases/get_member_test_results_usecase.dart';
import 'domain/usecases/get_test_summary_usecase.dart';
import 'presentation/bloc/test_result_bloc.dart';

final sl = GetIt.instance;

/// Initialize Test Result Module
/// 
/// Fungsi ini mendaftarkan semua dependencies untuk modul Test Result
/// ke dalam GetIt container. Perlu dipanggil sebelum modul digunakan.
void initTestResultModule() {
  // Bloc
  sl.registerFactory(() => TestResultBloc(
        getMyResultsUseCase: sl(),
        getMemberResultsUseCase: sl(),
        getSummaryUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => GetMyTestResultsUseCase(sl()));
  sl.registerLazySingleton(() => GetMemberTestResultsUseCase(sl()));
  sl.registerLazySingleton(() => GetTestSummaryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TestResultRepository>(
      () => TestResultRepositoryImpl(remoteDataSource: sl()));

  // Data Source
  sl.registerLazySingleton<TestResultRemoteDataSource>(
      () => TestResultRemoteDataSourceImpl());
}

