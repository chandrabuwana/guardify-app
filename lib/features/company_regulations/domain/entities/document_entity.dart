import 'package:equatable/equatable.dart';

/// Entitas untuk merepresentasikan dokumen perusahaan
///
/// Entity ini merepresentasikan dokumen yang terdapat dalam sistem
/// peraturan perusahaan dengan informasi dasar seperti id, judul,
/// kategori, tanggal pembuatan/update, dan URL file dokumen.
class DocumentEntity extends Equatable {
  const DocumentEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.fileUrl,
    this.description,
    this.fileSize,
    this.fileType,
    this.version,
    this.author,
    this.isDownloaded = false,
    this.downloadPath,
    this.tags = const [],
  });

  /// ID unik dokumen
  final String id;

  /// Judul dokumen (contoh: "SOP Patroli")
  final String title;

  /// Kategori dokumen (contoh: "SOP", "Kebijakan", "Prosedur")
  final String category;

  /// Tanggal pembuatan atau update dokumen
  final DateTime date;

  /// URL untuk mengunduh atau mengakses file dokumen
  final String fileUrl;

  /// Deskripsi detail dokumen (opsional)
  final String? description;

  /// Ukuran file dalam bytes (opsional)
  final int? fileSize;

  /// Tipe file (PDF, DOC, etc.) (opsional)
  final String? fileType;

  /// Versi dokumen (opsional)
  final String? version;

  /// Pembuat dokumen (opsional)
  final String? author;

  /// Status apakah dokumen sudah diunduh secara lokal
  final bool isDownloaded;

  /// Path lokal file yang sudah diunduh (opsional)
  final String? downloadPath;

  /// Tag untuk pencarian dan kategorisasi
  final List<String> tags;

  /// Format tanggal untuk ditampilkan di UI
  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Format ukuran file dalam KB, MB, atau GB
  String get formattedFileSize {
    if (fileSize == null) return '';

    if (fileSize! < 1024) {
      return '${fileSize!} B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize! < 1024 * 1024 * 1024) {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Subtitle yang akan ditampilkan di UI (kategori | tanggal)
  String get subtitle => '$category | $formattedDate';

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        date,
        fileUrl,
        description,
        fileSize,
        fileType,
        version,
        author,
        isDownloaded,
        downloadPath,
        tags,
      ];

  /// Copy with method untuk membuat instance baru dengan perubahan tertentu
  DocumentEntity copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? date,
    String? fileUrl,
    String? description,
    int? fileSize,
    String? fileType,
    String? version,
    String? author,
    bool? isDownloaded,
    String? downloadPath,
    List<String>? tags,
  }) {
    return DocumentEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      fileUrl: fileUrl ?? this.fileUrl,
      description: description ?? this.description,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      version: version ?? this.version,
      author: author ?? this.author,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadPath: downloadPath ?? this.downloadPath,
      tags: tags ?? this.tags,
    );
  }
}
