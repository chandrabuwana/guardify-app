import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../models/laporan_kegiatan_model.dart';
import '../models/verif_request_model.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import '../../domain/entities/laporan_kegiatan_request_entity.dart';

/// Remote data source untuk Laporan Kegiatan
abstract class LaporanKegiatanRemoteDataSource {
  Future<List<LaporanKegiatanModel>> getLaporanList({
    LaporanStatus? status,
    UserRole? role,
    String? userId,
    String? search,
    int start = 1,
    int length = 100,
  });

  Future<LaporanKegiatanModel> getLaporanDetail(String id);

  Future<LaporanKegiatanModel> updateStatusLaporan({
    required String id,
    required LaporanStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  });

  Future<bool> verifLaporan({
    required String idAttendance,
    required bool isVerif,
    String? feedback,
  });
}

@LazySingleton(as: LaporanKegiatanRemoteDataSource)
class LaporanKegiatanRemoteDataSourceImpl
    implements LaporanKegiatanRemoteDataSource {
  final Dio dio;

  LaporanKegiatanRemoteDataSourceImpl({required this.dio});

  // Mock data untuk fallback atau testing
  final List<LaporanKegiatanModel> _mockData = [
    LaporanKegiatanModel(
      id: '1',
      namaPersonil: 'Aiman Hafiz',
      userId: 'user_1',
      role: UserRole.anggota,
      nrp: 'NRP02982',
      tanggal: DateTime(2025, 9, 11),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung A',
      tugasTertunda: true,
      status: LaporanStatus.waiting,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Situasi aman terkendali',
      routeName: 'Rute A (Belum Selesai Diperiksa)',
      checkpoints: const [
        PatrolCheckpointModel(
          id: 'cp1',
          name: 'Pos Gajah A',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
        PatrolCheckpointModel(
          id: 'cp2',
          name: 'Pos Singa B',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
        PatrolCheckpointModel(
          id: 'cp3',
          name: 'Pos Merpati',
          status: 'Belum Diperiksa',
          isDiperiksa: false,
        ),
        PatrolCheckpointModel(
          id: 'cp4',
          name: 'Pos Merak A',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
        PatrolCheckpointModel(
          id: 'cp5',
          name: 'Pos Ayam C',
          status: 'Selesai',
          buktiUrl: 'bukti.jpg',
          isDiperiksa: true,
        ),
      ],
    ),
    LaporanKegiatanModel(
      id: '2',
      namaPersonil: 'Robis Hafiz',
      userId: 'user_2',
      role: UserRole.anggota,
      nrp: 'NRP02983',
      tanggal: DateTime(2025, 9, 11),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung A',
      tugasTertunda: true,
      status: LaporanStatus.revision,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Perlu perbaikan laporan',
      umpanBalik: 'Mohon lengkapi foto pengamanan',
    ),
    LaporanKegiatanModel(
      id: '3',
      namaPersonil: 'Roger Hafiz',
      userId: 'user_3',
      role: UserRole.anggota,
      nrp: 'NRP02984',
      tanggal: DateTime(2025, 9, 10),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung B',
      tugasTertunda: true,
      status: LaporanStatus.verified,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Semua berjalan lancar',
      reviewerId: 'reviewer_1',
      reviewerName: 'Supervisor A',
      tanggalReview: DateTime(2025, 9, 11),
    ),
    LaporanKegiatanModel(
      id: '4',
      namaPersonil: 'Aiman Simala',
      userId: 'user_4',
      role: UserRole.anggota,
      nrp: 'NRP02985',
      tanggal: DateTime(2025, 9, 10),
      shift: 'Shift Pagi',
      jamKerja: '06.40 - 19.10',
      lokasiJaga: 'Pos Satpam Gedung C',
      tugasTertunda: true,
      status: LaporanStatus.verified,
      kehadiran: 'Masuk',
      lembur: false,
      laporanPengamanan: 'Tidak ada insiden',
      reviewerId: 'reviewer_1',
      reviewerName: 'Supervisor A',
      tanggalReview: DateTime(2025, 9, 11),
    ),
    LaporanKegiatanModel(
      id: '5',
      namaPersonil: 'Sabana Pier',
      userId: 'user_5',
      role: UserRole.anggota,
      nrp: 'NRP02986',
      tanggal: DateTime(2025, 9, 9),
      shift: 'Shift Pagi',
      jamKerja: '-',
      lokasiJaga: '-',
      tugasTertunda: true,
      status: LaporanStatus.verified,
      kehadiran: 'Tidak Masuk',
      lembur: false,
      laporanPengamanan: '-',
    ),
    LaporanKegiatanModel(
      id: '6',
      namaPersonil: 'Dandelion Musk',
      userId: 'user_6',
      role: UserRole.anggota,
      nrp: 'NRP02987',
      tanggal: DateTime(2025, 9, 8),
      shift: 'Shift Pagi',
      jamKerja: '-',
      lokasiJaga: '-',
      tugasTertunda: false,
      status: LaporanStatus.verified,
      kehadiran: 'Cuti',
      lembur: false,
      laporanPengamanan: '-',
    ),
  ];

  @override
  Future<List<LaporanKegiatanModel>> getLaporanList({
    LaporanStatus? status,
    UserRole? role,
    String? userId,
    String? search,
    int start = 1,
    int length = 10,
  }) async {
    try {
      // Always get userId from secure storage
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }


      // Map status to API format
      // Tab "Menunggu Verifikasi" -> status = "WAITING" (huruf besar semua)
      // Tab "Terverifikasi" -> status = "VERIFIKASI" (huruf besar semua)
      String apiStatus = '';
      if (status == LaporanStatus.waiting) {
        apiStatus = 'WAITING'; // Format API: huruf besar semua
      } else if (status == LaporanStatus.verified) {
        apiStatus = 'VERIFIKASI'; // Format API: huruf besar semua
      } else if (status == LaporanStatus.revision) {
        apiStatus = 'revision';
      } else if (status == LaporanStatus.checkIn) {
        apiStatus = 'check_in';
      }

      // Create request
      final request = LaporanKegiatanRequestEntity(
        idUser: currentUserId,
        withSubordinate: true, // Selalu true karena akan ada bawahan
        status: apiStatus,
        search: search ?? '',
        start: start,
        length: length,
      );

      // Call API
      final response = await dio.post(
        '/Attendance/get_rekap',
        data: request.toJson(),
      );

      // Handle response wrapper
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if response has the expected structure
        if (responseData.containsKey('Succeeded') &&
            responseData['Succeeded'] == true) {
          final list = responseData['List'] as List<dynamic>? ?? [];

          // Map API response to LaporanKegiatanModel
          // Pass the status to determine laporan status correctly
          return list.map((item) {
            return _mapApiResponseToModel(
              item as Map<String, dynamic>,
              requestedStatus: status,
            );
          }).toList();
        } else {
          throw Exception(
              responseData['Message'] ?? 'Failed to get laporan kegiatan');
        }
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data['Message'] ??
            e.response?.data['Description'] ??
            'Failed to get laporan kegiatan';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get laporan kegiatan: $e');
    }
  }

  /// Map API response item to LaporanKegiatanModel
  LaporanKegiatanModel _mapApiResponseToModel(
    Map<String, dynamic> item, {
    LaporanStatus? requestedStatus,
  }) {
    // Parse dates
    DateTime? shiftDate;
    DateTime? checkIn;
    DateTime? checkOut;

    try {
      if (item['ShiftDate'] != null) {
        shiftDate = DateTime.parse(item['ShiftDate'] as String);
      }
    } catch (e) {
      shiftDate = null;
    }

    try {
      if (item['CheckIn'] != null) {
        checkIn = DateTime.parse(item['CheckIn'] as String);
      }
    } catch (e) {
      checkIn = null;
    }

    try {
      if (item['CheckOut'] != null) {
        checkOut = DateTime.parse(item['CheckOut'] as String);
      }
    } catch (e) {
      checkOut = null;
    }

    // Format jam kerja
    String jamKerja = '-';
    if (checkIn != null && checkOut != null) {
      final checkInStr = '${checkIn.hour.toString().padLeft(2, '0')}.${checkIn.minute.toString().padLeft(2, '0')}';
      final checkOutStr = '${checkOut.hour.toString().padLeft(2, '0')}.${checkOut.minute.toString().padLeft(2, '0')}';
      jamKerja = '$checkInStr - $checkOutStr';
    } else if (checkIn != null) {
      final checkInStr = '${checkIn.hour.toString().padLeft(2, '0')}.${checkIn.minute.toString().padLeft(2, '0')}';
      jamKerja = '$checkInStr - -';
    }

    // Determine status based on requested status
    // Jika requestedStatus adalah verified, berarti API sudah filter untuk verified
    // Jika requestedStatus adalah waiting atau null, berarti waiting
    LaporanStatus laporanStatus = requestedStatus ?? LaporanStatus.waiting;
    
    // Check if there's a revision indicator in the API response
    // This might come from a different field or status indicator
    // For now, we'll use the requested status as the primary indicator

    // Determine tugas tertunda
    final statusCarryOver = item['StatusCarryOver'] as String? ?? '';
    final tugasTertunda = statusCarryOver.toLowerCase().contains('belum');

    return LaporanKegiatanModel(
      id: item['IdAttendance'] as String? ?? '',
      namaPersonil: item['EmployeeName'] as String? ?? '',
      userId: '', // Will be set from context
      role: UserRole.anggota, // Default, will be set from context
      nrp: item['Nrp'] as String? ?? '',
      tanggal: shiftDate ?? DateTime.now(),
      shift: item['ShiftName'] as String? ?? '',
      jamKerja: jamKerja,
      lokasiJaga: '', // Not in API response
      tugasTertunda: tugasTertunda,
      status: laporanStatus,
      kehadiran: item['StatusAttendance'] as String? ?? 'Masuk',
      lembur: item['IsOvertime'] as bool? ?? false,
      laporanPengamanan: '', // Not in API response, will be in detail
      // Additional fields from API
      jamAbsensi: checkIn != null
          ? '${checkIn.hour.toString().padLeft(2, '0')}.${checkIn.minute.toString().padLeft(2, '0')}'
          : null,
      jamSelesaiBekerja: checkOut != null
          ? '${checkOut.hour.toString().padLeft(2, '0')}.${checkOut.minute.toString().padLeft(2, '0')}'
          : null,
      // Patrol info
      tugasLanjutan: item['Patrol'] as String? ?? '',
      // Attendance info
      idAttendance: item['IdAttendance'] as String?,
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }

  @override
  Future<LaporanKegiatanModel> getLaporanDetail(String id) async {
    try {
      // Validate id is not empty
      if (id.isEmpty) {
        throw Exception('IdAttendance tidak boleh kosong');
      }

      // Call API get_detail_rekap
      final response = await dio.post(
        '/Attendance/get_detail_rekap',
        data: {
          'IdAttendance': id,
        },
      );

      // Handle response wrapper
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if response has the expected structure
        if (responseData.containsKey('Succeeded') &&
            responseData['Succeeded'] == true) {
          final data = responseData['Data'] as Map<String, dynamic>?;

          if (data == null) {
            throw Exception('Data not found in response');
          }

          // Get userId from secure storage (not in API response)
          final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';

          // Map API response to LaporanKegiatanModel
          return _mapDetailApiResponseToModel(data, userId: userId);
        } else {
          throw Exception(
              responseData['Message'] ?? 'Failed to get laporan detail');
        }
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data['Message'] ??
            e.response?.data['Description'] ??
            'Failed to get laporan detail';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get laporan detail: $e');
    }
  }

  /// Map detail API response to LaporanKegiatanModel
  LaporanKegiatanModel _mapDetailApiResponseToModel(
    Map<String, dynamic> data, {
    String userId = '',
  }) {
    // Parse dates
    DateTime? shiftDate;
    DateTime? checkIn;
    DateTime? checkOut;

    try {
      if (data['ShiftDate'] != null) {
        shiftDate = DateTime.parse(data['ShiftDate'] as String);
      }
    } catch (e) {
      shiftDate = null;
    }

    try {
      if (data['CheckIn'] != null) {
        checkIn = DateTime.parse(data['CheckIn'] as String);
      }
    } catch (e) {
      checkIn = null;
    }

    try {
      if (data['CheckOut'] != null) {
        checkOut = DateTime.parse(data['CheckOut'] as String);
      }
    } catch (e) {
      checkOut = null;
    }

    // Format jam kerja
    String jamKerja = '-';
    if (checkIn != null && checkOut != null) {
      final checkInStr =
          '${checkIn.hour.toString().padLeft(2, '0')}.${checkIn.minute.toString().padLeft(2, '0')}';
      final checkOutStr =
          '${checkOut.hour.toString().padLeft(2, '0')}.${checkOut.minute.toString().padLeft(2, '0')}';
      jamKerja = '$checkInStr - $checkOutStr';
    } else if (checkIn != null) {
      final checkInStr =
          '${checkIn.hour.toString().padLeft(2, '0')}.${checkIn.minute.toString().padLeft(2, '0')}';
      jamKerja = '$checkInStr - -';
    }

    // Map StatusLaporan to LaporanStatus - sesuai dengan web
    final statusLaporan = data['StatusLaporan'] as String? ?? 'WAITING';
    LaporanStatus laporanStatus = LaporanStatus.fromValue(statusLaporan);

    // Map StatusKerja to kehadiran
    final statusKerja = data['StatusKerja'] as String? ?? '';
    String kehadiran = 'Masuk';
    if (statusKerja.isNotEmpty) {
      // StatusKerja bisa "Early", "OnTime", "Late", dll
      // Untuk kehadiran, kita perlu logic tambahan jika ada field lain
      kehadiran = 'Masuk'; // Default, bisa disesuaikan jika ada field kehadiran terpisah
    }

    // Get role from Jabatan
    final jabatan = data['Jabatan'] as String? ?? 'Anggota';
    UserRole role = UserRole.anggota;
    final jabatanLower = jabatan.toLowerCase();
    if (jabatanLower.contains('danton')) {
      role = UserRole.danton;
    } else if (jabatanLower.contains('pengawas') || jabatanLower.contains('supervisor')) {
      role = UserRole.pengawas;
    } else if (jabatanLower.contains('deputy')) {
      role = UserRole.deputy;
    } else if (jabatanLower.contains('pjo')) {
      role = UserRole.pjo;
    } else if (jabatanLower.contains('admin')) {
      role = UserRole.admin;
    }

    // Handle PhotoPakaian
    final photoPakaian = data['PhotoPakaian'] as Map<String, dynamic>?;
    final fotoPakaianPersonil = photoPakaian?['Url'] as String?;

    // Handle PhotoPengamanan (check-in)
    List<String>? fotoPengamanan;
    final photoPengamanan = data['PhotoPengamanan'] as Map<String, dynamic>?;
    if (photoPengamanan != null && photoPengamanan['Url'] != null) {
      fotoPengamanan = [photoPengamanan['Url'] as String];
    }

    // Handle PhotoCheckin (can be used for additional photo display if needed)
    // final photoCheckin = data['PhotoCheckin'] as Map<String, dynamic>?;
    // final photoCheckinUrl = photoCheckin?['Url'] as String?;

    // Handle PhotoCheckout (can be used for additional photo display if needed)
    // final photoCheckout = data['PhotoCheckout'] as Map<String, dynamic>?;
    // final photoCheckoutUrl = photoCheckout?['Url'] as String?;

    // Handle PhotoCheckoutPengamanan (check-out)
    List<String>? fotoPengamananCheckout;
    final photoCheckoutPengamanan =
        data['PhotoCheckoutPengamanan'] as Map<String, dynamic>?;
    if (photoCheckoutPengamanan != null &&
        photoCheckoutPengamanan['Url'] != null) {
      fotoPengamananCheckout = [photoCheckoutPengamanan['Url'] as String];
    }

    // Handle PhotoCheckoutPakaian
    final photoCheckoutPakaian =
        data['PhotoCheckoutPakaian'] as Map<String, dynamic>?;
    final photoCheckoutPakaianUrl = photoCheckoutPakaian?['Url'] as String?;

    // Handle PhotoOvertime
    final photoOvertime = data['PhotoOvertime'] as Map<String, dynamic>?;
    final fotoLembur = photoOvertime?['Url'] as String?;

    // Handle ListCarryOver
    final listCarryOver = data['ListCarryOver'] as List<dynamic>? ?? [];
    final tugasTertunda = listCarryOver.isNotEmpty;

    // Handle ListRoute (checkpoints) - ambil dari ListRoute
    List<PatrolCheckpoint>? checkpoints;
    String? routeNameFromListRoute;
    final listRoute = data['ListRoute'] as List<dynamic>?;
    if (listRoute != null && listRoute.isNotEmpty) {
      checkpoints = listRoute.map((item) {
        final routeItem = item as Map<String, dynamic>;
        
        // Extract route name from first item if available
        if (routeNameFromListRoute == null) {
          routeNameFromListRoute = routeItem['RouteName'] as String? ?? 
                                   routeItem['Route'] as String?;
        }
        
        // Determine status based on IsChecked and PhotoUrl
        String status = 'Selesai';
        bool isDiperiksa = routeItem['IsChecked'] as bool? ?? false;
        final hasBukti = (routeItem['PhotoUrl'] as String? ?? routeItem['Url'] as String?) != null;
        
        if (!isDiperiksa || !hasBukti) {
          status = 'Belum Selesai';
        } else {
          final isAdditional = routeItem['IsAdditional'] as bool? ?? false;
          final isAdditionalAlt = routeItem['Additional'] as bool? ?? false;
          if (isAdditional || isAdditionalAlt) {
            status = 'Tambahan';
          }
        }
        
        // Parse timestamp - try multiple field names
        DateTime? timestamp;
        if (routeItem['Timestamp'] != null) {
          timestamp = DateTime.tryParse(routeItem['Timestamp'] as String);
        } else if (routeItem['CheckTime'] != null) {
          timestamp = DateTime.tryParse(routeItem['CheckTime'] as String);
        } else if (routeItem['Time'] != null) {
          timestamp = DateTime.tryParse(routeItem['Time'] as String);
        }

        if (timestamp == null && routeItem['CheckDate'] != null) {
          timestamp = DateTime.tryParse(routeItem['CheckDate'] as String);
        }

        String? photoRouteUrl;
        final photoRoute = routeItem['PhotoRoute'];
        if (photoRoute is Map) {
          photoRouteUrl = photoRoute['Url'] as String?;
        }
        
        return PatrolCheckpointModel(
          id: routeItem['Id'] as String? ?? 
              routeItem['IdRoute'] as String? ?? 
              routeItem['IdArea'] as String? ?? '',
          name: routeItem['Name'] as String? ?? 
                routeItem['AreasName'] as String? ?? 
                routeItem['Location'] as String? ?? 
                routeItem['AreaName'] as String? ?? '',
          status: status,
          timestamp: timestamp,
          buktiUrl: routeItem['PhotoUrl'] as String? ?? 
                   routeItem['Url'] as String? ??
                   photoRouteUrl ??
                   routeItem['Photo'] as String?,
          isDiperiksa: isDiperiksa,
        );
      }).toList();
    }

    // Format jam absensi
    String? jamAbsensi;
    if (checkIn != null) {
      jamAbsensi =
          '${checkIn.hour.toString().padLeft(2, '0')}.${checkIn.minute.toString().padLeft(2, '0')}';
    }

    // Format jam selesai bekerja
    String? jamSelesaiBekerja;
    if (checkOut != null) {
      jamSelesaiBekerja =
          '${checkOut.hour.toString().padLeft(2, '0')}.${checkOut.minute.toString().padLeft(2, '0')}';
    }

    return LaporanKegiatanModel(
      id: data['IdAttendance'] as String? ?? '',
      namaPersonil: data['Fullname'] as String? ?? '',
      userId: userId,
      role: role,
      profileImageUrl: data['PhotoPegawai'] as String?,
      nrp: data['Nrp'] as String? ?? '',
      tanggal: shiftDate ?? DateTime.now(),
      shift: data['ShiftName'] as String? ?? '',
      jamKerja: jamKerja,
      lokasiJaga: data['Location'] as String? ?? '',
      jamAbsensi: jamAbsensi,
      pakaianPersonil: null, // Not in API response
      fotoPakaianPersonil: fotoPakaianPersonil ?? photoCheckoutPakaianUrl,
      laporanPengamanan: data['Notes'] as String? ?? '',
      laporanPengamananCheckout: data['NotesCheckout'] as String?,
      fotoPengamanan: fotoPengamanan,
      fotoPengamananCheckout: fotoPengamananCheckout,
      tugasLanjutan: data['Patrol'] as String? ?? '',
      tugasTertunda: tugasTertunda,
      carryOver: data['CarryOver'] as String?,
      status: laporanStatus,
      kehadiran: kehadiran,
      lembur: data['IsOvertime'] as bool? ?? false,
      fotoLembur: fotoLembur,
      jamSelesaiBekerja: jamSelesaiBekerja,
      umpanBalik: data['Feedback'] as String?,
      statusKerja: statusKerja.isNotEmpty ? statusKerja : null,
      // Prioritize route name from ListRoute, fallback to Route field
      routeName: routeNameFromListRoute ?? data['Route'] as String? ?? data['RouteName'] as String?,
      checkpoints: checkpoints,
      reviewerId: null, // Not in detail response
      reviewerName: null, // Not in detail response
      tanggalReview: null, // Not in detail response
      updateBy: data['UpdateBy'] as String?,
      updateDate: data['UpdateDate'] != null
          ? DateTime.tryParse(data['UpdateDate'] as String)
          : null,
      // Attendance info
      idAttendance: data['IdAttendance'] as String?,
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }

  @override
  Future<LaporanKegiatanModel> updateStatusLaporan({
    required String id,
    required LaporanStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockData.indexWhere((laporan) => laporan.id == id);

    if (index == -1) {
      throw Exception('Laporan not found');
    }

    // Update the status
    final updatedLaporan = LaporanKegiatanModel.fromEntity(
      _mockData[index].copyWith(
        status: status,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        umpanBalik: umpanBalik,
        tanggalReview: DateTime.now(),
      ),
    );

    _mockData[index] = updatedLaporan;

    return updatedLaporan;
  }

  @override
  Future<bool> verifLaporan({
    required String idAttendance,
    required bool isVerif,
    String? feedback,
  }) async {
    try {
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      if (token == null || token.isEmpty) {
        throw Exception('Token not found');
      }

      final request = VerifRequestModel(
        idAttendance: idAttendance,
        isVerif: isVerif,
        feedback: feedback,
      );

      final response = await dio.post(
        '/Attendance/verif',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final verifResponse = VerifResponseModel.fromJson(response.data);

      if (!verifResponse.succeeded) {
        throw Exception(verifResponse.message);
      }

      return verifResponse.succeeded;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['Message'] as String? ?? 
                           errorData['message'] as String? ?? 
                           'Failed to verify laporan';
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to verify laporan: $e');
    }
  }
}
