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
    final validStart = start < 0 ? 1 : start + 1;
    final validLength = length <= 0 ? 50 : length;
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
    
    // Filter tanggal: dilakukan di client berdasarkan IncidentDate tiap incident
    // (tidak dikirim ke API - response list tidak punya date range)

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
      sort: const IncidentSortItem(field: 'CreateDate', type: 1),
      start: start,
      length: length,
    );
  }
}

