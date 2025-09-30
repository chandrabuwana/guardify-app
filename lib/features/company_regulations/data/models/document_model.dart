import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/document_entity.dart';

part 'document_model.g.dart';

/// Model data untuk dokumen perusahaan
///
/// Model ini berfungsi sebagai layer data yang dapat diserialize/deserialize
/// dari/ke JSON untuk komunikasi dengan API dan local storage.
@JsonSerializable()
class DocumentModel extends DocumentEntity {
  const DocumentModel({
    required super.id,
    required super.title,
    required super.category,
    required super.date,
    required super.fileUrl,
    super.description,
    super.fileSize,
    super.fileType,
    super.version,
    super.author,
    super.isDownloaded = false,
    super.downloadPath,
    super.tags = const [],
  });

  /// Factory constructor untuk membuat instance dari JSON
  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  /// Method untuk convert instance ke JSON
  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);

  /// Factory constructor untuk membuat model dari entity
  factory DocumentModel.fromEntity(DocumentEntity entity) {
    return DocumentModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      date: entity.date,
      fileUrl: entity.fileUrl,
      description: entity.description,
      fileSize: entity.fileSize,
      fileType: entity.fileType,
      version: entity.version,
      author: entity.author,
      isDownloaded: entity.isDownloaded,
      downloadPath: entity.downloadPath,
      tags: entity.tags,
    );
  }

  /// Method untuk convert model ke entity
  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      title: title,
      category: category,
      date: date,
      fileUrl: fileUrl,
      description: description,
      fileSize: fileSize,
      fileType: fileType,
      version: version,
      author: author,
      isDownloaded: isDownloaded,
      downloadPath: downloadPath,
      tags: tags,
    );
  }

  /// Copy with method untuk membuat instance baru dengan perubahan tertentu
  @override
  DocumentModel copyWith({
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
    return DocumentModel(
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

  /// Factory method untuk membuat dummy data untuk testing
  factory DocumentModel.dummy({
    String? id,
    String? title,
    String? category,
    DateTime? date,
  }) {
    return DocumentModel(
      id: id ?? '1',
      title: title ?? 'SOP Patroli',
      category: category ?? 'SOP',
      date: date ?? DateTime(2025, 10, 29),
      fileUrl: 'https://example.com/documents/sop-patroli.pdf',
      description:
          'Standard Operating Procedure untuk kegiatan patroli keamanan',
      fileSize: 1024 * 256, // 256KB
      fileType: 'PDF',
      version: '1.0',
      author: 'Tim Keamanan',
      tags: ['SOP', 'Patroli', 'Keamanan'],
    );
  }
}
