class ShiftCurrentLocationData {
  final String? fullname;
  final String? location;
  final String? currentLocation;
  final String? routeName;
  final String? shiftDetailId;
  final Map<String, dynamic> raw; // Store raw JSON to access ListCarryOver

  const ShiftCurrentLocationData({
    this.fullname,
    this.location,
    this.currentLocation,
    this.routeName,
    this.shiftDetailId,
    required this.raw,
  });

  factory ShiftCurrentLocationData.fromJson(Map<String, dynamic> json) {
    return ShiftCurrentLocationData(
      fullname: json['Fullname'] as String?,
      location: json['Location'] as String?,
      currentLocation: json['CurrentLocation'] as String?,
      routeName: json['RouteName'] as String?,
      shiftDetailId: json['IdShiftDetail'] as String? ??
          json['ShiftDetailId'] as String?,
      raw: json, // Store raw JSON
    );
  }

  /// Get tugas lanjutan dari ListCarryOver yang statusnya "OPEN"
  /// Mengambil ReportNote dari setiap item yang Status = "OPEN"
  /// Deduplicates notes within and across items, limits to 50 tasks max
  String? get carryOverTasks {
    final listCarryOver = raw['ListCarryOver'];
    
    if (listCarryOver == null || listCarryOver is! List) {
      return null;
    }

    print('📋 carryOverTasks - Processing ${listCarryOver.length} items');
    
    final seenNotes = <String>{}; // Deduplication across all items
    final openTasks = <String>[];
    
    for (int i = 0; i < listCarryOver.length; i++) {
      // Safety limit: stop processing after collecting 50 unique tasks
      if (openTasks.length >= 50) break;
      
      final item = listCarryOver[i];
      if (item is! Map<String, dynamic>) continue;
      
      final status = (item['Status'] as String?)?.toUpperCase();
      if (status != 'OPEN') continue;
      
      final note = item['ReportNote'] as String?;
      if (note == null || note.isEmpty) continue;
      
      // Deduplicate lines within the note (API returns notes with duplicated content)
      final noteLines = note.split('\n').where((line) => line.trim().isNotEmpty).toList();
      final uniqueLines = <String>[];
      final lineSet = <String>{};
      for (final line in noteLines) {
        final trimmed = line.trim();
        if (lineSet.add(trimmed)) {
          uniqueLines.add(trimmed);
        }
      }
      final cleanedNote = uniqueLines.join('\n');
      
      // Skip if this cleaned note was already seen from another item
      if (cleanedNote.isNotEmpty && seenNotes.add(cleanedNote)) {
        openTasks.add(cleanedNote);
      }
    }
    
    if (openTasks.isEmpty) return null;
    
    final result = openTasks.join('\n');
    print('✅ carryOverTasks - ${openTasks.length} unique tasks extracted');
    return result;
  }
}

class ShiftCurrentLocationResponse {
  final ShiftCurrentLocationData? data;
  final int? code;
  final bool? succeeded;
  final String? message;
  final String? description;

  const ShiftCurrentLocationResponse({
    this.data,
    this.code,
    this.succeeded,
    this.message,
    this.description,
  });

  factory ShiftCurrentLocationResponse.fromJson(Map<String, dynamic> json) {
    return ShiftCurrentLocationResponse(
      data: json['Data'] != null
          ? ShiftCurrentLocationData.fromJson(json['Data'] as Map<String, dynamic>)
          : null,
      code: json['Code'] as int?,
      succeeded: json['Succeeded'] as bool?,
      message: json['Message'] as String?,
      description: json['Description'] as String?,
    );
  }
}

