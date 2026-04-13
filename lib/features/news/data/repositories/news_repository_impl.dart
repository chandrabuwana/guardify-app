import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

import '../../../../core/utils/image_compress_util.dart';
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
    NewsCategory? category,
    bool newestFirst = true,
  }) async {
    try {
      // Ensure start and length are valid (internally 0-based, will be converted to 1-based in request)
      final validStart = start < 0 ? 0 : start;
      final validLength = length <= 0 ? 10 : length;

      final filters = <NewsFilterItem>[];

      if (searchQuery != null && searchQuery.isNotEmpty) {
        filters.add(NewsFilterItem(field: 'Title', search: searchQuery));
      }

      if (category != null) {
        filters.add(
          NewsFilterItem(
            field: 'IdCategory',
            search: _mapCategoryToId(category.displayName).toString(),
          ),
        );
      }

      if (filters.isEmpty) {
        filters.add(const NewsFilterItem(field: '', search: ''));
      }

      final request = NewsListRequest(
        filter: filters,
        sort: NewsSortItem(field: 'CreateDate', type: newestFirst ? 1 : 0),
        start: validStart,
        length: validLength,
      );

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
          NewsFilterItem(
            field: 'IdCategory',
            search: _mapCategoryToId(category.displayName).toString(),
          ),
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
    try {
      final now = DateTime.now();

      final idCategory = _mapCategoryToId(news.category);
      final code = now.millisecondsSinceEpoch.toString();

      Map<String, dynamic>? files;
      final photoPath = news.imageUrl;
      if (photoPath != null && photoPath.trim().isNotEmpty) {
        files = await _tryBuildFilesPayload(photoPath.trim());
      }

      await remoteDataSource.createNews(
        code: code,
        content: news.content,
        idCategory: idCategory,
        source: news.source,
        title: news.title,
        files: files,
      );

      return news.copyWith(
        id: code,
        createdAt: now,
        updatedAt: now,
        publishedAt: now,
      );
    } catch (e) {
      throw Exception('Failed to create news: $e');
    }
  }

  int _mapCategoryToId(String category) {
    final normalized = category.trim().toLowerCase();
    if (normalized == 'bencana') return 1;
    if (normalized == 'cuaca') return 2;
    return 3;
  }

  Future<Map<String, dynamic>?> _tryBuildFilesPayload(String filePath) async {
    try {
      final file = await ImageCompressUtil.ensureMax1MbIfImage(filePath);
      if (!await file.exists()) {
        return null;
      }

      final bytes = await file.readAsBytes();
      final base64Data = base64Encode(bytes);
      final fileName = path.basename(file.path);
      final extension = path.extension(fileName).toLowerCase();

      String mimeType = 'application/octet-stream';
      if (extension == '.png') {
        mimeType = 'image/png';
      } else if (extension == '.jpg' || extension == '.jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == '.gif') {
        mimeType = 'image/gif';
      } else if (extension == '.webp') {
        mimeType = 'image/webp';
      } else if (extension == '.bmp') {
        mimeType = 'image/bmp';
      }

      return {
        'Filename': fileName,
        'MimeType': mimeType,
        'Base64': base64Data,
        'FileSize': bytes.length,
      };
    } catch (_) {
      return null;
    }
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
