part of 'schedule_bloc.dart';

class ScheduleState {
  final bool isLoading;
  final bool isLoadingDetail;
  final List<ShiftSchedule> schedules;
  final ShiftSchedule? selectedShift;
  final List<DailyAgenda> dailyAgendas;
  final String? error;
  final int selectedYear;
  final int selectedMonth;

  const ScheduleState({
    required this.isLoading,
    required this.isLoadingDetail,
    required this.schedules,
    this.selectedShift,
    required this.dailyAgendas,
    this.error,
    required this.selectedYear,
    required this.selectedMonth,
  });

  factory ScheduleState.initial() {
    final now = DateTime.now();
    return ScheduleState(
      isLoading: false,
      isLoadingDetail: false,
      schedules: [],
      dailyAgendas: [],
      selectedYear: now.year,
      selectedMonth: now.month,
    );
  }

  ScheduleState copyWith({
    bool? isLoading,
    bool? isLoadingDetail,
    List<ShiftSchedule>? schedules,
    ShiftSchedule? selectedShift,
    bool clearSelectedShift = false, // Flag to explicitly clear selectedShift
    List<DailyAgenda>? dailyAgendas,
    String? error,
    bool clearError = false, // Flag to explicitly clear error
    int? selectedYear,
    int? selectedMonth,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      schedules: schedules ?? this.schedules,
      selectedShift: clearSelectedShift 
          ? null 
          : (selectedShift ?? this.selectedShift),
      dailyAgendas: dailyAgendas ?? this.dailyAgendas,
      error: clearError ? null : (error ?? this.error),
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}
