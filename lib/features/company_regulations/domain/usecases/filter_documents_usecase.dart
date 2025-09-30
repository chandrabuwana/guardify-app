import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

/// Use case untuk memfilter dokumen berdasarkan berbagai kriteria
///
/// Use case ini menyediakan berbagai opsi filtering untuk dokumen
/// seperti kategori, tanggal, atau kombinasi keduanya.
@injectable
class FilterDocumentsUseCase {
  final DocumentRepository repository;

  FilterDocumentsUseCase(this.repository);

  /// Filter dokumen berdasarkan kategori
  ///
  /// Parameters:
  /// - [category]: Kategori dokumen untuk filter
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat filter
  /// - Right(List<DocumentEntity>): List dokumen hasil filter
  Future<Either<Failure, List<DocumentEntity>>> filterByCategory(
    String category,
  ) async {
    if (category.trim().isEmpty) {
      return const Left(ValidationFailure('Kategori tidak boleh kosong'));
    }

    return await repository.filterDocumentsByCategory(category.trim());
  }

  /// Filter dokumen berdasarkan rentang tanggal
  ///
  /// Parameters:
  /// - [startDate]: Tanggal mulai filter
  /// - [endDate]: Tanggal akhir filter
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat filter
  /// - Right(List<DocumentEntity>): List dokumen dalam rentang tanggal
  Future<Either<Failure, List<DocumentEntity>>> filterByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Validasi tanggal
    if (startDate.isAfter(endDate)) {
      return const Left(ValidationFailure(
        'Tanggal mulai tidak boleh lebih besar dari tanggal akhir',
      ));
    }

    // Validasi range tidak terlalu jauh (maksimal 2 tahun)
    final difference = endDate.difference(startDate).inDays;
    if (difference > 730) {
      return const Left(ValidationFailure(
        'Rentang tanggal tidak boleh lebih dari 2 tahun',
      ));
    }

    return await repository.filterDocumentsByDate(startDate, endDate);
  }

  /// Filter dokumen berdasarkan kategori dan rentang tanggal
  ///
  /// Parameters:
  /// - [category]: Kategori dokumen untuk filter
  /// - [startDate]: Tanggal mulai filter
  /// - [endDate]: Tanggal akhir filter
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat filter
  /// - Right(List<DocumentEntity>): List dokumen hasil filter kombinasi
  Future<Either<Failure, List<DocumentEntity>>> filterByCategoryAndDate(
    String category,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Validasi kategori
    if (category.trim().isEmpty) {
      return const Left(ValidationFailure('Kategori tidak boleh kosong'));
    }

    // Validasi tanggal
    if (startDate.isAfter(endDate)) {
      return const Left(ValidationFailure(
        'Tanggal mulai tidak boleh lebih besar dari tanggal akhir',
      ));
    }

    // Filter berdasarkan tanggal terlebih dahulu
    final dateFilterResult = await filterByDateRange(startDate, endDate);

    return dateFilterResult.fold(
      (failure) => Left(failure),
      (documentsInDateRange) async {
        // Filter hasil berdasarkan kategori
        final filteredByCategory = documentsInDateRange
            .where((doc) => doc.category.toLowerCase().contains(
                  category.toLowerCase(),
                ))
            .toList();

        return Right(filteredByCategory);
      },
    );
  }
}
