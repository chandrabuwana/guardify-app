import 'package:equatable/equatable.dart';
import '../../domain/entities/news.dart';

class NewsState extends Equatable {
  final List<News> news;
  final List<News> filteredNews;
  final News? selectedNews;
  final String searchQuery;
  final NewsCategory? selectedCategory;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSearching;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const NewsState({
    required this.news,
    required this.filteredNews,
    this.selectedNews,
    required this.searchQuery,
    this.selectedCategory,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isSearching,
    required this.hasReachedMax,
    required this.currentPage,
    this.errorMessage,
  });

  factory NewsState.initial() {
    return const NewsState(
      news: [],
      filteredNews: [],
      searchQuery: '',
      isLoading: false,
      isLoadingMore: false,
      isSearching: false,
      hasReachedMax: false,
      currentPage: 0,
    );
  }

  NewsState copyWith({
    List<News>? news,
    List<News>? filteredNews,
    News? selectedNews,
    String? searchQuery,
    NewsCategory? selectedCategory,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSearching,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return NewsState(
      news: news ?? this.news,
      filteredNews: filteredNews ?? this.filteredNews,
      selectedNews: selectedNews ?? this.selectedNews,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSearching: isSearching ?? this.isSearching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        news,
        filteredNews,
        selectedNews,
        searchQuery,
        selectedCategory,
        isLoading,
        isLoadingMore,
        isSearching,
        hasReachedMax,
        currentPage,
        errorMessage,
      ];
}
