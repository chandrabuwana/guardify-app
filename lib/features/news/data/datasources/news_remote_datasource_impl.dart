import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/news_list_request.dart';
import '../models/news_list_response.dart';
import '../models/news_model.dart';
import 'news_remote_datasource.dart';

@LazySingleton(as: NewsRemoteDataSource)
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSourceImpl(this._dio);

  @override
  Future<NewsListResponse> getNewsList(NewsListRequest request) async {
    try {
      final response = await _dio.post(
        '/News/list',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final newsListResponse = NewsListResponse.fromJson(response.data);

        if (!newsListResponse.succeeded) {
          throw Exception(newsListResponse.message);
        }

        return newsListResponse;
      } else {
        throw Exception('Failed to load news: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'API Error: ${e.response?.data['Message'] ?? e.message}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  @override
  Future<NewsListResponse> getNewsById(String id) async {
    try {
      final response = await _dio.get('/News/get/$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to load news: ${response.statusMessage}');
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final succeeded = responseData['Succeeded'] as bool? ?? true;
        final message = responseData['Message'] as String? ?? '';
        final description = responseData['Description'] as String? ?? '';
        final code = responseData['Code'] as int? ?? response.statusCode ?? 200;

        if (!succeeded) {
          throw Exception(message.isNotEmpty ? message : 'Failed to load news');
        }

        final dynamic data = responseData['Data'] ?? responseData['data'] ?? responseData;

        if (data is Map<String, dynamic>) {
          final model = NewsModel.fromJson(data);
          return NewsListResponse(
            count: 1,
            filtered: 1,
            list: [model],
            code: code,
            succeeded: succeeded,
            message: message,
            description: description,
          );
        }

        throw Exception('Invalid response format');
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'API Error: ${e.response?.data['Message'] ?? e.message}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  @override
  Future<void> createNews({
    required String code,
    required String content,
    required int idCategory,
    required String source,
    required String title,
  }) async {
    try {
      final response = await _dio.post(
        '/News/add',
        data: {
          'Code': code,
          'Content': content,
          'IdCategory': idCategory,
          'Source': source,
          'Title': title,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create news: ${response.statusMessage}');
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final succeeded = responseData['Succeeded'] as bool? ?? false;
        final message = responseData['Message'] as String? ?? '';

        if (!succeeded) {
          throw Exception(message.isNotEmpty ? message : 'Failed to create news');
        }

        return;
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['Message']?.toString() ?? e.message);
        }
        throw Exception('API Error: ${e.message}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create news: $e');
    }
  }
}
