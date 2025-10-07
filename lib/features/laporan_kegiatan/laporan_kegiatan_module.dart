import 'package:get_it/get_it.dart';
import 'data/datasources/laporan_kegiatan_remote_data_source.dart';
import 'data/repositories/laporan_kegiatan_repository_impl.dart';
import 'domain/repositories/laporan_kegiatan_repository.dart';
import 'domain/usecases/get_laporan_list.dart';
import 'domain/usecases/get_laporan_detail.dart';
import 'domain/usecases/update_status_laporan.dart';
import 'presentation/bloc/laporan_kegiatan_bloc.dart';

final sl = GetIt.instance;

void initLaporanKegiatanModule() {
  // Bloc
  sl.registerFactory(() => LaporanKegiatanBloc(
        getLaporanList: sl(),
        getLaporanDetail: sl(),
        updateStatusLaporan: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => GetLaporanList(sl()));
  sl.registerLazySingleton(() => GetLaporanDetail(sl()));
  sl.registerLazySingleton(() => UpdateStatusLaporan(sl()));

  // Repository
  sl.registerLazySingleton<LaporanKegiatanRepository>(
      () => LaporanKegiatanRepositoryImpl(remoteDataSource: sl()));

  // Data Source
  sl.registerLazySingleton<LaporanKegiatanRemoteDataSource>(
      () => LaporanKegiatanRemoteDataSourceImpl());
}
