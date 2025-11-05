import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;
  static const int pageSize = 10;

  NewsBloc(this.newsRepository) : super(NewsState.initial()) {
    on<NewsLoadNews>(_onLoadNews);
    on<NewsLoadMoreNews>(_onLoadMoreNews);
    on<NewsRefreshNews>(_onRefreshNews);
    on<NewsLoadNewsById>(_onLoadNewsById);
    on<NewsSearchNews>(_onSearchNews);
    on<NewsFilterByCategory>(_onFilterByCategory);
    on<NewsCreateNews>(_onCreateNews);
    on<NewsUpdateNews>(_onUpdateNews);
    on<NewsDeleteNews>(_onDeleteNews);
    on<NewsClearSearch>(_onClearSearch);
    on<NewsClearFilter>(_onClearFilter);
  }

  Future<void> _onLoadNews(
    NewsLoadNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      hasReachedMax: false,
      currentPage: 0,
    ));

    try {
      final news = await newsRepository.getNews(
        start: 0,
        length: pageSize,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      emit(state.copyWith(
        isLoading: false,
        news: news,
        filteredNews: news,
        hasReachedMax: news.length < pageSize,
        currentPage: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadMoreNews(
    NewsLoadMoreNews event,
    Emitter<NewsState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    try {
      final nextPage = state.currentPage + 1;
      final newNews = await newsRepository.getNews(
        start: nextPage * pageSize,
        length: pageSize,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      if (newNews.isEmpty) {
        emit(state.copyWith(
          isLoadingMore: false,
          hasReachedMax: true,
        ));
      } else {
        final updatedNews = List<News>.from(state.news)..addAll(newNews);
        emit(state.copyWith(
          isLoadingMore: false,
          news: updatedNews,
          filteredNews: updatedNews,
          hasReachedMax: newNews.length < pageSize,
          currentPage: nextPage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Gagal memuat lebih banyak berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshNews(
    NewsRefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(
      hasReachedMax: false,
      currentPage: 0,
      errorMessage: null,
    ));

    try {
      final news = await newsRepository.getNews(
        start: 0,
        length: pageSize,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      emit(state.copyWith(
        news: news,
        filteredNews: news,
        hasReachedMax: news.length < pageSize,
        currentPage: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal memperbarui berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadNewsById(
    NewsLoadNewsById event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final news = await newsRepository.getNewsById(event.id);
      emit(state.copyWith(
        isLoading: false,
        selectedNews: news,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat detail berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSearchNews(
    NewsSearchNews event,
    Emitter<NewsState> emit,
  ) async {
    // Reset pagination when searching
    emit(state.copyWith(
      isSearching: true,
      searchQuery: event.query,
      currentPage: 0,
      hasReachedMax: false,
    ));

    try {
      if (event.query.isEmpty) {
        // If search is cleared, reload all news
        final news = await newsRepository.getNews(
          start: 0,
          length: pageSize,
        );
        emit(state.copyWith(
          isSearching: false,
          news: news,
          filteredNews: news,
          searchQuery: '',
          hasReachedMax: news.length < pageSize,
          currentPage: 0,
        ));
      } else {
        // Search with new query
        final results = await newsRepository.getNews(
          start: 0,
          length: pageSize,
          searchQuery: event.query,
        );
        emit(state.copyWith(
          isSearching: false,
          news: results,
          filteredNews: results,
          hasReachedMax: results.length < pageSize,
          currentPage: 0,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSearching: false,
        errorMessage: 'Gagal mencari berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFilterByCategory(
    NewsFilterByCategory event,
    Emitter<NewsState> emit,
  ) async {
    // Reset pagination when filtering
    emit(state.copyWith(
      isLoading: true,
      currentPage: 0,
      hasReachedMax: false,
    ));

    try {
      final results = await newsRepository.filterNewsByCategory(event.category);
      emit(state.copyWith(
        isLoading: false,
        news: results,
        filteredNews: results,
        selectedCategory: event.category,
        hasReachedMax: results.length < pageSize,
        currentPage: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memfilter berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCreateNews(
    NewsCreateNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final newNews = await newsRepository.createNews(event.news);
      final updatedNews = List<News>.from(state.news)..add(newNews);

      emit(state.copyWith(
        isLoading: false,
        news: updatedNews,
        filteredNews: updatedNews,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal membuat berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateNews(
    NewsUpdateNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final updatedNews = await newsRepository.updateNews(event.news);
      final newsList = state.news.map((news) {
        return news.id == updatedNews.id ? updatedNews : news;
      }).toList();

      emit(state.copyWith(
        isLoading: false,
        news: newsList,
        filteredNews: newsList,
        selectedNews: updatedNews,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memperbarui berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDeleteNews(
    NewsDeleteNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await newsRepository.deleteNews(event.id);
      final updatedNews =
          state.news.where((news) => news.id != event.id).toList();

      emit(state.copyWith(
        isLoading: false,
        news: updatedNews,
        filteredNews: updatedNews,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menghapus berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onClearSearch(
    NewsClearSearch event,
    Emitter<NewsState> emit,
  ) async {
    try {
      // Reload news without search query
      final news = await newsRepository.getNews(
        start: 0,
        length: pageSize,
      );
      emit(state.copyWith(
        searchQuery: '',
        news: news,
        filteredNews: news,
        currentPage: 0,
        hasReachedMax: news.length < pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal memuat berita: ${e.toString()}',
      ));
    }
  }

  Future<void> _onClearFilter(
    NewsClearFilter event,
    Emitter<NewsState> emit,
  ) async {
    try {
      // Reload news without filter
      final news = await newsRepository.getNews(
        start: 0,
        length: pageSize,
      );
      emit(state.copyWith(
        selectedCategory: null,
        news: news,
        filteredNews: news,
        currentPage: 0,
        hasReachedMax: news.length < pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal memuat berita: ${e.toString()}',
      ));
    }
  }
}
