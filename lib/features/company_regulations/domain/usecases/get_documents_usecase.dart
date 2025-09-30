import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

/// Use case untuk mengambil semua dokumen perusahaan
///
/// Use case ini bertugas untuk mengambil semua dokumen yang tersedia
/// dalam sistem peraturan perusahaan. Data akan diambil dari repository
/// yang bisa berasal dari API remote atau cache lokal.
@injectable
class GetDocumentsUseCase {
  final DocumentRepository repository;

  GetDocumentsUseCase(this.repository);

  /// Mengambil semua dokumen yang tersedia
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat mengambil data
  /// - Right(List<DocumentEntity>): List dokumen yang berhasil diambil
  Future<Either<Failure, List<DocumentEntity>>> call() async {
    return await repository.getAllDocuments();
  }
}
