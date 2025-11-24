import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/personnel.dart';
import '../../domain/repositories/personnel_repository.dart';
import '../datasources/personnel_remote_data_source.dart';

@LazySingleton(as: PersonnelRepository)
class PersonnelRepositoryImpl implements PersonnelRepository {
  final PersonnelRemoteDataSource remoteDataSource;

  PersonnelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Personnel>> getPersonnelByStatus(String status,
      {int page = 1, int pageSize = 20}) async {
    try {
      print(
          '[PersonnelRepository] Fetching personnel - Status: $status, Page: $page, Size: $pageSize');

      // Calculate start index for pagination
      // API expects Start to begin from 1 (not 0)
      // Page 1 → Start: 1
      // Page 2 → Start: 21
      // Page 3 → Start: 41
      final start = ((page - 1) * pageSize) + 1;
      print(
          '[PersonnelRepository] Calculated Start: $start (from Page: $page, Size: $pageSize)');

      final requestBody = {
        'Filter': [
          {
            'Field': 'Status',
            'Search': status, // 'Active', 'Pending', or 'Non Active'
          }
        ],
        'Sort': {
          'Field': 'CreateDate',
          'Type': 1, // 1 = DESC, 0 = ASC
        },
        'Start': start,
        'Length': pageSize,
      };

      print('[PersonnelRepository] Request Body: $requestBody');

      final response = await remoteDataSource.getPersonnelList(requestBody);

      if (!response.succeeded) {
        print('❌ API returned succeeded: false - ${response.message}');
        return [];
      }

      print(
          '✅ Fetched ${response.list.length} personnel (Filtered: ${response.filtered} of ${response.count})');

      // Convert API models to domain entities
      return response.list
          .map((apiModel) => apiModel.toPersonnelModel())
          .toList();
    } on DioException catch (e) {
      print('❌ DioException fetching personnel: ${e.message}');
      print('Response: ${e.response?.data}');
      return [];
    } catch (e) {
      print('❌ Error fetching personnel by status: $e');
      return [];
    }
  }

  @override
  Future<Personnel?> getPersonnelById(String personnelId) async {
    try {
      print(
          '[PersonnelRepository] Fetching personnel detail - ID: $personnelId');

      final response = await remoteDataSource.getPersonnelById(personnelId);

      if (!response.succeeded || response.data == null) {
        print('❌ Failed to fetch personnel detail: ${response.message}');
        return null;
      }

      print('✅ Fetched personnel detail: ${response.data!.fullname}');
      return response.data!.toPersonnelModel();
    } on DioException catch (e) {
      print('❌ DioException fetching personnel detail: ${e.message}');
      return null;
    } catch (e) {
      print('❌ Error fetching personnel detail: $e');
      return null;
    }
  }

  @override
  Future<List<Personnel>> searchPersonnel(String query, String status) async {
    try {
      // Search using filter - call getPersonnelByStatus with search filter
      // TODO: Implement proper search API when available
      print(
          '[PersonnelRepository] Searching personnel - Query: $query, Status: $status');

      final response = await remoteDataSource.getPersonnelList({
        'Filter': [
          {
            'Field': 'Status',
            'Search': status,
          },
          {
            'Field': 'Fullname',
            'Search': query,
          }
        ],
        'Sort': {
          'Field': 'Fullname',
          'Type': 0,
        },
        'Start': 0,
        'Length': 100, // Get more results for search
      });

      return response.list
          .map((apiModel) => apiModel.toPersonnelModel())
          .toList();
    } catch (e) {
      print('❌ Error searching personnel: $e');
      return [];
    }
  }

  @override
  Future<bool> approvePersonnel(String personnelId, String feedback) async {
    try {
      print('[PersonnelRepository] Approving personnel - ID: $personnelId');

      // Get personnel detail first to get all required fields
      final personnelResponse =
          await remoteDataSource.getPersonnelById(personnelId);
      if (!personnelResponse.succeeded || personnelResponse.data == null) {
        print('❌ Failed to get personnel data for approval');
        return false;
      }

      final personnel = personnelResponse.data!;

      // Build request body for approval - simplified payload with only required fields
      final requestBody = {
        'Id': personnelId,
        'Username': personnel.username ?? '',
        'Fullname': personnel.fullname ?? '',
        'Email': personnel.email ?? '',
        'Feedback': feedback,
        'Status': 'Active', // Set status ke Active untuk aktivasi user pending
      };

      await remoteDataSource.editUserInfo(requestBody);
      print('✅ Personnel approved successfully');
      return true;
    } on DioException catch (e) {
      print('❌ DioException approving personnel: ${e.message}');
      return false;
    } catch (e) {
      print('❌ Error approving personnel: $e');
      return false;
    }
  }

  @override
  Future<bool> revisePersonnel(String personnelId, String feedback) async {
    try {
      print(
          '[PersonnelRepository] Requesting revision for personnel - ID: $personnelId');

      // Get personnel detail first
      final personnelResponse =
          await remoteDataSource.getPersonnelById(personnelId);
      if (!personnelResponse.succeeded || personnelResponse.data == null) {
        print('❌ Failed to get personnel data for revision');
        return false;
      }

      final personnel = personnelResponse.data!;

      // Build request body - keep status as Pending but add feedback
      final requestBody = {
        'Id': personnelId,
        'Username': personnel.username,
        'Fullname': personnel.fullname,
        'Email': personnel.email,
        'PhoneNumber': personnel.phoneNumber,
        'Active': false, // Keep as false for revision
        'Status': 'Pending', // Keep as Pending for revision
        'NoNrp': personnel.noNrp,
        'NoKtp': personnel.noKtp,
        'TempatLahir': personnel.tempatLahir,
        'TanggalLahir': personnel.tanggalLahir,
        'JenisKelamin': personnel.jenisKelamin,
        'Pendidikan': personnel.pendidikan,
        'TeleponPribadi': personnel.teleponPribadi,
        'TeleponDarurat': personnel.teleponDarurat,
        'WargaNegara': personnel.wargaNegara,
        'Site': personnel.site,
        'Jabatan': personnel.jabatan,
        'IdAtasan': personnel.idAtasan,
        'TanggalPenerimaan': personnel.tanggalPenerimaan,
        'MasaBerlakuPermit': personnel.masaBerlakuPermit,
        'KompetensiPekerjaan': personnel.kompetensiPekerjaan,
        'Provinsi': personnel.provinsi,
        'KotaKabupaten': personnel.kotaKabupaten,
        'Kecamatan': personnel.kecamatan,
        'Kelurahan': personnel.kelurahan,
        'AlamatDomisili': personnel.alamatDomisili,
        'UrlKtp': personnel.urlKtp,
        'UrlKta': personnel.urlKta,
        'UrlFoto': personnel.urlFoto,
        'P3tdK3lh': personnel.p3tdK3lh,
        'P3tdSecurity': personnel.p3tdSecurity,
        'UrlPernyataanTidakMerokok': personnel.urlPernyataanTidakMerokok,
        'Feedback': feedback, // Add revision feedback
      };

      await remoteDataSource.editUserInfo(requestBody);
      print('✅ Revision requested successfully');
      return true;
    } on DioException catch (e) {
      print('❌ DioException requesting revision: ${e.message}');
      return false;
    } catch (e) {
      print('❌ Error requesting revision: $e');
      return false;
    }
  }

  @override
  Future<bool> updatePersonnelStatus(
      String personnelId, String newStatus) async {
    try {
      // TODO: Implement when API is available
      print('❌ updatePersonnelStatus API not implemented yet');
      return false;
    } catch (e) {
      print('❌ Error updating personnel status: $e');
      return false;
    }
  }
}
