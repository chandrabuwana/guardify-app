/// Entity untuk detail rekapitulasi kehadiran
class AttendanceRekapDetailEntity {
  final String idAttendance;
  final String idShift;
  final String fullname;
  final String nrp;
  final String jabatan;
  final String? photoPegawai;
  final String statusLaporan; // CheckIn, CheckOut, etc
  final DateTime shiftDate;
  final String shiftName;
  final String? location;
  final String? route;
  final String? patrol; // Yes, No, null
  final DateTime? checkIn;
  final PhotoInfo? photoPakaian;
  final String? notes;
  final String? notesCheckout;
  final PhotoInfo? photoPengamanan;
  final List<CarryOverItem> listCarryOver;
  final PhotoInfo? photoCheckin;
  final List<RouteItem> listRoute;
  final DateTime? checkOut;
  final String? carryOver;
  final bool isOvertime;
  final String? statusKerja; // Late, On Time, Early, etc
  final PhotoInfo? photoCheckout;
  final PhotoInfo? photoCheckoutPengamanan;
  final PhotoInfo? photoCheckoutPakaian;
  final PhotoInfo? photoOvertime;
  final DateTime? updateDate;
  final String? updateBy;
  final String? feedback;

  const AttendanceRekapDetailEntity({
    required this.idAttendance,
    required this.idShift,
    required this.fullname,
    required this.nrp,
    required this.jabatan,
    this.photoPegawai,
    required this.statusLaporan,
    required this.shiftDate,
    required this.shiftName,
    this.location,
    this.route,
    this.patrol,
    this.checkIn,
    this.photoPakaian,
    this.notes,
    this.notesCheckout,
    this.photoPengamanan,
    required this.listCarryOver,
    this.photoCheckin,
    required this.listRoute,
    this.checkOut,
    this.carryOver,
    required this.isOvertime,
    this.statusKerja,
    this.photoCheckout,
    this.photoCheckoutPengamanan,
    this.photoCheckoutPakaian,
    this.photoOvertime,
    this.updateDate,
    this.updateBy,
    this.feedback,
  });

  /// Check if detail can be opened (must have CheckIn or CheckOut)
  bool get canOpenDetail {
    return checkIn != null || checkOut != null;
  }
}

/// Entity untuk photo info
class PhotoInfo {
  final String? filename;
  final String? url;

  const PhotoInfo({
    this.filename,
    this.url,
  });

  bool get hasPhoto => url != null && url!.isNotEmpty;
}

/// Entity untuk carry over item
class CarryOverItem {
  final String note;
  final String status; // SELESAI, OPEN

  const CarryOverItem({
    required this.note,
    required this.status,
  });

  bool get isCompleted => status.toUpperCase() == 'SELESAI';
}

/// Entity untuk route item
class RouteItem {
  // Add fields based on API response if needed
  const RouteItem();
}

