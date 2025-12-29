class PanicButtonFilterItem {
  final String field;
  final String search;

  const PanicButtonFilterItem({
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

class PanicButtonSortItem {
  final String field;
  final int type; // 0 = ascending, 1 = descending

  const PanicButtonSortItem({
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

class PanicButtonListRequest {
  final List<PanicButtonFilterItem> filter;
  final PanicButtonSortItem sort;
  final int start;
  final int length;

  const PanicButtonListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

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
  factory PanicButtonListRequest.initial({int length = 10}) {
    return PanicButtonListRequest(
      filter: const [
        PanicButtonFilterItem(field: '', search: ''),
      ],
      sort: const PanicButtonSortItem(field: '', type: 0),
      start: 0,
      length: length,
    );
  }

  // Create request with search filter
  PanicButtonListRequest withSearch(String searchQuery) {
    return PanicButtonListRequest(
      filter: [
        PanicButtonFilterItem(field: '', search: searchQuery),
      ],
      sort: sort,
      start: 0,
      length: length,
    );
  }

  // Create request for pagination
  PanicButtonListRequest copyWithPagination(int start) {
    return PanicButtonListRequest(
      filter: filter,
      sort: sort,
      start: start,
      length: length,
    );
  }
}

