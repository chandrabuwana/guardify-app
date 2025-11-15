class ShiftCheckoutDetailResponse {
  final ShiftCheckoutDetailData? data;
  final int? code;
  final bool? succeeded;
  final String? message;
  final String? description;

  const ShiftCheckoutDetailResponse({
    this.data,
    this.code,
    this.succeeded,
    this.message,
    this.description,
  });

  factory ShiftCheckoutDetailResponse.fromJson(Map<String, dynamic> json) {
    return ShiftCheckoutDetailResponse(
      data: json['Data'] != null
          ? ShiftCheckoutDetailData.fromJson(
              json['Data'] as Map<String, dynamic>,
            )
          : null,
      code: json['Code'] as int?,
      succeeded: json['Succeeded'] as bool?,
      message: json['Message'] as String?,
      description: json['Description'] as String?,
    );
  }
}

class ShiftCheckoutDetailData {
  final Map<String, dynamic> raw;

  const ShiftCheckoutDetailData({
    required this.raw,
  });

  factory ShiftCheckoutDetailData.fromJson(Map<String, dynamic> json) {
    return ShiftCheckoutDetailData(raw: json);
  }

  Map<String, dynamic>? _map(String key) {
    final value = raw[key];
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  Map<String, dynamic>? get _patrol =>
      _map('Patrol') ?? _map('Patroli') ?? _map('PatrolSummary');
  Map<String, dynamic>? get _followUp =>
      _map('FollowUp') ?? _map('TugasLanjutan') ?? _map('FollowUpSummary');

  String? _stringFromKeys(List<String> keys, {Map<String, dynamic>? source}) {
    final map = source ?? raw;
    for (final key in keys) {
      if (!map.containsKey(key)) continue;
      final value = map[key];
      final str = _asString(value);
      if (str != null && str.isNotEmpty) return str;
    }
    return null;
  }

  int? _intFromKeys(List<String> keys, {Map<String, dynamic>? source}) {
    final map = source ?? raw;
    for (final key in keys) {
      if (!map.containsKey(key)) continue;
      final value = map[key];
      final parsed = _asInt(value);
      if (parsed != null) return parsed;
    }
    return null;
  }

  bool? _boolFromKeys(List<String> keys, {Map<String, dynamic>? source}) {
    final map = source ?? raw;
    for (final key in keys) {
      if (!map.containsKey(key)) continue;
      final value = map[key];
      final parsed = _asBool(value);
      if (parsed != null) return parsed;
    }
    return null;
  }

  String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.trim();
    if (value is num || value is bool) return value.toString();
    return null;
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool? _asBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if ([
        'true',
        '1',
        'yes',
        'ya',
        'selesai',
        'completed',
        'done'
      ].contains(normalized)) {
        return true;
      }
      if ([
        'false',
        '0',
        'no',
        'tidak',
        'belum',
        'pending'
      ].contains(normalized)) {
        return false;
      }
    }
    return null;
  }

  // --------- Display helpers ----------

  String? get shiftDetailId =>
      _stringFromKeys(['IdShiftDetail', 'ShiftDetailId', 'ShiftDetail']);

  String? get guardLocation =>
      _stringFromKeys(['LocationName', 'LokasiPengamanan', 'Location', 'Lokasi']);

  String? get currentLocation =>
      _stringFromKeys(['CurrentLocation', 'CurrentLoc', 'LokasiTerkini']);

  bool? get isAtGuardLocation => _boolFromKeys(
        [
          'IsAtLocation',
          'IsOnLocation',
          'IsValidLocation',
          'LocationValid',
        ],
      );

  String? get locationWarning => _stringFromKeys(
        [
          'LocationWarning',
          'WarningMessage',
          'LocationNote',
        ],
      );

  String? get securityReport => _stringFromKeys(
        [
          'LaporanPengamanan',
          'Laporan',
          'SecurityReport',
          'Report',
        ],
      );

  String? get pendingTasksDescription {
    // Cek apakah ada ListCarryOver dengan status OPEN
    final carryOverTasks = _getCarryOverTasks();
    if (carryOverTasks != null && carryOverTasks.isNotEmpty) {
      return carryOverTasks;
    }
    
    // Fallback ke field lainnya
    return _stringFromKeys(
      [
        'TugasTertunda',
        'PendingTasks',
        'PendingTaskNotes',
      ],
    );
  }

  /// Get tugas lanjutan dari ListCarryOver yang statusnya "OPEN"
  String? _getCarryOverTasks() {
    final listCarryOver = raw['ListCarryOver'];
    if (listCarryOver == null || listCarryOver is! List) {
      return null;
    }

    final openTasks = <String>[];
    for (final item in listCarryOver) {
      if (item is! Map<String, dynamic>) continue;
      
      final status = _asString(item['Status'])?.toUpperCase();
      if (status == 'OPEN') {
        final note = _asString(item['Note']);
        if (note != null && note.isNotEmpty) {
          openTasks.add(note);
        }
      }
    }

    if (openTasks.isEmpty) {
      return null;
    }

    // Gabungkan semua note dengan newline
    return openTasks.join('\n');
  }

  String? get statusTugasLabel =>
      _stringFromKeys(['StatusTugas', 'TaskStatus', 'FollowUpStatus']) ??
      followUpStatusLabel;

  String? get pakaianPersonilLabel =>
      _stringFromKeys(['PakaianPersonil', 'Uniform', 'Outfit']);

  String? get pakaianPersonilNormalized {
    final label = pakaianPersonilLabel?.toLowerCase();
    if (label == null) return null;
    if (label.contains('harian')) return 'seragam_harian';
    if (label.contains('lapangan')) return 'seragam_lapangan';
    if (label.contains('dinas')) return 'pakaian_dinas';
    return null;
  }

  String? get statusTugasNormalized {
    final label = statusTugasLabel?.toLowerCase();
    if (label == null) return null;
    if (label.contains('tidak') || label.contains('belum')) {
      return 'tidak_selesai';
    }
    if (label.contains('selesai') || label.contains('complete')) {
      return 'selesai';
    }
    return null;
  }

  // Patrol summary
  String? get patrolStatusLabel => _stringFromKeys(
        [
          'PatrolStatus',
          'PatroliStatus',
          'StatusPatroli',
        ],
      ) ??
      _stringFromKeys(
        [
          'Status',
          'Label',
        ],
        source: _patrol,
      );

  int? get patrolCompleted => _intFromKeys(
        [
          'PatrolCompleted',
          'PatroliCompleted',
          'JumlahPatroliSelesai',
          'PatrolledLocations',
        ],
      ) ??
      _intFromKeys(
        [
          'Completed',
          'Done',
          'Selesai',
        ],
        source: _patrol,
      );

  int? get patrolTotal => _intFromKeys(
        [
          'PatrolTotal',
          'PatroliTotal',
          'JumlahPatroli',
          'TotalLocation',
        ],
      ) ??
      _intFromKeys(
        [
          'Total',
          'Jumlah',
        ],
        source: _patrol,
      );

  bool get isPatrolCompleted {
    final completed = patrolCompleted;
    final total = patrolTotal;
    if (completed != null && total != null && total > 0) {
      return completed >= total;
    }
    final status = patrolStatusLabel?.toLowerCase();
    return status != null && status.contains('selesai');
  }

  String? get patrolDescription =>
      _stringFromKeys(['PatrolDescription', 'PatroliDescription'], source: raw) ??
      _stringFromKeys(['Description', 'Detail'], source: _patrol) ??
      _buildProgressDescription(
        completed: patrolCompleted,
        total: patrolTotal,
        unit: 'Tempat telah diperiksa',
      );

  // Follow-up summary
  String? get followUpStatusLabel => _stringFromKeys(
        [
          'FollowUpStatus',
          'TugasLanjutanStatus',
          'StatusTugasLanjutan',
        ],
      ) ??
      _stringFromKeys(
        [
          'Status',
          'Label',
        ],
        source: _followUp,
      );

  int? get followUpCompleted {
    // Hitung dari ListCarryOver: item yang statusnya bukan "OPEN" (sudah selesai)
    final carryOverStats = _getCarryOverStats();
    if (carryOverStats != null) {
      return carryOverStats['completed'];
    }
    
    // Fallback ke field lainnya
    return _intFromKeys(
      [
        'FollowUpCompleted',
        'TugasLanjutanCompleted',
        'JumlahTugasSelesai',
      ],
    ) ??
    _intFromKeys(
      [
        'Completed',
        'Done',
        'Selesai',
      ],
      source: _followUp,
    );
  }

  int? get followUpTotal {
    // Hitung dari ListCarryOver: total jumlah item
    final carryOverStats = _getCarryOverStats();
    if (carryOverStats != null) {
      return carryOverStats['total'];
    }
    
    // Fallback ke field lainnya
    return _intFromKeys(
      [
        'FollowUpTotal',
        'TugasLanjutanTotal',
        'JumlahTugas',
      ],
    ) ??
    _intFromKeys(
      [
        'Total',
        'Jumlah',
      ],
      source: _followUp,
    );
  }

  /// Get statistik dari ListCarryOver: total dan completed
  Map<String, int>? _getCarryOverStats() {
    final listCarryOver = raw['ListCarryOver'];
    if (listCarryOver == null || listCarryOver is! List) {
      return null;
    }

    int total = 0;
    int completed = 0;

    for (final item in listCarryOver) {
      if (item is! Map<String, dynamic>) continue;
      
      total++;
      final status = _asString(item['Status'])?.toUpperCase();
      // Item yang statusnya bukan "OPEN" dianggap sudah selesai
      if (status != null && status != 'OPEN') {
        completed++;
      }
    }

    if (total == 0) {
      return null;
    }

    return {
      'total': total,
      'completed': completed,
    };
  }

  bool get isFollowUpCompleted {
    final completed = followUpCompleted;
    final total = followUpTotal;
    if (completed != null && total != null && total > 0) {
      return completed >= total;
    }
    final status = followUpStatusLabel?.toLowerCase();
    return status != null && status.contains('selesai');
  }

  String? get followUpDescription {
    // Cek apakah ada ListCarryOver untuk format khusus
    final carryOverStats = _getCarryOverStats();
    if (carryOverStats != null) {
      final total = carryOverStats['total']!;
      final completed = carryOverStats['completed']!;
      final open = total - completed; // Jumlah tugas yang masih OPEN
      
      // Format: "open/completed selesai dikerjakan"
      // Contoh: "1/0 selesai dikerjakan" berarti 1 tugas OPEN, 0 tugas selesai
      return '$open/$completed selesai dikerjakan';
    }
    
    // Fallback ke field lainnya
    return _stringFromKeys(
      ['FollowUpDescription', 'TugasLanjutanDescription'],
      source: raw,
    ) ??
    _stringFromKeys(
      [
        'Description',
        'Detail',
      ],
      source: _followUp,
    ) ??
    _buildProgressDescription(
      completed: followUpCompleted,
      total: followUpTotal,
      unit: 'Selesai dikerjakan',
    );
  }

  String? _buildProgressDescription({
    int? completed,
    int? total,
    required String unit,
  }) {
    if (completed == null || total == null || total == 0) return null;
    return '$completed/$total $unit';
  }
}

