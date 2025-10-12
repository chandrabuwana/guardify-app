class NewsFilterItem {
  final String field;
  final String search;

  const NewsFilterItem({
    required this.field,
    required this.search,
  });

  Map<String, dynamic> toJson() {
    return {
      'Field': field,
      'Search': search,
    };
  }
}

class NewsSortItem {
  final String field;
  final int type; // 0 = ascending, 1 = descending

  const NewsSortItem({
    required this.field,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'Field': field,
      'Type': type,
    };
  }
}

class NewsListRequest {
  final List<NewsFilterItem> filter;
  final NewsSortItem sort;
  final int start;
  final int length;

  const NewsListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  })  : assert(start >= 0, 'Start must be non-negative'),
        assert(length > 0, 'Length must be positive');

  Map<String, dynamic> toJson() {
    // API uses 1-based indexing, so convert 0-based to 1-based
    // Ensure start is at least 1 and length is positive
    final validStart = start < 0 ? 1 : start + 1;
    final validLength = length <= 0 ? 10 : length;

    return {
      'Filter': filter.map((f) => f.toJson()).toList(),
      'Sort': sort.toJson(),
      'Start': validStart,
      'Length': validLength,
    };
  }

  // Default request for initial load
  factory NewsListRequest.initial({int length = 10}) {
    return NewsListRequest(
      filter: const [
        NewsFilterItem(field: '', search: ''),
      ],
      sort: const NewsSortItem(field: '', type: 0),
      start: 0, // Internal 0-based, will be converted to 1 in toJson
      length: length,
    );
  }

  // Create request for pagination
  NewsListRequest copyWithPagination(int start) {
    return NewsListRequest(
      filter: filter,
      sort: sort,
      start: start,
      length: length,
    );
  }

  // Create request with search filter
  NewsListRequest copyWithSearch(String searchQuery) {
    return NewsListRequest(
      filter: [
        NewsFilterItem(field: 'Title', search: searchQuery),
      ],
      sort: sort,
      start: start,
      length: length,
    );
  }
}
