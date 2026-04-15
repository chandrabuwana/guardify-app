import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

/// Use case untuk mencari dokumen berdasarkan keyword
///
/// Use case ini memungkinkan pencarian dokumen berdasarkan judul,
/// kategori, atau tag dengan menggunakan keyword yang diberikan.
@injectable
class SearchDocumentsUseCase {
  final DocumentRepository repository;

  SearchDocumentsUseCase(this.repository);

  /// Mencari dokumen berdasarkan keyword
  ///
  /// Parameters:
  /// - [query]: Kata kunci untuk pencarian
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat pencarian
  /// - Right(List<DocumentEntity>): List dokumen hasil pencarian
  Future<Either<Failure, List<DocumentEntity>>> call(String query) async {
    // Validasi input
    if (query.trim().isEmpty) {
      return const Left(
          ValidationFailure('Kata kunci pencarian tidak boleh kosong'));
    }

    // Jika query terlalu pendek, kembalikan semua dokumen
    if (query.trim().length < 2) {
      return await repository.getAllDocuments();
    }

    return await repository.searchDocuments(query.trim());
  }
}
