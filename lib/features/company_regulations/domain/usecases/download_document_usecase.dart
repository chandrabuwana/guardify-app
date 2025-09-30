import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

/// Use case untuk mengunduh dokumen ke penyimpanan lokal
///
/// Use case ini menangani proses download dokumen dari server
/// ke penyimpanan lokal device dengan penanganan error yang tepat.
@injectable
class DownloadDocumentUseCase {
  final DocumentRepository repository;

  DownloadDocumentUseCase(this.repository);

  /// Mengunduh dokumen ke penyimpanan lokal
  ///
  /// Parameters:
  /// - [document]: Entity dokumen yang akan diunduh
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat download
  /// - Right(String): Path lokal file yang berhasil diunduh
  Future<Either<Failure, String>> call(DocumentEntity document) async {
    // Validasi dokumen
    if (document.fileUrl.trim().isEmpty) {
      return const Left(ValidationFailure(
        'URL dokumen tidak valid atau kosong',
      ));
    }

    // Cek apakah dokumen sudah diunduh sebelumnya
    if (document.isDownloaded &&
        document.downloadPath != null &&
        document.downloadPath!.isNotEmpty) {
      return Right(document.downloadPath!);
    }

    // Validasi URL format
    final uri = Uri.tryParse(document.fileUrl);
    if (uri == null || (!uri.hasScheme || !uri.hasAuthority)) {
      return const Left(ValidationFailure(
        'Format URL dokumen tidak valid',
      ));
    }

    return await repository.downloadDocument(document);
  }

  /// Mengunduh dokumen berdasarkan ID
  ///
  /// Parameters:
  /// - [documentId]: ID dokumen yang akan diunduh
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat download atau dokumen tidak ditemukan
  /// - Right(String): Path lokal file yang berhasil diunduh
  Future<Either<Failure, String>> downloadById(String documentId) async {
    if (documentId.trim().isEmpty) {
      return const Left(ValidationFailure('ID dokumen tidak boleh kosong'));
    }

    // Ambil detail dokumen terlebih dahulu
    final documentResult = await repository.getDocumentById(documentId);

    return documentResult.fold(
      (failure) => Left(failure),
      (document) => call(document),
    );
  }

  /// Mengecek status download dokumen
  ///
  /// Parameters:
  /// - [document]: Entity dokumen yang akan dicek
  ///
  /// Returns:
  /// - bool: true jika dokumen sudah diunduh, false jika belum
  bool isDocumentDownloaded(DocumentEntity document) {
    return document.isDownloaded &&
        document.downloadPath != null &&
        document.downloadPath!.isNotEmpty;
  }
}
