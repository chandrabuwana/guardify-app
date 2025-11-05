import '../models/news_list_request.dart';
import '../models/news_list_response.dart';

abstract class NewsRemoteDataSource {
  /// Get news list with pagination
  Future<NewsListResponse> getNewsList(NewsListRequest request);

  /// Get news by ID
  Future<NewsListResponse> getNewsById(String id);
}
