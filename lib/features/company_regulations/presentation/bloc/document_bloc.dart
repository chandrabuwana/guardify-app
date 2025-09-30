import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/download_document_usecase.dart';
import '../../domain/usecases/filter_documents_usecase.dart';
import '../../domain/usecases/get_documents_usecase.dart';
import '../../domain/usecases/search_documents_usecase.dart';
import '../../domain/entities/document_entity.dart';
import 'document_event.dart';
import 'document_state.dart';

/// BLoC untuk mengelola state dokumen perusahaan
///
/// BLoC ini menangani semua business logic terkait dengan
/// manajemen dokumen seperti load, search, filter, dan download.
@injectable
class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final GetDocumentsUseCase getDocumentsUseCase;
  final SearchDocumentsUseCase searchDocumentsUseCase;
  final FilterDocumentsUseCase filterDocumentsUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;

  DocumentBloc({
    required this.getDocumentsUseCase,
    required this.searchDocumentsUseCase,
    required this.filterDocumentsUseCase,
    required this.downloadDocumentUseCase,
  }) : super(const DocumentInitial()) {
    // Register event handlers
    on<LoadDocumentsEvent>(_onLoadDocuments);
    on<RefreshDocumentsEvent>(_onRefreshDocuments);
    on<SearchDocumentsEvent>(_onSearchDocuments);
    on<ClearSearchEvent>(_onClearSearch);
    on<FilterDocumentsByCategoryEvent>(_onFilterDocumentsByCategory);
    on<FilterDocumentsByDateEvent>(_onFilterDocumentsByDate);
    on<ClearFilterEvent>(_onClearFilter);
    on<DownloadDocumentEvent>(_onDownloadDocument);
    on<ShowSnackbarEvent>(_onShowSnackbar);
  }

  /// Handler untuk load documents event
  Future<void> _onLoadDocuments(
    LoadDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentLoading());

    final result = await getDocumentsUseCase.call();

    result.fold(
      (failure) => emit(DocumentError(message: failure.message)),
      (documents) => emit(DocumentLoaded(
        documents: documents,
        filteredDocuments: documents,
        categories: _extractCategories(documents),
      )),
    );
  }

  /// Handler untuk refresh documents event
  Future<void> _onRefreshDocuments(
    RefreshDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    // Preserve current state while loading
    final currentState = state;
    if (currentState is DocumentLoaded) {
      emit(currentState.copyWith());
    } else {
      emit(const DocumentLoading());
    }

    final result = await getDocumentsUseCase.call();

    result.fold(
      (failure) => emit(DocumentError(message: failure.message)),
      (documents) {
        if (currentState is DocumentLoaded) {
          // Preserve search/filter state
          List<DocumentEntity> filteredDocs = documents;

          // Re-apply current search if any
          if (currentState.isSearchMode && currentState.currentQuery != null) {
            filteredDocs =
                _performLocalSearch(documents, currentState.currentQuery!);
          }

          // Re-apply current filter if any
          if (currentState.isFilterMode) {
            if (currentState.currentCategoryFilter != null) {
              filteredDocs = _performLocalCategoryFilter(
                  filteredDocs, currentState.currentCategoryFilter!);
            }
            if (currentState.currentStartDate != null &&
                currentState.currentEndDate != null) {
              filteredDocs = _performLocalDateFilter(
                filteredDocs,
                currentState.currentStartDate!,
                currentState.currentEndDate!,
              );
            }
          }

          emit(currentState.copyWith(
            documents: documents,
            filteredDocuments: filteredDocs,
            categories: _extractCategories(documents),
          ));
        } else {
          emit(DocumentLoaded(
            documents: documents,
            filteredDocuments: documents,
            categories: _extractCategories(documents),
          ));
        }
      },
    );
  }

  /// Handler untuk search documents event
  Future<void> _onSearchDocuments(
    SearchDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DocumentLoaded) return;

    if (event.query.trim().isEmpty) {
      emit(currentState.clearSearch());
      return;
    }

    // Perform local search on loaded documents
    final filteredDocuments =
        _performLocalSearch(currentState.documents, event.query);

    emit(currentState.copyWith(
      filteredDocuments: filteredDocuments,
      currentQuery: event.query,
      isSearchMode: true,
    ));
  }

  /// Handler untuk clear search event
  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DocumentLoaded) return;

    emit(currentState.clearSearch());
  }

  /// Handler untuk filter by category event
  Future<void> _onFilterDocumentsByCategory(
    FilterDocumentsByCategoryEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DocumentLoaded) return;

    // Start with current filtered documents if in search mode
    List<DocumentEntity> baseDocuments = currentState.isSearchMode
        ? currentState.filteredDocuments
        : currentState.documents;

    final filteredDocuments =
        _performLocalCategoryFilter(baseDocuments, event.category);

    emit(currentState.copyWith(
      filteredDocuments: filteredDocuments,
      currentCategoryFilter: event.category,
      isFilterMode: true,
    ));
  }

  /// Handler untuk filter by date event
  Future<void> _onFilterDocumentsByDate(
    FilterDocumentsByDateEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DocumentLoaded) return;

    // Start with current filtered documents if in search mode
    List<DocumentEntity> baseDocuments = currentState.isSearchMode
        ? currentState.filteredDocuments
        : currentState.documents;

    final filteredDocuments = _performLocalDateFilter(
      baseDocuments,
      event.startDate,
      event.endDate,
    );

    emit(currentState.copyWith(
      filteredDocuments: filteredDocuments,
      currentStartDate: event.startDate,
      currentEndDate: event.endDate,
      isFilterMode: true,
    ));
  }

  /// Handler untuk clear filter event
  Future<void> _onClearFilter(
    ClearFilterEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DocumentLoaded) return;

    emit(currentState.clearFilter());
  }

  /// Handler untuk download document event
  Future<void> _onDownloadDocument(
    DownloadDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentDownloadLoading(event.document.id));

    final result = await downloadDocumentUseCase.call(event.document);

    result.fold(
      (failure) => emit(DocumentDownloadError(
        documentId: event.document.id,
        message: failure.message,
      )),
      (downloadPath) => emit(DocumentDownloadSuccess(
        documentId: event.document.id,
        downloadPath: downloadPath,
      )),
    );
  }

  /// Handler untuk show snackbar event
  Future<void> _onShowSnackbar(
    ShowSnackbarEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentSnackbarShow(
      message: event.message,
      isError: event.isError,
    ));
  }

  /// Helper method untuk extract categories dari list documents
  List<String> _extractCategories(List<DocumentEntity> documents) {
    final categories = documents.map((doc) => doc.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Helper method untuk local search
  List<DocumentEntity> _performLocalSearch(
      List<DocumentEntity> documents, String query) {
    final lowerQuery = query.toLowerCase();
    return documents.where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
          doc.category.toLowerCase().contains(lowerQuery) ||
          doc.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          (doc.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Helper method untuk local category filter
  List<DocumentEntity> _performLocalCategoryFilter(
    List<DocumentEntity> documents,
    String category,
  ) {
    return documents
        .where((doc) => doc.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Helper method untuk local date filter
  List<DocumentEntity> _performLocalDateFilter(
    List<DocumentEntity> documents,
    DateTime startDate,
    DateTime endDate,
  ) {
    return documents.where((doc) {
      return doc.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          doc.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
}
