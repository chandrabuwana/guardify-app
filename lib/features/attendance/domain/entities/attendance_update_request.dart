/// Request entity untuk update attendance
class AttendanceUpdateRequest {
  final String idAttendance;
  final String? photoAbsenPath; // Path to photo file
  final String? photoAbsenFilename;
  final String? photoPengamananPath; // Path to photo file
  final String? photoPengamananFilename;
  final String? photoPakaianPath; // Path to pakaian photo file (PhotoCheckoutPengamanan)
  final String? photoPakaianFilename;
  final String? photoPengamananCheckOutPath;
  final String? photoPengamananCheckOutFilename;
  final String? laporan;
  final String? laporanCheckout;
  final bool? isOvertime;
  final String? photoOvertimePath; // Path to overtime photo file
  final String? photoOvertimeFilename;

  const AttendanceUpdateRequest({
    required this.idAttendance,
    this.photoAbsenPath,
    this.photoAbsenFilename,
    this.photoPengamananPath,
    this.photoPengamananFilename,
    this.photoPakaianPath,
    this.photoPakaianFilename,
    this.photoPengamananCheckOutPath,
    this.photoPengamananCheckOutFilename,
    this.laporan,
    this.laporanCheckout,
    this.isOvertime,
    this.photoOvertimePath,
    this.photoOvertimeFilename,
  });
}

