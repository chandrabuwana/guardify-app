/// Request entity untuk update attendance
class AttendanceUpdateRequest {
  final String idAttendance;
  final String? photoAbsenPath; // Path to photo file
  final String? photoPengamananPath; // Path to photo file
  final String? photoPakaianPath; // Path to pakaian photo file (PhotoCheckoutPengamanan)
  final String? laporan;
  final bool? isOvertime;
  final String? photoOvertimePath; // Path to overtime photo file

  const AttendanceUpdateRequest({
    required this.idAttendance,
    this.photoAbsenPath,
    this.photoPengamananPath,
    this.photoPakaianPath,
    this.laporan,
    this.isOvertime,
    this.photoOvertimePath,
  });
}

