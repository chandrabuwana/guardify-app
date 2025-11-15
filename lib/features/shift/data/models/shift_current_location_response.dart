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
  String? get carryOverTasks {
    print('🔍 carryOverTasks - Checking raw data for ListCarryOver');
    print('🔍 carryOverTasks - raw keys: ${raw.keys.toList()}');
    
    final listCarryOver = raw['ListCarryOver'];
    print('🔍 carryOverTasks - listCarryOver: $listCarryOver');
    print('🔍 carryOverTasks - listCarryOver is List: ${listCarryOver is List}');
    
    if (listCarryOver == null || listCarryOver is! List) {
      print('❌ carryOverTasks - ListCarryOver is null or not a List');
      return null;
    }

    print('✅ carryOverTasks - Found ${listCarryOver.length} items in ListCarryOver');
    
    final openTasks = <String>[];
    int index = 0;
    for (final item in listCarryOver) {
      if (item is! Map<String, dynamic>) {
        print('⚠️ carryOverTasks - Item[$index] is not a Map');
        index++;
        continue;
      }
      
      final status = (item['Status'] as String?)?.toUpperCase();
      print('🔍 carryOverTasks - Item[$index] Status: $status');
      
      if (status == 'OPEN') {
        final note = item['ReportNote'] as String?;
        print('🔍 carryOverTasks - Item[$index] ReportNote: $note');
        
        if (note != null && note.isNotEmpty) {
          openTasks.add(note);
          print('✅ carryOverTasks - Added ReportNote: $note');
        }
      }
      index++;
    }
    
    if (openTasks.isEmpty) {
      print('❌ carryOverTasks - No OPEN tasks found');
      return null;
    }
    
    final result = openTasks.join('\n');
    print('✅ carryOverTasks - Final result: $result');
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

