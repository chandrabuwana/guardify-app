import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/document_model.dart';
import '../models/company_rule_list_request.dart';
import '../models/company_rule_list_response.dart';

/// Abstract class untuk remote data source dokumen
abstract class DocumentRemoteDataSource {
  /// Get documents with pagination
  Future<CompanyRuleListResponse> getDocumentsList(
      CompanyRuleListRequest request);

  Future<List<DocumentModel>> getAllDocuments();
  Future<List<DocumentModel>> searchDocuments(String query);
  Future<List<DocumentModel>> filterDocumentsByCategory(String category);
  Future<List<DocumentModel>> filterDocumentsByDate(
    DateTime startDate,
    DateTime endDate,
  );
  Future<DocumentModel> getDocumentById(String documentId);
  Future<List<String>> getDocumentCategories();
  Future<String> downloadDocument(DocumentModel document);
  Future<void> markDocumentAsRead(String documentId);
}

/// Implementasi remote data source menggunakan Dio untuk HTTP client
@LazySingleton(as: DocumentRemoteDataSource)
class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final Dio dio;

  DocumentRemoteDataSourceImpl({required this.dio});

  @override
  Future<CompanyRuleListResponse> getDocumentsList(
      CompanyRuleListRequest request) async {
    try {
      final response = await dio.post(
        '/CompanyRule/list',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final companyRuleResponse =
            CompanyRuleListResponse.fromJson(response.data);

        if (!companyRuleResponse.succeeded) {
          throw Exception(companyRuleResponse.message);
        }

        return companyRuleResponse;
      } else {
        throw Exception(
            'Failed to load company rules: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'API Error: ${e.response?.data['Message'] ?? e.message}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load company rules: $e');
    }
  }

  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    try {
      final request = CompanyRuleListRequest.initial(length: 100);
      final response = await getDocumentsList(request);

      // Convert CompanyRuleModel to DocumentModel
      return response.list.map((rule) {
        final entity = rule.toEntity();
        return DocumentModel.fromEntity(entity);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  @override
  Future<List<DocumentModel>> searchDocuments(String query) async {
    try {
      final response = await dio.get(
        '/api/v1/documents/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }

      throw Exception('Failed to search documents: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<DocumentModel>> filterDocumentsByCategory(String category) async {
    try {
      final response = await dio.get(
        '/api/v1/documents/filter',
        queryParameters: {'category': category},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }

      throw Exception('Failed to filter documents: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<DocumentModel>> filterDocumentsByDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await dio.get(
        '/api/v1/documents/filter',
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }

      throw Exception(
          'Failed to filter documents by date: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<DocumentModel> getDocumentById(String documentId) async {
    try {
      final response = await dio.get('/api/v1/documents/$documentId');

      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data['data']);
      }

      throw Exception('Failed to get document: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<String>> getDocumentCategories() async {
    try {
      final response = await dio.get('/api/v1/documents/categories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((category) => category.toString()).toList();
      }

      throw Exception('Failed to get categories: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> downloadDocument(DocumentModel document) async {
    try {
      final response = await dio.get(
        document.fileUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        // Return mock path - actual implementation would save to local storage
        return '/storage/documents/${document.id}.${document.fileType?.toLowerCase() ?? 'pdf'}';
      }

      throw Exception('Failed to download document: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> markDocumentAsRead(String documentId) async {
    try {
      final response = await dio.post('/api/v1/documents/$documentId/read');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark document as read: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
