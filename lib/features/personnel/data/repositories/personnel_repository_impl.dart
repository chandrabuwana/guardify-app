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
  Future<List<Personnel>> getPersonnelByStatus(String status, {int page = 1, int pageSize = 20}) async {
    try {
      print('[PersonnelRepository] Fetching personnel - Status: $status, Page: $page, Size: $pageSize');
      
      // Calculate start index for pagination
      // API expects Start to begin from 1 (not 0)
      // Page 1 → Start: 1
      // Page 2 → Start: 21
      // Page 3 → Start: 41
      final start = ((page - 1) * pageSize) + 1;
      print('[PersonnelRepository] Calculated Start: $start (from Page: $page, Size: $pageSize)');
      
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

      print('✅ Fetched ${response.list.length} personnel (Filtered: ${response.filtered} of ${response.count})');
      
      // Convert API models to domain entities
      return response.list.map((apiModel) => apiModel.toPersonnelModel()).toList();
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
      print('[PersonnelRepository] Fetching personnel detail - ID: $personnelId');
      
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
      print('[PersonnelRepository] Searching personnel - Query: $query, Status: $status');
      
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

      return response.list.map((apiModel) => apiModel.toPersonnelModel()).toList();
    } catch (e) {
      print('❌ Error searching personnel: $e');
      return [];
    }
  }

  @override
  Future<bool> approvePersonnel(String personnelId, String feedback) async {
    try {
      // TODO: Implement when API endpoint is available
      print('⚠️  approvePersonnel API endpoint not yet implemented');
      print('   Would approve personnel $personnelId with feedback: $feedback');
      return false; // Return false since API is not implemented yet
    } catch (e) {
      print('❌ Error approving personnel: $e');
      return false;
    }
  }

  @override
  Future<bool> revisePersonnel(String personnelId, String feedback) async {
    try {
      // TODO: Implement when API endpoint is available
      print('⚠️  revisePersonnel API endpoint not yet implemented');
      print('   Would revise personnel $personnelId with feedback: $feedback');
      return false; // Return false since API is not implemented yet
    } catch (e) {
      print('❌ Error revising personnel: $e');
      return false;
    }
  }

  @override
  Future<bool> updatePersonnelStatus(String personnelId, String newStatus) async {
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
