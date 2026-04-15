/// Paginated Response untuk list data dengan metadata pagination
class PaginatedResponse<T> {
  final List<T> data;
  final int totalCount;
  final int filteredCount;
  final int currentPage;
  final int pageSize;
  final bool hasMore;

  const PaginatedResponse({
    required this.data,
    required this.totalCount,
    required this.filteredCount,
    required this.currentPage,
    required this.pageSize,
    required this.hasMore,
  });

  /// Check if there's more data to load
  bool get canLoadMore => hasMore && data.isNotEmpty;

  /// Calculate total pages
  int get totalPages => (totalCount / pageSize).ceil();

  @override
  String toString() {
    return 'PaginatedResponse(data: ${data.length}, totalCount: $totalCount, filteredCount: $filteredCount, currentPage: $currentPage, hasMore: $hasMore)';
  }
}
