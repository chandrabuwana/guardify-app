import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';
import '../../features/laporan_kegiatan/laporan_kegiatan_module.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  // Initialize manual modules
  initLaporanKegiatanModule();
}
