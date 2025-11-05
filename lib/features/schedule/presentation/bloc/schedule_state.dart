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
    List<DailyAgenda>? dailyAgendas,
    String? error,
    int? selectedYear,
    int? selectedMonth,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      schedules: schedules ?? this.schedules,
      selectedShift: selectedShift ?? this.selectedShift,
      dailyAgendas: dailyAgendas ?? this.dailyAgendas,
      error: error,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}
