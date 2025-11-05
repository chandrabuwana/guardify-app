import 'package:flutter/material.dart';
import '../presentation/pages/profile_screen.dart';

/// Demo page untuk menunjukkan implementasi fitur Profile
/// 
/// File ini mendemonstrasikan:
/// - Penggunaan ProfileBloc dengan dependency injection
/// - Navigation ke profile screen
/// - Integrasi dengan Clean Architecture
class ProfileDemo extends StatelessWidget {
  const ProfileDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Feature Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileDemoHomePage(),
    );
  }
}

class ProfileDemoHomePage extends StatelessWidget {
  const ProfileDemoHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Feature Demo'),
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Feature Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fitur Profile dengan implementasi lengkap menggunakan Clean Architecture dan BLoC pattern.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // Demo buttons
            _buildDemoButton(
              context: context,
              title: 'Profile Screen',
              subtitle: 'Layar utama profil dengan menu navigasi',
              onPressed: () => _navigateToProfile(context, 'demo_user_1'),
            ),
            
            const SizedBox(height: 16),
            
            _buildDemoButton(
              context: context,
              title: 'Profile dengan Data Lengkap',
              subtitle: 'Demo dengan data profil yang lebih lengkap',
              onPressed: () => _navigateToProfile(context, 'demo_user_2'),
            ),
            
            const SizedBox(height: 32),
            
            // Feature list
            const Text(
              'Fitur yang tersedia:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅ Tampilan profil dengan foto dan info dasar'),
                Text('✅ Detail profil lengkap dengan tab Info Pribadi & Dokumen'),
                Text('✅ Edit nama dengan validasi form'),
                Text('✅ Upload foto profil (placeholder)'),
                Text('✅ Manajemen dokumen user'),
                Text('✅ Logout dengan konfirmasi dialog'),
                Text('✅ Caching data lokal dengan SharedPreferences'),
                Text('✅ Error handling yang comprehensive'),
                Text('✅ State management dengan BLoC pattern'),
                Text('✅ Clean Architecture implementation'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Tech stack
            const Text(
              'Teknologi yang digunakan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Flutter dengan BLoC pattern'),
            const Text('• Clean Architecture (Domain, Data, Presentation)'),
            const Text('• Dependency Injection dengan GetIt'),
            const Text('• HTTP client untuk API integration'),
            const Text('• SharedPreferences untuk local caching'),
            const Text('• Form validation dengan custom validators'),
            const Text('• Responsive design dengan ScreenUtil'),
            
            const Spacer(),
            
            // Info dialog button
            Center(
              child: TextButton(
                onPressed: () => _showInfoDialog(context),
                child: const Text('Lihat Informasi Lengkap'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }

  void _navigateToProfile(BuildContext context, String userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userId: userId),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Feature'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Implementasi lengkap fitur Profile dengan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('🎯 Clean Architecture pattern'),
              Text('🔧 BLoC untuk state management'),
              Text('💾 Local caching untuk offline support'),
              Text('🔐 Secure token management'),
              Text('📱 Responsive UI design'),
              Text('🧪 Comprehensive error handling'),
              Text('⚡ Optimized performance'),
              SizedBox(height: 12),
              Text(
                'Struktur kode:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Domain layer: Entities, Use Cases, Repository interfaces'),
              Text('• Data layer: Models, Data Sources, Repository implementations'),
              Text('• Presentation layer: BLoC, Pages, Widgets'),
              SizedBox(height: 12),
              Text(
                'Fitur dapat diextend untuk:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Integration dengan real API'),
              Text('• Photo upload dari gallery/camera'),
              Text('• Document management yang lebih advanced'),
              Text('• Biometric authentication'),
              Text('• Real-time profile synchronization'),
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