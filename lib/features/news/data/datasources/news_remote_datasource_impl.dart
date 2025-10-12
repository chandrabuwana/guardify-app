import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/news_list_request.dart';
import '../models/news_list_response.dart';
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
      // Create a filter to search by ID
      final request = NewsListRequest(
        filter: [
          NewsFilterItem(field: 'Id', search: id),
        ],
        sort: const NewsSortItem(field: '', type: 0),
        start: 0,
        length: 1,
      );

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
}
