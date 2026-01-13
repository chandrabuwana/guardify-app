import 'package:equatable/equatable.dart';
import '../../domain/entities/document_entity.dart';

/// Abstract base class untuk semua document states
abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

/// Initial state saat pertama kali BLoC dibuat
class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

/// State ketika sedang loading data
class DocumentLoading extends DocumentState {
  const DocumentLoading();
}

/// State ketika dokumen berhasil dimuat
class DocumentLoaded extends DocumentState {
  final List<DocumentEntity> documents;
  final List<DocumentEntity> filteredDocuments;
  final List<String> categories;
  final String? currentQuery;
  final String? currentNameFilter;
  final String? currentCodeFilter;
  final String? currentCategoryFilter;
  final DateTime? currentStartDate;
  final DateTime? currentEndDate;
  final bool isSearchMode;
  final bool isFilterMode;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int currentPage;

  final String sortField;
  final int sortType;

  const DocumentLoaded({
    required this.documents,
    required this.filteredDocuments,
    this.categories = const [],
    this.currentQuery,
    this.currentNameFilter,
    this.currentCodeFilter,
    this.currentCategoryFilter,
    this.currentStartDate,
    this.currentEndDate,
    this.isSearchMode = false,
    this.isFilterMode = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.sortField = 'CreateDate',
    this.sortType = 1,
  });

  @override
  List<Object?> get props => [
        documents,
        filteredDocuments,
        categories,
        currentQuery,
        currentNameFilter,
        currentCodeFilter,
        currentCategoryFilter,
        currentStartDate,
        currentEndDate,
        isSearchMode,
        isFilterMode,
        isLoadingMore,
        hasReachedMax,
        currentPage,
        sortField,
        sortType,
      ];

  /// Copy with method untuk membuat state baru dengan perubahan tertentu
  DocumentLoaded copyWith({
    List<DocumentEntity>? documents,
    List<DocumentEntity>? filteredDocuments,
    List<String>? categories,
    String? currentQuery,
    String? currentNameFilter,
    String? currentCodeFilter,
    String? currentCategoryFilter,
    DateTime? currentStartDate,
    DateTime? currentEndDate,
    bool? isSearchMode,
    bool? isFilterMode,
    bool? isLoadingMore,
    bool? hasReachedMax,
    int? currentPage,
    String? sortField,
    int? sortType,
  }) {
    return DocumentLoaded(
      documents: documents ?? this.documents,
      filteredDocuments: filteredDocuments ?? this.filteredDocuments,
      categories: categories ?? this.categories,
      currentQuery: currentQuery ?? this.currentQuery,
      currentNameFilter: currentNameFilter ?? this.currentNameFilter,
      currentCodeFilter: currentCodeFilter ?? this.currentCodeFilter,
      currentCategoryFilter:
          currentCategoryFilter ?? this.currentCategoryFilter,
      currentStartDate: currentStartDate ?? this.currentStartDate,
      currentEndDate: currentEndDate ?? this.currentEndDate,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      isFilterMode: isFilterMode ?? this.isFilterMode,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      sortField: sortField ?? this.sortField,
      sortType: sortType ?? this.sortType,
    );
  }

  /// Copy with method untuk clear search/filter
  DocumentLoaded clearSearch() {
    return DocumentLoaded(
      documents: documents,
      filteredDocuments: documents,
      categories: categories,
      currentQuery: null,
      currentNameFilter: currentNameFilter,
      currentCodeFilter: currentCodeFilter,
      currentCategoryFilter: currentCategoryFilter,
      currentStartDate: currentStartDate,
      currentEndDate: currentEndDate,
      isSearchMode: false,
      isFilterMode: isFilterMode,
      isLoadingMore: false,
      hasReachedMax: false,
      currentPage: 0,
      sortField: sortField,
      sortType: sortType,
    );
  }

  DocumentLoaded clearFilter() {
    return DocumentLoaded(
      documents: documents,
      filteredDocuments: documents,
      categories: categories,
      currentQuery: currentQuery,
      currentNameFilter: null,
      currentCodeFilter: null,
      currentCategoryFilter: null,
      currentStartDate: null,
      currentEndDate: null,
      isSearchMode: isSearchMode,
      isFilterMode: false,
      isLoadingMore: false,
      hasReachedMax: false,
      currentPage: 0,
      sortField: sortField,
      sortType: sortType,
    );
  }
}

/// State ketika terjadi error
class DocumentError extends DocumentState {
  final String message;
  final String? errorCode;

  const DocumentError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

/// State ketika sedang loading detail dokumen
class DocumentDetailLoading extends DocumentState {
  const DocumentDetailLoading();
}

/// State ketika detail dokumen berhasil dimuat
class DocumentDetailLoaded extends DocumentState {
  final DocumentEntity document;

  const DocumentDetailLoaded(this.document);

  @override
  List<Object?> get props => [document];
}

/// State ketika terjadi error saat load detail dokumen
class DocumentDetailError extends DocumentState {
  final String message;

  const DocumentDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State ketika sedang proses download
class DocumentDownloadLoading extends DocumentState {
  final String documentId;

  const DocumentDownloadLoading(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// State ketika download berhasil
class DocumentDownloadSuccess extends DocumentState {
  final String documentId;
  final String downloadPath;

  const DocumentDownloadSuccess({
    required this.documentId,
    required this.downloadPath,
  });

  @override
  List<Object?> get props => [documentId, downloadPath];
}

/// State ketika download gagal
class DocumentDownloadError extends DocumentState {
  final String documentId;
  final String message;

  const DocumentDownloadError({
    required this.documentId,
    required this.message,
  });

  @override
  List<Object?> get props => [documentId, message];
}

/// State untuk downloaded documents
class DownloadedDocumentsLoaded extends DocumentState {
  final List<DocumentEntity> downloadedDocuments;

  const DownloadedDocumentsLoaded(this.downloadedDocuments);

  @override
  List<Object?> get props => [downloadedDocuments];
}

/// State untuk show snackbar
class DocumentSnackbarShow extends DocumentState {
  final String message;
  final bool isError;

  const DocumentSnackbarShow({
    required this.message,
    this.isError = false,
  });

  @override
  List<Object?> get props => [message, isError];
}
