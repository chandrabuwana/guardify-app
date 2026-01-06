import 'package:equatable/equatable.dart';
import '../../domain/entities/panic_alert.dart';
import '../../domain/entities/panic_button_history_item.dart';

enum PanicButtonStateStatus {
  initial,
  loading,
  loaded,
  activated,
  error,
  showDialog,
}

class PanicButtonState extends Equatable {
  final PanicButtonStateStatus status;
  final List<String> verificationItems;
  final List<bool> verificationStates;
  final PanicAlert? panicAlert;
  final String? errorMessage;
  final bool showPanicDialog;

  // History state
  final List<PanicButtonHistoryItem> historyItems;
  final bool isLoadingHistory;
  final bool isLoadingMoreHistory;
  final bool hasReachedMaxHistory;
  final int currentPageHistory;
  final int totalCountHistory;
  final int filteredCountHistory;
  final String? historyErrorMessage;
  final String? searchQuery;

  final List<String> historyFilterStatuses;
  final DateTime? historyFilterCreateDate;
  final String historySortField;
  final int historySortType; // 0 = ascending, 1 = descending

  // Detail state
  final PanicButtonHistoryItem? detailItem;
  final bool isLoadingDetail;
  final String? detailErrorMessage;
  final bool isSubmittingVerification;
  final bool submitVerificationSuccess;
  final String? submitVerificationError;

  const PanicButtonState({
    this.status = PanicButtonStateStatus.initial,
    this.verificationItems = const [],
    this.verificationStates = const [],
    this.panicAlert,
    this.errorMessage,
    this.showPanicDialog = false,
    this.historyItems = const [],
    this.isLoadingHistory = false,
    this.isLoadingMoreHistory = false,
    this.hasReachedMaxHistory = false,
    this.currentPageHistory = 0,
    this.totalCountHistory = 0,
    this.filteredCountHistory = 0,
    this.historyErrorMessage,
    this.searchQuery,
    this.historyFilterStatuses = const [],
    this.historyFilterCreateDate,
    this.historySortField = 'createDate',
    this.historySortType = 0,
    this.detailItem,
    this.isLoadingDetail = false,
    this.detailErrorMessage,
    this.isSubmittingVerification = false,
    this.submitVerificationSuccess = false,
    this.submitVerificationError,
  });

  bool get allVerified =>
      verificationStates.isNotEmpty &&
      verificationStates.every((verified) => verified);

  PanicButtonState copyWith({
    PanicButtonStateStatus? status,
    List<String>? verificationItems,
    List<bool>? verificationStates,
    PanicAlert? panicAlert,
    String? errorMessage,
    bool? showPanicDialog,
    List<PanicButtonHistoryItem>? historyItems,
    bool? isLoadingHistory,
    bool? isLoadingMoreHistory,
    bool? hasReachedMaxHistory,
    int? currentPageHistory,
    int? totalCountHistory,
    int? filteredCountHistory,
    String? historyErrorMessage,
    String? searchQuery,
    List<String>? historyFilterStatuses,
    DateTime? historyFilterCreateDate,
    String? historySortField,
    int? historySortType,
    PanicButtonHistoryItem? detailItem,
    bool? isLoadingDetail,
    String? detailErrorMessage,
    bool? isSubmittingVerification,
    bool? submitVerificationSuccess,
    String? submitVerificationError,
  }) {
    return PanicButtonState(
      status: status ?? this.status,
      verificationItems: verificationItems ?? this.verificationItems,
      verificationStates: verificationStates ?? this.verificationStates,
      panicAlert: panicAlert ?? this.panicAlert,
      errorMessage: errorMessage ?? this.errorMessage,
      showPanicDialog: showPanicDialog ?? this.showPanicDialog,
      historyItems: historyItems ?? this.historyItems,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isLoadingMoreHistory: isLoadingMoreHistory ?? this.isLoadingMoreHistory,
      hasReachedMaxHistory: hasReachedMaxHistory ?? this.hasReachedMaxHistory,
      currentPageHistory: currentPageHistory ?? this.currentPageHistory,
      totalCountHistory: totalCountHistory ?? this.totalCountHistory,
      filteredCountHistory: filteredCountHistory ?? this.filteredCountHistory,
      historyErrorMessage: historyErrorMessage ?? this.historyErrorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      historyFilterStatuses: historyFilterStatuses ?? this.historyFilterStatuses,
      historyFilterCreateDate: historyFilterCreateDate ?? this.historyFilterCreateDate,
      historySortField: historySortField ?? this.historySortField,
      historySortType: historySortType ?? this.historySortType,
      detailItem: detailItem ?? this.detailItem,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      detailErrorMessage: detailErrorMessage ?? this.detailErrorMessage,
      isSubmittingVerification: isSubmittingVerification ?? this.isSubmittingVerification,
      submitVerificationSuccess: submitVerificationSuccess ?? this.submitVerificationSuccess,
      submitVerificationError: submitVerificationError ?? this.submitVerificationError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        verificationItems,
        verificationStates,
        panicAlert,
        errorMessage,
        showPanicDialog,
        historyItems,
        isLoadingHistory,
        isLoadingMoreHistory,
        hasReachedMaxHistory,
        currentPageHistory,
        totalCountHistory,
        filteredCountHistory,
        historyErrorMessage,
        searchQuery,
        historyFilterStatuses,
        historyFilterCreateDate,
        historySortField,
        historySortType,
        detailItem,
        isLoadingDetail,
        detailErrorMessage,
        isSubmittingVerification,
        submitVerificationSuccess,
        submitVerificationError,
      ];
}
