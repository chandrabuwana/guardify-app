import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/bmi_record.dart';
import '../../domain/entities/bmi_input.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/search_user_profiles.dart';
import '../../domain/usecases/get_user_profiles_paginated.dart';
import '../../domain/usecases/manage_pinned_profiles.dart';
import '../../domain/usecases/calculate_bmi.dart';
import '../../domain/usecases/get_bmi_history.dart';

part 'bmi_event.dart';
part 'bmi_state.dart';

@injectable
class BMIBloc extends Bloc<BMIEvent, BMIState> {
  final GetUserProfile getUserProfile;
  final SearchUserProfiles searchUserProfiles;
  final GetUserProfilesPaginated getUserProfilesPaginated;
  final ManagePinnedProfiles managePinnedProfiles;
  final CalculateBMI calculateBMI;
  final GetBMIHistory getBMIHistory;

  BMIBloc({
    required this.getUserProfile,
    required this.searchUserProfiles,
    required this.getUserProfilesPaginated,
    required this.managePinnedProfiles,
    required this.calculateBMI,
    required this.getBMIHistory,
  }) : super(BMIState.initial()) {
    on<BMIGetUserProfile>(_onGetUserProfile);
    on<BMISearchUsers>(_onSearchUsers);
    on<BMILoadAllUsers>(_onLoadAllUsers);
    on<BMILoadMoreUsers>(_onLoadMoreUsers);
    on<BMITogglePin>(_onTogglePin);
    on<BMILoadPinnedUsers>(_onLoadPinnedUsers);
    on<BMICalculate>(_onCalculate);
    on<BMILoadHistory>(_onLoadHistory);
    on<BMIDeleteRecord>(_onDeleteRecord);
    on<BMIReset>(_onReset);
    on<BMIClearError>(_onClearError);
  }

  Future<void> _onGetUserProfile(
    BMIGetUserProfile event,
    Emitter<BMIState> emit,
  ) async {
    // Skip jika sudah ada data user yang sama dan tidak ada error
    if (state.currentUserProfile?.id == event.userId && !state.hasError) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final result = await getUserProfile(event.userId);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      )),
      (userProfile) => emit(state.copyWith(
        isLoading: false,
        currentUserProfile: userProfile,
        error: null,
      )),
    );
  }

  Future<void> _onSearchUsers(
    BMISearchUsers event,
    Emitter<BMIState> emit,
  ) async {
    emit(state.copyWith(isSearching: true, error: null));

    final result = await searchUserProfiles(event.query);

    result.fold(
      (failure) => emit(state.copyWith(
        isSearching: false,
        error: _mapFailureToMessage(failure),
      )),
      (userProfiles) => emit(state.copyWith(
        isSearching: false,
        searchResults: userProfiles,
        error: null,
      )),
    );
  }

  Future<void> _onLoadAllUsers(
    BMILoadAllUsers event,
    Emitter<BMIState> emit,
  ) async {
    emit(state.copyWith(
      isSearching: true,
      error: null,
      currentPage: 1,
      searchResults: [],
      hasMoreData: true,
    ));

    final result = await getUserProfilesPaginated(page: 1, pageSize: 10);

    result.fold(
      (failure) => emit(state.copyWith(
        isSearching: false,
        error: _mapFailureToMessage(failure),
      )),
      (paginatedResponse) => emit(state.copyWith(
        isSearching: false,
        searchResults: paginatedResponse.data,
        currentPage: paginatedResponse.currentPage,
        hasMoreData: paginatedResponse.hasMore,
        totalCount: paginatedResponse.totalCount,
        filteredCount: paginatedResponse.filteredCount,
        error: null,
      )),
    );
  }

  Future<void> _onLoadMoreUsers(
    BMILoadMoreUsers event,
    Emitter<BMIState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMoreData) return;

    emit(state.copyWith(isLoadingMore: true, error: null));

    final nextPage = state.currentPage + 1;
    final result = await getUserProfilesPaginated(page: nextPage, pageSize: 10);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingMore: false,
        error: _mapFailureToMessage(failure),
      )),
      (paginatedResponse) {
        final updatedList = List<UserProfile>.from(state.searchResults)
          ..addAll(paginatedResponse.data);

        emit(state.copyWith(
          isLoadingMore: false,
          searchResults: updatedList,
          currentPage: paginatedResponse.currentPage,
          hasMoreData: paginatedResponse.hasMore,
          totalCount: paginatedResponse.totalCount,
          filteredCount: paginatedResponse.filteredCount,
          error: null,
        ));
      },
    );
  }

  Future<void> _onTogglePin(
    BMITogglePin event,
    Emitter<BMIState> emit,
  ) async {
    final result =
        await managePinnedProfiles.togglePin(event.userId, event.isPinned);

    result.fold(
      (failure) => emit(state.copyWith(
        error: _mapFailureToMessage(failure),
      )),
      (_) {
        // Update the search results to reflect the pin change
        final updatedSearchResults = state.searchResults.map((user) {
          if (user.id == event.userId) {
            return user.copyWith(isPinned: event.isPinned);
          }
          return user;
        }).toList();

        emit(state.copyWith(
          searchResults: updatedSearchResults,
          error: null,
        ));

        // Also reload pinned users
        add(BMILoadPinnedUsers());
      },
    );
  }

  Future<void> _onLoadPinnedUsers(
    BMILoadPinnedUsers event,
    Emitter<BMIState> emit,
  ) async {
    final result = await managePinnedProfiles.getPinnedProfiles();

    result.fold(
      (failure) => emit(state.copyWith(
        error: _mapFailureToMessage(failure),
      )),
      (pinnedUsers) => emit(state.copyWith(
        pinnedUsers: pinnedUsers,
        error: null,
      )),
    );
  }

  Future<void> _onCalculate(
    BMICalculate event,
    Emitter<BMIState> emit,
  ) async {
    emit(state.copyWith(isCalculating: true, error: null));

    final input = BMIInput(
      weight: event.weight,
      height: event.height,
      notes: event.notes,
    );

    final result = await calculateBMI(
      userId: event.userId,
      input: input,
      recordedBy: event.recordedBy,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isCalculating: false,
        error: _mapFailureToMessage(failure),
      )),
      (bmiRecord) {
        // Clear history cache agar di-refresh dengan data baru
        emit(state.copyWith(
          isCalculating: false,
          latestBMIRecord: bmiRecord,
          bmiHistory: [],
          bmiHistoryUserId: null,
          error: null,
        ));

        // Reload history setelah calculation berhasil
        add(BMILoadHistory(event.userId));
      },
    );
  }

  Future<void> _onLoadHistory(
    BMILoadHistory event,
    Emitter<BMIState> emit,
  ) async {
    // Skip jika sudah ada history untuk user yang sama dan tidak force refresh
    if (!event.forceRefresh &&
        state.bmiHistoryUserId == event.userId &&
        state.bmiHistory.isNotEmpty &&
        !state.hasError) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final result = await getBMIHistory(event.userId);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      )),
      (bmiHistory) => emit(state.copyWith(
        isLoading: false,
        bmiHistory: bmiHistory,
        bmiHistoryUserId: event.userId,
        error: null,
      )),
    );
  }

  Future<void> _onDeleteRecord(
    BMIDeleteRecord event,
    Emitter<BMIState> emit,
  ) async {
    // Note: In a real implementation, you'd call the repository to delete
    // For now, we'll just remove from the local state
    final updatedHistory = state.bmiHistory
        .where((record) => record.id != event.recordId)
        .toList();

    emit(state.copyWith(
      bmiHistory: updatedHistory,
      error: null,
    ));
  }

  void _onReset(BMIReset event, Emitter<BMIState> emit) {
    emit(BMIState.initial());
  }

  void _onClearError(BMIClearError event, Emitter<BMIState> emit) {
    emit(state.copyWith(error: null));
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType.toString()) {
      case 'ServerFailure':
        return failure.message ?? 'Terjadi kesalahan pada server';
      case 'NetworkFailure':
        return 'Tidak dapat terhubung ke internet';
      case 'CacheFailure':
        return 'Terjadi kesalahan pada penyimpanan lokal';
      default:
        return 'Terjadi kesalahan tidak terduga';
    }
  }
}
