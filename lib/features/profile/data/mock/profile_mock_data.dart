import '../../domain/entities/profile_user.dart';

/// Mock data untuk testing fitur Profile
class ProfileMockData {
  /// Get mock profile user berdasarkan userId
  static ProfileUser getMockProfile(String userId) {
    switch (userId) {
      case 'demo_user_1':
        return ProfileUser(
          id: 'demo_user_1',
          nrp: '004271',
          email: '-',
          noKtp: '3567182910092240',
          name: 'Aiman Hafiz',
          tempatLahir: 'Bogor',
          tanggalLahir: DateTime(1999, 12, 11),
          jenisKelamin: 'Laki-laki',
          pendidikan: 'S1',
          teleponPribadi: '081625733556',
          teleponDarurat: '087263541228',
          site: 'ABB',
          jabatan: 'Anggota',
          atasan: 'Saiful Priyadi',
          tglPenerimaanKaryawan: DateTime(2018, 4, 22),
          masaBerlakuPermit: DateTime(2028, 4, 22),
          kompetensiPekerjaan: 'Keselamatan Kerja, Pengamanan',
          wargaNegara: 'Indonesia',
          provinsi: 'Jawa Barat',
          kotaKabupaten: 'Bogor',
          kecamatan: 'Cikini',
          kelurahan: 'Buduran',
          alamatDomisili: 'Griya Cendana No. 123, RT 02/RW 05',
          profileImageUrl: null,
          documents: {
            'KTP': 'KTP_Aiman_Hafiz.pdf',
            'KTA': 'KTA_Aiman_Hafiz.pdf',
            'Foto': 'Foto_Aiman_Hafiz.jpg',
            'P3TD_K3LH': 'P3TD_K3LH_Aiman_Hafiz.pdf',
            'P3TD_Security': 'P3TD_Sec_Aiman_Hafiz.pdf',
            'Tidak_Merokok': 'Tidak_Merokok_Aiman_Hafiz.pdf',
          },
        );
      
      case 'demo_user_2':
        return ProfileUser(
          id: 'demo_user_2',
          nrp: '005432',
          email: '-',
          noKtp: '3201234567891234',
          name: 'Budi Santoso',
          tempatLahir: 'Jakarta',
          tanggalLahir: DateTime(1985, 3, 15),
          jenisKelamin: 'Laki-laki',
          pendidikan: 'S1',
          teleponPribadi: '08123456789',
          teleponDarurat: '08987654321',
          site: 'PLN',
          jabatan: 'Danton',
          atasan: 'Ahmad Rahman',
          tglPenerimaanKaryawan: DateTime(2015, 8, 10),
          masaBerlakuPermit: DateTime(2025, 8, 10),
          kompetensiPekerjaan: 'Keamanan, Supervisi Tim',
          wargaNegara: 'Indonesia',
          provinsi: 'DKI Jakarta',
          kotaKabupaten: 'Jakarta Pusat',
          kecamatan: 'Menteng',
          kelurahan: 'Gondangdia',
          alamatDomisili: 'Jl. Sudirman No. 456, RT 01/RW 03',
          profileImageUrl: 'https://example.com/profile/budi_santoso.jpg',
          documents: {
            'KTP': 'KTP_Budi_Santoso.pdf',
            'KTA': 'KTA_Budi_Santoso.pdf',
            'Foto': 'Foto_Budi_Santoso.jpg',
            'P3TD_K3LH': 'P3TD_K3LH_Budi_Santoso.pdf',
            'P3TD_Security': 'P3TD_Sec_Budi_Santoso.pdf',
          },
        );
      
      default:
        return ProfileUser(
          id: userId,
          nrp: '000000',
          email: '-',
          noKtp: '0000000000000000',
          name: 'User Default',
          tempatLahir: 'Jakarta',
          tanggalLahir: DateTime(1990, 1, 1),
          jenisKelamin: 'Laki-laki',
          pendidikan: 'SMA',
          teleponPribadi: '081234567890',
          teleponDarurat: '081234567890',
          site: 'Default Site',
          jabatan: 'Anggota',
          atasan: 'Atasan Default',
          tglPenerimaanKaryawan: DateTime(2020, 1, 1),
          masaBerlakuPermit: DateTime(2030, 1, 1),
          kompetensiPekerjaan: 'Keamanan Dasar',
          wargaNegara: 'Indonesia',
          provinsi: 'DKI Jakarta',
          kotaKabupaten: 'Jakarta',
          kecamatan: 'Jakarta Pusat',
          kelurahan: 'Tanah Abang',
          alamatDomisili: 'Alamat Default',
          profileImageUrl: null,
          documents: {},
        );
    }
  }

  /// List semua mock users untuk testing
  static List<ProfileUser> getAllMockProfiles() {
    return [
      getMockProfile('demo_user_1'),
      getMockProfile('demo_user_2'),
    ];
  }

  /// Simulate API delay
  static Future<T> simulateApiDelay<T>(T data, {int milliseconds = 1500}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    return data;
  }

  /// Simulate API error
  static Future<T> simulateApiError<T>({String message = 'Network error'}) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    throw Exception(message);
  }
}