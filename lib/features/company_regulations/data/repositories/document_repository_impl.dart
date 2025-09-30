import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_local_datasource.dart';
import '../datasources/document_remote_datasource.dart';
import '../models/document_model.dart';

/// Implementasi repository untuk mengelola data dokumen
///
/// Repository ini mengikuti pattern clean architecture dengan
/// menggabungkan data dari remote dan local data sources.
@LazySingleton(as: DocumentRepository)
class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource remoteDataSource;
  final DocumentLocalDataSource localDataSource;

  DocumentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<DocumentEntity>>> getAllDocuments() async {
    try {
      // Coba ambil dari remote terlebih dahulu
      try {
        final remoteDocuments = await remoteDataSource.getAllDocuments();
        final entities =
            remoteDocuments.map((model) => model.toEntity()).toList();

        // Cache data ke local storage
        await localDataSource.cacheDocuments(remoteDocuments);

        return Right(entities);
      } catch (e) {
        // Jika remote gagal, coba ambil dari cache
        final cachedDocuments = await localDataSource.getCachedDocuments();
        if (cachedDocuments.isNotEmpty) {
          final entities =
              cachedDocuments.map((model) => model.toEntity()).toList();
          return Right(entities);
        }

        // Jika cache juga kosong, buat dummy data untuk development
        await localDataSource.createDummyData();
        final dummyDocuments = await localDataSource.getCachedDocuments();
        final entities =
            dummyDocuments.map((model) => model.toEntity()).toList();
        return Right(entities);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to get documents: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DocumentEntity>>> searchDocuments(
      String query) async {
    try {
      // Coba search dari remote terlebih dahulu
      try {
        final remoteDocuments = await remoteDataSource.searchDocuments(query);
        final entities =
            remoteDocuments.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        // Jika remote gagal, search dari cache lokal
        final cachedDocuments = await localDataSource.getCachedDocuments();
        final filteredDocuments = cachedDocuments.where((doc) {
          final lowerQuery = query.toLowerCase();
          return doc.title.toLowerCase().contains(lowerQuery) ||
              doc.category.toLowerCase().contains(lowerQuery) ||
              doc.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
              (doc.description?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();

        final entities =
            filteredDocuments.map((model) => model.toEntity()).toList();
        return Right(entities);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to search documents: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DocumentEntity>>> filterDocumentsByCategory(
    String category,
  ) async {
    try {
      // Coba filter dari remote terlebih dahulu
      try {
        final remoteDocuments =
            await remoteDataSource.filterDocumentsByCategory(category);
        final entities =
            remoteDocuments.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        // Jika remote gagal, filter dari cache lokal
        final cachedDocuments = await localDataSource.getCachedDocuments();
        final filteredDocuments = cachedDocuments.where((doc) {
          return doc.category.toLowerCase() == category.toLowerCase();
        }).toList();

        final entities =
            filteredDocuments.map((model) => model.toEntity()).toList();
        return Right(entities);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to filter documents by category: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DocumentEntity>>> filterDocumentsByDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Coba filter dari remote terlebih dahulu
      try {
        final remoteDocuments = await remoteDataSource.filterDocumentsByDate(
          startDate,
          endDate,
        );
        final entities =
            remoteDocuments.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        // Jika remote gagal, filter dari cache lokal
        final cachedDocuments = await localDataSource.getCachedDocuments();
        final filteredDocuments = cachedDocuments.where((doc) {
          return doc.date
                  .isAfter(startDate.subtract(const Duration(days: 1))) &&
              doc.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();

        final entities =
            filteredDocuments.map((model) => model.toEntity()).toList();
        return Right(entities);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to filter documents by date: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadDocument(
      DocumentEntity document) async {
    try {
      final documentModel = DocumentModel.fromEntity(document);

      // Download file dari remote
      final downloadPath =
          await remoteDataSource.downloadDocument(documentModel);

      // Update model dengan path download dan status
      final updatedModel = documentModel.copyWith(
        downloadPath: downloadPath,
        isDownloaded: true,
      );

      // Simpan ke local storage
      await localDataSource.saveDownloadedDocument(updatedModel);

      return Right(downloadPath);
    } catch (e) {
      return Left(ServerFailure('Failed to download document: $e'));
    }
  }

  @override
  Future<Either<Failure, DocumentEntity>> getDocumentById(
      String documentId) async {
    try {
      // Coba ambil dari cache lokal terlebih dahulu
      final cachedDocument =
          await localDataSource.getCachedDocumentById(documentId);
      if (cachedDocument != null) {
        return Right(cachedDocument.toEntity());
      }

      // Jika tidak ada di cache, ambil dari remote
      final remoteDocument = await remoteDataSource.getDocumentById(documentId);
      return Right(remoteDocument.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to get document by ID: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getDocumentCategories() async {
    try {
      // Coba ambil dari remote terlebih dahulu
      try {
        final remoteCategories = await remoteDataSource.getDocumentCategories();

        // Cache categories ke local storage
        await localDataSource.cacheCategories(remoteCategories);

        return Right(remoteCategories);
      } catch (e) {
        // Jika remote gagal, ambil dari cache
        final cachedCategories = await localDataSource.getCachedCategories();
        if (cachedCategories.isNotEmpty) {
          return Right(cachedCategories);
        }

        // Default categories jika cache kosong
        const defaultCategories = ['SOP', 'Kebijakan', 'Prosedur', 'Panduan'];
        await localDataSource.cacheCategories(defaultCategories);
        return const Right(defaultCategories);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to get document categories: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markDocumentAsRead(String documentId) async {
    try {
      await remoteDataSource.markDocumentAsRead(documentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to mark document as read: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DocumentEntity>>> getDownloadedDocuments() async {
    try {
      final downloadedModels = await localDataSource.getDownloadedDocuments();
      final entities =
          downloadedModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to get downloaded documents: $e'));
    }
  }
}
