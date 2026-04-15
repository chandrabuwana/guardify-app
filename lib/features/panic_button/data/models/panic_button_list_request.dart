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
    final validStart = start < 1 ? 1 : start;
    final validLength = length < 0 ? 0 : length;

    final cleanedFilter = filter
        .where(
          (f) => f.field.trim().isNotEmpty && f.search.trim().isNotEmpty,
        )
        .toList();

    return {
      'Filter': cleanedFilter.map((f) => f.toJson()).toList(),
      'Sort': sort.toJson(),
      'Start': validStart,
      'Length': validLength,
    };
  }

  // Default request for initial load
  factory PanicButtonListRequest.initial({int length = 10}) {
    return PanicButtonListRequest(
      filter: const [],
      sort: const PanicButtonSortItem(field: 'status', type: 0),
      start: 1,
      length: length,
    );
  }

  PanicButtonListRequest copyWith({
    List<PanicButtonFilterItem>? filter,
    PanicButtonSortItem? sort,
    int? start,
    int? length,
  }) {
    return PanicButtonListRequest(
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      start: start ?? this.start,
      length: length ?? this.length,
    );
  }

  PanicButtonListRequest withDescriptionSearch(String searchQuery) {
    final query = searchQuery.trim();
    final nextFilter = [
      ...filter.where((f) => f.field.toLowerCase() != 'description'),
      if (query.isNotEmpty) const PanicButtonFilterItem(field: 'description', search: ''),
    ];

    return copyWith(
      filter: nextFilter
          .map(
            (f) => f.field.toLowerCase() == 'description'
                ? PanicButtonFilterItem(field: 'description', search: query)
                : f,
          )
          .toList(),
      start: 1,
    );
  }

  PanicButtonListRequest withStatusesFilter(List<String> statuses) {
    final cleaned = statuses.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    final withoutStatus = filter.where((f) => f.field.toLowerCase() != 'status').toList();
    final statusFilters = cleaned
        .map((s) => PanicButtonFilterItem(field: 'status', search: s))
        .toList();

    return copyWith(
      filter: [...withoutStatus, ...statusFilters],
      start: 1,
    );
  }

  PanicButtonListRequest withStatusFilter(String? status) {
    final value = status?.trim() ?? '';
    final nextFilter = [
      ...filter.where((f) => f.field.toLowerCase() != 'status'),
      if (value.isNotEmpty) const PanicButtonFilterItem(field: 'status', search: ''),
    ];

    return copyWith(
      filter: nextFilter
          .map(
            (f) => f.field.toLowerCase() == 'status'
                ? PanicButtonFilterItem(field: 'status', search: value)
                : f,
          )
          .toList(),
      start: 1,
    );
  }

  PanicButtonListRequest withCreateDateFilter(String field, String? dateValue) {
    final f = field.trim();
    final v = dateValue?.trim() ?? '';
    if (f.isEmpty) return this;

    final nextFilter = [
      ...filter.where((it) => it.field.toLowerCase() != f.toLowerCase()),
      if (v.isNotEmpty) PanicButtonFilterItem(field: f, search: ''),
    ];

    return copyWith(
      filter: nextFilter
          .map(
            (it) => it.field.toLowerCase() == f.toLowerCase()
                ? PanicButtonFilterItem(field: f, search: v)
                : it,
          )
          .toList(),
      start: 1,
    );
  }

  PanicButtonListRequest withSort({required String field, required int type}) {
    return copyWith(
      sort: PanicButtonSortItem(field: field, type: type),
      start: 1,
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

