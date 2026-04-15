class CompanyRuleFilterItem {
  final String field;
  final String search;

  const CompanyRuleFilterItem({
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

class CompanyRuleSortItem {
  final String field;
  final int type; // 0 = ascending, 1 = descending

  const CompanyRuleSortItem({
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

class CompanyRuleListRequest {
  final List<CompanyRuleFilterItem> filter;
  final CompanyRuleSortItem sort;
  final int start;
  final int length;

  const CompanyRuleListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  })  : assert(start >= 0, 'Start must be non-negative'),
        assert(length > 0, 'Length must be positive');

  Map<String, dynamic> toJson() {
    // API uses 1-based indexing, so convert 0-based to 1-based
    final validStart = start < 0 ? 1 : start + 1;
    final validLength = length <= 0 ? 10 : length;

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
  factory CompanyRuleListRequest.initial({int length = 10}) {
    return CompanyRuleListRequest(
      filter: const [],
      sort: const CompanyRuleSortItem(field: 'CreateDate', type: 1),
      start: 0, // Internal 0-based, will be converted to 1 in toJson
      length: length,
    );
  }

  CompanyRuleListRequest copyWith({
    List<CompanyRuleFilterItem>? filter,
    CompanyRuleSortItem? sort,
    int? start,
    int? length,
  }) {
    return CompanyRuleListRequest(
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      start: start ?? this.start,
      length: length ?? this.length,
    );
  }

  // Create request for pagination
  CompanyRuleListRequest copyWithPagination(int start) {
    return CompanyRuleListRequest(
      filter: filter,
      sort: sort,
      start: start,
      length: length,
    );
  }

  // Create request with search filter
  CompanyRuleListRequest copyWithSearch(String searchQuery) {
    return CompanyRuleListRequest(
      filter: [
        CompanyRuleFilterItem(field: 'Name', search: searchQuery),
      ],
      sort: sort,
      start: start,
      length: length,
    );
  }
}
