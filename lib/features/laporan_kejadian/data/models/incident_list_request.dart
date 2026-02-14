class IncidentFilterItem {
  final String field;
  final String search;

  const IncidentFilterItem({
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

class IncidentSortItem {
  final String field;
  final int type; // 0 = ascending, 1 = descending

  const IncidentSortItem({
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

class IncidentListRequest {
  final List<IncidentFilterItem> filter;
  final IncidentSortItem sort;
  final int start;
  final int length;

  const IncidentListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  Map<String, dynamic> toJson() {
    // API uses 1-based indexing, so convert 0-based to 1-based
    // Ensure start is at least 1 and length is positive
    final validStart = start < 0 ? 1 : start + 1;
    final validLength = length <= 0 ? 50 : length; // Increased from 10 to 50
    
    return {
      'Filter': filter.map((f) => f.toJson()).toList(),
      'Sort': sort.toJson(),
      'Start': validStart,
      'Length': validLength,
    };
  }

  // Default request for initial load
  factory IncidentListRequest.initial({
    int start = 0,
    int length = 50, // Increased from 10 to 50
    String? searchQuery,
    String? status,
    String? picId,
  }) {
    final filters = <IncidentFilterItem>[];
    
    if (picId != null && picId.isNotEmpty) {
      filters.add(IncidentFilterItem(field: 'PicId', search: picId));
    }
    
    if (status != null && status.isNotEmpty) {
      filters.add(IncidentFilterItem(field: 'Status', search: status));
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filters.add(IncidentFilterItem(field: 'IncidentDescription', search: searchQuery));
    }

    return IncidentListRequest(
      filter: filters.isEmpty 
          ? [const IncidentFilterItem(field: '', search: '')]
          : filters,
      sort: const IncidentSortItem(field: 'CreateDate', type: 1), // Descending
      start: start,
      length: length,
    );
  }
}

