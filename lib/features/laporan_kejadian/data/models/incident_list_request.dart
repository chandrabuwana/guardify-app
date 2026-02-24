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
    DateTime? startDate,
    DateTime? endDate,
    String? incidentTypeId,
    String? locationId,
    String? teamId, // Filter by team (userId)
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
    
    // Date range filter - API might need separate fields or combined
    // For now, we'll use IncidentDate field with date range
    // If API supports range, we might need to adjust this
    if (startDate != null && endDate != null) {
      // If both dates provided, use start date as filter
      // API might need separate handling for date range
      filters.add(IncidentFilterItem(
        field: 'IncidentDate',
        search: '${startDate.toIso8601String().split('T')[0]}|${endDate.toIso8601String().split('T')[0]}',
      ));
    } else if (startDate != null) {
      filters.add(IncidentFilterItem(
        field: 'IncidentDate',
        search: startDate.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
      ));
    } else if (endDate != null) {
      filters.add(IncidentFilterItem(
        field: 'IncidentDate',
        search: endDate.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
      ));
    }
    
    if (incidentTypeId != null && incidentTypeId.isNotEmpty) {
      filters.add(IncidentFilterItem(field: 'IdIncidentType', search: incidentTypeId));
    }
    
    if (locationId != null && locationId.isNotEmpty) {
      filters.add(IncidentFilterItem(field: 'AreasId', search: locationId));
    }
    
    // Filter by team (userId) - for "Tugas Saya" tab
    if (teamId != null && teamId.isNotEmpty) {
      filters.add(IncidentFilterItem(field: 'team', search: teamId));
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

