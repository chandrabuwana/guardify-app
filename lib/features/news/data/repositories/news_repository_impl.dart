import 'package:injectable/injectable.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';
import '../models/news_list_request.dart';

@LazySingleton(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<News>> getNews({
    int start = 0,
    int length = 10,
    String? searchQuery,
  }) async {
    try {
      // Ensure start and length are valid (internally 0-based, will be converted to 1-based in request)
      final validStart = start < 0 ? 0 : start;
      final validLength = length <= 0 ? 10 : length;

      NewsListRequest request;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Create request with search filter
        request = NewsListRequest(
          filter: [
            NewsFilterItem(field: 'Title', search: searchQuery),
          ],
          sort: const NewsSortItem(
              field: 'CreateDate', type: 1), // Sort by date descending
          start: validStart,
          length: validLength,
        );
      } else {
        // Create default request
        request = NewsListRequest(
          filter: const [
            NewsFilterItem(field: '', search: ''),
          ],
          sort: const NewsSortItem(
              field: 'CreateDate', type: 1), // Sort by date descending
          start: validStart,
          length: validLength,
        );
      }

      final response = await remoteDataSource.getNewsList(request);
      return response.list.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get news: $e');
    }
  }

  @override
  Future<News?> getNewsById(String id) async {
    try {
      final response = await remoteDataSource.getNewsById(id);
      if (response.list.isEmpty) {
        return null;
      }
      return response.list.first.toEntity();
    } catch (e) {
      throw Exception('Failed to get news by ID: $e');
    }
  }

  @override
  Future<List<News>> searchNews(String query) async {
    try {
      if (query.isEmpty) {
        return await getNews();
      }

      final request = NewsListRequest(
        filter: [
          NewsFilterItem(field: 'Title', search: query),
        ],
        sort: const NewsSortItem(field: 'CreateDate', type: 1),
        start: 0,
        length: 100, // Get more results for search
      );

      final response = await remoteDataSource.getNewsList(request);
      return response.list.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }

  @override
  Future<List<News>> filterNewsByCategory(NewsCategory category) async {
    try {
      final request = NewsListRequest(
        filter: [
          NewsFilterItem(field: 'Category.Name', search: category.displayName),
        ],
        sort: const NewsSortItem(field: 'CreateDate', type: 1),
        start: 0,
        length: 100,
      );

      final response = await remoteDataSource.getNewsList(request);
      return response.list.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to filter news by category: $e');
    }
  }

  @override
  Future<News> createNews(News news) async {
    // TODO: Implement create news API when endpoint is available
    throw UnimplementedError('Create news API not yet implemented');
  }

  @override
  Future<News> updateNews(News news) async {
    // TODO: Implement update news API when endpoint is available
    throw UnimplementedError('Update news API not yet implemented');
  }

  @override
  Future<void> deleteNews(String id) async {
    // TODO: Implement delete news API when endpoint is available
    throw UnimplementedError('Delete news API not yet implemented');
  }
}
