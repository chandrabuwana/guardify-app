import '../entities/news.dart';

abstract class NewsRepository {
  /// Get paginated news list
  /// [start] - starting index for pagination
  /// [length] - number of items to fetch
  /// [searchQuery] - optional search query
  Future<List<News>> getNews({
    int start = 0,
    int length = 10,
    String? searchQuery,
  });

  Future<News?> getNewsById(String id);
  Future<List<News>> searchNews(String query);
  Future<List<News>> filterNewsByCategory(NewsCategory category);
  Future<News> createNews(News news);
  Future<News> updateNews(News news);
  Future<void> deleteNews(String id);
}
