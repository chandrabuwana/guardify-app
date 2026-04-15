import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../domain/repositories/panic_button_repository.dart';
import '../../domain/usecases/activate_panic_button_usecase.dart';
import '../../domain/usecases/get_verification_items_usecase.dart';
import '../../data/models/panic_button_list_request.dart';
import '../../data/models/panic_button_submit_request.dart';
import 'panic_button_event.dart';
import 'panic_button_state.dart';

@injectable
class PanicButtonBloc extends Bloc<PanicButtonEvent, PanicButtonState> {
  final ActivatePanicButtonUseCase activatePanicButtonUseCase;
  final GetVerificationItemsUseCase getVerificationItemsUseCase;
  final PanicButtonRepository panicButtonRepository;
  static const int pageSize = 10;

  PanicButtonBloc({
    required this.activatePanicButtonUseCase,
    required this.getVerificationItemsUseCase,
    required this.panicButtonRepository,
  }) : super(const PanicButtonState()) {
    on<LoadVerificationItemsEvent>(_onLoadVerificationItems);
    on<UpdateVerificationEvent>(_onUpdateVerification);
    on<ActivatePanicButtonEvent>(_onActivatePanicButton);
    on<ResetVerificationEvent>(_onResetVerification);
    on<ShowPanicDialogEvent>(_onShowPanicDialog);
    
    // History events
    on<LoadPanicButtonHistoryEvent>(_onLoadPanicButtonHistory);
    on<LoadMorePanicButtonHistoryEvent>(_onLoadMorePanicButtonHistory);
    on<SearchPanicButtonHistoryEvent>(_onSearchPanicButtonHistory);
    on<RefreshPanicButtonHistoryEvent>(_onRefreshPanicButtonHistory);
    on<ApplyPanicButtonHistoryFilterEvent>(_onApplyPanicButtonHistoryFilter);
    
    // Detail event
    on<LoadPanicButtonDetailEvent>(_onLoadPanicButtonDetail);
    
    // Verification event
    on<SubmitPanicButtonVerificationEvent>(_onSubmitPanicButtonVerification);
    on<SubmitPanicButtonCompletionEvent>(_onSubmitPanicButtonCompletion);
  }

  Future<void> _onSubmitPanicButtonCompletion(
    SubmitPanicButtonCompletionEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(
      isSubmittingVerification: true,
      submitVerificationError: null,
      submitVerificationSuccess: false,
    ));

    try {
      print('');
      print('🎯 ========================================');
      print('🎯 [PanicButtonBloc] SUBMIT PANIC BUTTON COMPLETION (EDIT)');
      print('🎯 ========================================');
      print('🎯 Event Details:');
      print('  - Id: ${event.id}');
      print('  - Status: ${event.request.status}');

      await panicButtonRepository.editPanicButton(event.id, event.request);

      print('🎯 Completion submitted successfully');
      print('🎯 ========================================');
      print('');

      emit(state.copyWith(
        isSubmittingVerification: false,
        submitVerificationSuccess: true,
        submitVerificationError: null,
      ));
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonBloc] ERROR SUBMITTING COMPLETION');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');

      emit(state.copyWith(
        isSubmittingVerification: false,
        submitVerificationSuccess: false,
        submitVerificationError: 'Gagal menyelesaikan: ${e.toString()}',
      ));
    }
  }

  Future<void> _onApplyPanicButtonHistoryFilter(
    ApplyPanicButtonHistoryFilterEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingHistory: true,
      historyErrorMessage: null,
      hasReachedMaxHistory: false,
      currentPageHistory: 0,
      historyFilterStatuses: event.statuses,
      historyFilterCreateDate: event.createDate,
      historySortField: event.sortField,
      historySortType: event.sortType,
    ));

    try {
      final request = _buildHistoryRequest(
        start: 1,
        length: pageSize,
        searchQuery: state.searchQuery,
        statuses: event.statuses,
        createDate: event.createDate,
        sortField: event.sortField,
        sortType: event.sortType,
      );

      final (items, totalCount, filteredCount) =
          await panicButtonRepository.getPanicButtonHistory(request);

      emit(state.copyWith(
        isLoadingHistory: false,
        historyItems: items,
        totalCountHistory: totalCount,
        filteredCountHistory: filteredCount,
        hasReachedMaxHistory: items.length < pageSize,
        currentPageHistory: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingHistory: false,
        historyErrorMessage: 'Gagal menerapkan filter: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadVerificationItems(
    LoadVerificationItemsEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(status: PanicButtonStateStatus.loading));

    try {
      final items = await getVerificationItemsUseCase();
      emit(state.copyWith(
        status: PanicButtonStateStatus.loaded,
        verificationItems: items,
        verificationStates: List.filled(items.length, false),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PanicButtonStateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateVerification(
    UpdateVerificationEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    final newStates = List<bool>.from(state.verificationStates);
    newStates[event.index] = event.isChecked;

    emit(state.copyWith(verificationStates: newStates));
  }

  Future<void> _onActivatePanicButton(
    ActivatePanicButtonEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(status: PanicButtonStateStatus.loading));

    try {
      final alert = await activatePanicButtonUseCase(event.userId);
      emit(state.copyWith(
        status: PanicButtonStateStatus.activated,
        panicAlert: alert,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PanicButtonStateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetVerification(
    ResetVerificationEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    emit(state.copyWith(
      status: PanicButtonStateStatus.initial,
      verificationStates: List.filled(state.verificationItems.length, false),
      panicAlert: null,
      errorMessage: null,
      showPanicDialog: false,
    ));
  }

  void _onShowPanicDialog(
    ShowPanicDialogEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    emit(state.copyWith(
      showPanicDialog: true,
      status: PanicButtonStateStatus.showDialog,
    ));
  }

  // History handlers
  PanicButtonListRequest _buildHistoryRequest({
    required int start,
    required int length,
    String? searchQuery,
    List<String>? statuses,
    DateTime? createDate,
    String? sortField,
    int? sortType,
  }) {
    final dateFormatter = DateFormat('yyyy-MM-dd');

    var request = PanicButtonListRequest.initial(length: length);

    request = request.withSort(
      field: (sortField != null && sortField.trim().isNotEmpty)
          ? sortField.trim()
          : 'status',
      type: sortType ?? 0,
    );

    request = request.withStatusesFilter(statuses ?? const []);

    if (createDate != null) {
      request = request.withCreateDateFilter('createDate', dateFormatter.format(createDate));
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      request = request.withDescriptionSearch(searchQuery);
    }

    return request.copyWith(start: start);
  }

  Future<void> _onLoadPanicButtonHistory(
    LoadPanicButtonHistoryEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingHistory: true,
      historyErrorMessage: null,
      hasReachedMaxHistory: false,
      currentPageHistory: 0,
    ));

    try {
      final request = _buildHistoryRequest(
        start: event.start,
        length: event.length,
        searchQuery: event.searchQuery ?? state.searchQuery,
        statuses: state.historyFilterStatuses,
        createDate: state.historyFilterCreateDate,
        sortField: state.historySortField,
        sortType: state.historySortType,
      );

      final (items, totalCount, filteredCount) =
          await panicButtonRepository.getPanicButtonHistory(request);

      emit(state.copyWith(
        isLoadingHistory: false,
        historyItems: items,
        totalCountHistory: totalCount,
        filteredCountHistory: filteredCount,
        hasReachedMaxHistory: items.length < event.length,
        currentPageHistory: 0,
        searchQuery: event.searchQuery,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingHistory: false,
        historyErrorMessage: 'Gagal memuat riwayat: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadMorePanicButtonHistory(
    LoadMorePanicButtonHistoryEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    if (state.hasReachedMaxHistory || state.isLoadingMoreHistory) return;

    emit(state.copyWith(isLoadingMoreHistory: true));

    try {
      final nextPage = state.currentPageHistory + 1;
      final start = nextPage + 1;

      final request = _buildHistoryRequest(
        start: start,
        length: pageSize,
        searchQuery: state.searchQuery,
        statuses: state.historyFilterStatuses,
        createDate: state.historyFilterCreateDate,
        sortField: state.historySortField,
        sortType: state.historySortType,
      );

      final (newItems, totalCount, filteredCount) =
          await panicButtonRepository.getPanicButtonHistory(request);

      final hasReachedMax = newItems.length < pageSize;

      emit(state.copyWith(
        isLoadingMoreHistory: false,
        historyItems: [...state.historyItems, ...newItems],
        totalCountHistory: totalCount,
        filteredCountHistory: filteredCount,
        hasReachedMaxHistory: hasReachedMax,
        currentPageHistory: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMoreHistory: false,
        historyErrorMessage: 'Gagal memuat lebih banyak: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSearchPanicButtonHistory(
    SearchPanicButtonHistoryEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingHistory: true,
      historyErrorMessage: null,
      hasReachedMaxHistory: false,
      currentPageHistory: 0,
      searchQuery: event.query,
    ));

    try {
      final request = _buildHistoryRequest(
        start: 1,
        length: pageSize,
        searchQuery: event.query,
        statuses: state.historyFilterStatuses,
        createDate: state.historyFilterCreateDate,
        sortField: state.historySortField,
        sortType: state.historySortType,
      );

      final (items, totalCount, filteredCount) =
          await panicButtonRepository.getPanicButtonHistory(request);

      emit(state.copyWith(
        isLoadingHistory: false,
        historyItems: items,
        totalCountHistory: totalCount,
        filteredCountHistory: filteredCount,
        hasReachedMaxHistory: items.length < pageSize,
        currentPageHistory: 0,
        searchQuery: event.query.isEmpty ? null : event.query,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingHistory: false,
        historyErrorMessage: 'Gagal mencari: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshPanicButtonHistory(
    RefreshPanicButtonHistoryEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingHistory: true,
      historyErrorMessage: null,
      hasReachedMaxHistory: false,
      currentPageHistory: 0,
    ));

    try {
      final request = _buildHistoryRequest(
        start: 1,
        length: pageSize,
        searchQuery: state.searchQuery,
        statuses: state.historyFilterStatuses,
        createDate: state.historyFilterCreateDate,
        sortField: state.historySortField,
        sortType: state.historySortType,
      );

      final (items, totalCount, filteredCount) =
          await panicButtonRepository.getPanicButtonHistory(request);

      emit(state.copyWith(
        isLoadingHistory: false,
        historyItems: items,
        totalCountHistory: totalCount,
        filteredCountHistory: filteredCount,
        hasReachedMaxHistory: items.length < pageSize,
        currentPageHistory: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingHistory: false,
        historyErrorMessage: 'Gagal refresh: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadPanicButtonDetail(
    LoadPanicButtonDetailEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingDetail: true,
      detailErrorMessage: null,
      detailItem: null,
    ));

    try {
      print('');
      print('🎯 ========================================');
      print('🎯 [PanicButtonBloc] LOAD PANIC BUTTON DETAIL');
      print('🎯 ========================================');
      print('🎯 Event Details:');
      print('  - Id: ${event.id}');

      final detailItem = await panicButtonRepository.getPanicButtonDetail(event.id);

      print('🎯 Detail loaded successfully');
      print('  - Item Id: ${detailItem.id}');
      print('  - Status: ${detailItem.status}');
      print('🎯 ========================================');
      print('');

      emit(state.copyWith(
        isLoadingDetail: false,
        detailItem: detailItem,
        detailErrorMessage: null,
      ));
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonBloc] ERROR LOADING DETAIL');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');

      emit(state.copyWith(
        isLoadingDetail: false,
        detailErrorMessage: 'Gagal memuat detail: ${e.toString()}',
        detailItem: null,
      ));
    }
  }

  Future<void> _onSubmitPanicButtonVerification(
    SubmitPanicButtonVerificationEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(
      isSubmittingVerification: true,
      submitVerificationError: null,
      submitVerificationSuccess: false,
    ));

    try {
      print('');
      print('🎯 ========================================');
      print('🎯 [PanicButtonBloc] SUBMIT PANIC BUTTON VERIFICATION');
      print('🎯 ========================================');
      print('🎯 Event Details:');
      print('  - Id: ${event.id}');
      print('  - Status: ${event.status}');
      print('  - Notes: ${event.notes ?? "null"}');

      final request = PanicButtonSubmitRequest(
        id: event.id,
        status: event.status,
        notes: event.notes,
      );

      await panicButtonRepository.submitPanicButtonVerification(request);

      print('🎯 Verification submitted successfully');
      print('🎯 ========================================');
      print('');

      emit(state.copyWith(
        isSubmittingVerification: false,
        submitVerificationSuccess: true,
        submitVerificationError: null,
      ));
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonBloc] ERROR SUBMITTING VERIFICATION');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');

      emit(state.copyWith(
        isSubmittingVerification: false,
        submitVerificationSuccess: false,
        submitVerificationError: 'Gagal verifikasi: ${e.toString()}',
      ));
    }
  }
}
