import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/company_rule_category_entity.dart';
import '../entities/document_entity.dart';

/// Interface repository untuk mengelola data dokumen perusahaan
///
/// Repository ini menggunakan pattern Either dari dartz untuk
/// error handling yang konsisten. Left menandakan error/failure,
/// Right menandakan sukses dengan data.
abstract class DocumentRepository {
  /// Mengambil dokumen dengan pagination
  ///
  /// Parameters:
  /// - [start]: Starting index for pagination (0-based internally)
  /// - [length]: Number of items to fetch
  /// - [filters]: Optional server-side filters (e.g. {'Name': 'abc', 'Code': 'CR0001'})
  /// - [sortField]: Optional server-side sort field (e.g. 'CreateDate')
  /// - [sortType]: Optional server-side sort type (0 = ascending, 1 = descending)
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat mengambil data
  /// - Right(List<DocumentEntity>): List dokumen yang berhasil diambil
  Future<Either<Failure, List<DocumentEntity>>> getDocuments({
    int start = 0,
    int length = 10,
    Map<String, String>? filters,
    String? sortField,
    int? sortType,
  });

  /// Mengambil semua dokumen yang tersedia
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat mengambil data
  /// - Right(List<DocumentEntity>): List dokumen yang berhasil diambil
  Future<Either<Failure, List<DocumentEntity>>> getAllDocuments();

  /// Mencari dokumen berdasarkan keyword
  ///
  /// Parameters:
  /// - [query]: Kata kunci untuk pencarian (title, category, tags)
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat pencarian
  /// - Right(List<DocumentEntity>): List dokumen hasil pencarian
  Future<Either<Failure, List<DocumentEntity>>> searchDocuments(String query);

  /// Filter dokumen berdasarkan kategori
  ///
  /// Parameters:
  /// - [category]: Kategori dokumen untuk filter
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat filter
  /// - Right(List<DocumentEntity>): List dokumen hasil filter
  Future<Either<Failure, List<DocumentEntity>>> filterDocumentsByCategory(
    String category,
  );

  /// Filter dokumen berdasarkan rentang tanggal
  ///
  /// Parameters:
  /// - [startDate]: Tanggal mulai filter
  /// - [endDate]: Tanggal akhir filter
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat filter
  /// - Right(List<DocumentEntity>): List dokumen dalam rentang tanggal
  Future<Either<Failure, List<DocumentEntity>>> filterDocumentsByDate(
    DateTime startDate,
    DateTime endDate,
  );

  /// Mengunduh dokumen ke penyimpanan lokal
  ///
  /// Parameters:
  /// - [document]: Entity dokumen yang akan diunduh
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat download
  /// - Right(String): Path lokal file yang berhasil diunduh
  Future<Either<Failure, String>> downloadDocument(DocumentEntity document);

  /// Mengambil detail dokumen berdasarkan ID
  ///
  /// Parameters:
  /// - [documentId]: ID dokumen yang akan diambil detailnya
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error atau dokumen tidak ditemukan
  /// - Right(DocumentEntity): Detail dokumen
  Future<Either<Failure, DocumentEntity>> getDocumentById(String documentId);

  /// Mengambil semua kategori dokumen yang tersedia
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat mengambil kategori
  /// - Right(List<String>): List kategori yang tersedia
  Future<Either<Failure, List<String>>> getDocumentCategories();

  Future<Either<Failure, List<CompanyRuleCategoryEntity>>>
      getCompanyRuleCategories();

  /// Menandai dokumen sebagai sudah dibaca/dilihat
  ///
  /// Parameters:
  /// - [documentId]: ID dokumen yang telah dibaca
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat update status
  /// - Right(void): Sukses update status
  Future<Either<Failure, void>> markDocumentAsRead(String documentId);

  /// Mengambil dokumen yang sudah diunduh secara lokal
  ///
  /// Returns:
  /// - Left(Failure): Jika terjadi error saat mengambil data lokal
  /// - Right(List<DocumentEntity>): List dokumen yang sudah diunduh
  Future<Either<Failure, List<DocumentEntity>>> getDownloadedDocuments();
}
