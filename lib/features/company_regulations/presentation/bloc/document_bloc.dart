import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_company_rule_categories_usecase.dart';
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
  final GetCompanyRuleCategoriesUseCase getCompanyRuleCategoriesUseCase;
  final SearchDocumentsUseCase searchDocumentsUseCase;
  final FilterDocumentsUseCase filterDocumentsUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;

  static const int pageSize = 10;

  DocumentBloc({
    required this.getDocumentsUseCase,
    required this.getCompanyRuleCategoriesUseCase,
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
    on<ApplyCompanyRuleFilterEvent>(_onApplyCompanyRuleFilter);
    on<LoadCompanyRuleCategoriesEvent>(_onLoadCompanyRuleCategories);
    on<DownloadDocumentEvent>(_onDownloadDocument);
    on<ShowSnackbarEvent>(_onShowSnackbar);
  }

  Future<void> _onLoadCompanyRuleCategories(
    LoadCompanyRuleCategoriesEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DocumentLoaded) return;

    if (currentState.companyRuleCategories.isNotEmpty) return;

    final result = await getCompanyRuleCategoriesUseCase.call();
    result.fold(
      (_) {},
      (categories) {
        emit(currentState.copyWith(companyRuleCategories: categories));
      },
    );
  }

  /// Handler untuk load documents event
  Future<void> _onLoadDocuments(
    LoadDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentLoading());

    final result = await getDocumentsUseCase.call(
      start: 0,
      length: pageSize,
      sortField: 'CreateDate',
      sortType: 1,
    );

    result.fold(
      (failure) => emit(DocumentError(message: failure.message)),
      (documents) => emit(DocumentLoaded(
        documents: documents,
        filteredDocuments: documents,
        categories: _extractCategories(documents),
        hasReachedMax: documents.length < pageSize,
        currentPage: 0,
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

    final filters = <String, String>{};
    var sortField = 'CreateDate';
    var sortType = 1;
    if (currentState is DocumentLoaded) {
      if (currentState.currentNameFilter != null &&
          currentState.currentNameFilter!.trim().isNotEmpty) {
        filters['Name'] = currentState.currentNameFilter!.trim();
      }
      if (currentState.currentCodeFilter != null &&
          currentState.currentCodeFilter!.trim().isNotEmpty) {
        filters['Code'] = currentState.currentCodeFilter!.trim();
      }
      sortField = currentState.sortField;
      sortType = currentState.sortType;
    }

    final result = await getDocumentsUseCase.call(
      start: 0,
      length: pageSize,
      sortField: sortField,
      sortType: sortType,
      filters: filters.isEmpty ? null : filters,
    );

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
            isLoadingMore: false,
            hasReachedMax: documents.length < pageSize,
            currentPage: 0,
          ));
        } else {
          emit(DocumentLoaded(
            documents: documents,
            filteredDocuments: documents,
            categories: _extractCategories(documents),
            hasReachedMax: documents.length < pageSize,
            currentPage: 0,
          ));
        }
      },
    );
  }

  Future<void> _onApplyCompanyRuleFilter(
    ApplyCompanyRuleFilterEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is DocumentLoaded) {
      emit(currentState.copyWith(
        isFilterMode: true,
        isLoadingMore: false,
        hasReachedMax: false,
        currentPage: 0,
      ));
    } else {
      emit(const DocumentLoading());
    }

    final filters = <String, String>{};
    final name = event.name?.trim() ?? '';
    final code = event.code?.trim() ?? '';
    if (name.isNotEmpty) filters['Name'] = name;
    if (code.isNotEmpty) filters['Code'] = code;
    if (event.idCompanyCategory != null) {
      filters['IdCompanyRuleCategory'] = event.idCompanyCategory.toString();
    }

    final result = await getDocumentsUseCase.call(
      start: 0,
      length: pageSize,
      filters: filters.isEmpty ? null : filters,
      sortField: event.sortField,
      sortType: event.sortType,
    );

    result.fold(
      (failure) => emit(DocumentError(message: failure.message)),
      (documents) => emit(DocumentLoaded(
        documents: documents,
        filteredDocuments: documents,
        categories: _extractCategories(documents),
        companyRuleCategories:
            currentState is DocumentLoaded ? currentState.companyRuleCategories : const [],
        currentNameFilter: filters['Name'],
        currentCodeFilter: filters['Code'],
        currentIdCompanyCategory: event.idCompanyCategory,
        isFilterMode: filters.isNotEmpty,
        sortField: event.sortField,
        sortType: event.sortType,
        hasReachedMax: documents.length < pageSize,
        currentPage: 0,
      )),
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

    emit(currentState.copyWith(
      isFilterMode: false,
      currentNameFilter: null,
      currentCodeFilter: null,
      currentPage: 0,
      hasReachedMax: false,
      isLoadingMore: false,
    ));

    final result = await getDocumentsUseCase.call(
      start: 0,
      length: pageSize,
      sortField: currentState.sortField,
      sortType: currentState.sortType,
    );

    result.fold(
      (failure) => emit(DocumentError(message: failure.message)),
      (documents) => emit(currentState.copyWith(
        documents: documents,
        filteredDocuments: documents,
        categories: _extractCategories(documents),
        currentPage: 0,
        hasReachedMax: documents.length < pageSize,
      )),
    );
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
