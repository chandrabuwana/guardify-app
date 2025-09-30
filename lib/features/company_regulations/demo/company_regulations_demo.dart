import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../presentation/bloc/document_bloc.dart';
import '../presentation/pages/company_regulations_page.dart';
import '../presentation/navigation/company_regulations_routes.dart';

/// Contoh aplikasi sederhana untuk mendemonstrasikan fitur Company Regulations
/// 
/// File ini menunjukkan bagaimana mengintegrasikan fitur Company Regulations
/// ke dalam aplikasi utama dengan BLoC pattern dan dependency injection.
class CompanyRegulationsDemo extends StatelessWidget {
  const CompanyRegulationsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company Regulations Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DemoHomePage(),
        ...CompanyRegulationsRoutes.routes,
      },
      onGenerateRoute: CompanyRegulationsRoutes.generateRoute,
    );
  }
}

/// Halaman home sederhana untuk demo
class DemoHomePage extends StatelessWidget {
  const DemoHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Regulations Demo'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description,
              size: 80,
              color: Color(0xFF8B0000),
            ),
            const SizedBox(height: 24),
            const Text(
              'Company Regulations Feature',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fitur manajemen dokumen peraturan perusahaan\ndengan Clean Architecture + BLoC',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<DocumentBloc>(),
                      child: const CompanyRegulationsPage(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Buka Peraturan Perusahaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _showFeatureInfo(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8B0000),
                side: const BorderSide(color: Color(0xFF8B0000)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Info Fitur',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fitur Company Regulations'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Fitur ini menyediakan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('✅ Daftar dokumen peraturan perusahaan'),
              Text('✅ Pencarian dokumen dengan keyword'),
              Text('✅ Filter berdasarkan kategori dan tanggal'),
              Text('✅ Download dokumen ke penyimpanan lokal'),
              Text('✅ Viewer detail dokumen'),
              Text('✅ UI modern dengan design system konsisten'),
              Text('✅ Clean Architecture + BLoC pattern'),
              Text('✅ State management yang reactive'),
              Text('✅ Error handling yang comprehensive'),
              SizedBox(height: 12),
              Text(
                'Teknologi yang digunakan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Flutter dengan BLoC pattern'),
              Text('• Clean Architecture (Domain, Data, Presentation)'),
              Text('• Dependency Injection dengan get_it'),
              Text('• Either pattern untuk error handling'),
              Text('• Responsive design dengan flutter_screenutil'),
              Text('• JSON serialization dengan json_annotation'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

/// Cara menggunakan fitur dalam aplikasi utama:
/// 
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Setup dependency injection
///   await configureDependencies();
///   
///   runApp(MyApp());
/// }
/// 
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       // Add routes
///       routes: {
///         '/': (context) => HomePage(),
///         ...CompanyRegulationsRoutes.routes,
///       },
///       onGenerateRoute: CompanyRegulationsRoutes.generateRoute,
///     );
///   }
/// }
/// 
/// // Untuk navigasi ke halaman peraturan perusahaan:
/// context.pushToCompanyRegulations();
/// 
/// // Untuk menyediakan DocumentBloc di widget tree:
/// BlocProvider(
///   create: (context) => getIt<DocumentBloc>(),
///   child: CompanyRegulationsPage(),
/// )
/// ```