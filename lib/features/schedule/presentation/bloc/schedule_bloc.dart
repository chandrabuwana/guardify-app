import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_monthly_schedule.dart';
import '../../domain/usecases/get_shift_detail.dart';
import '../../domain/usecases/get_daily_agenda.dart';
import '../../domain/usecases/get_schedule_detail.dart';
import '../../domain/entities/shift_schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

@injectable
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetMonthlySchedule getMonthlySchedule;
  final GetShiftDetail getShiftDetail;
  final GetDailyAgenda getDailyAgenda;
  final GetScheduleDetail getScheduleDetail;

  ScheduleBloc({
    required this.getMonthlySchedule,
    required this.getShiftDetail,
    required this.getDailyAgenda,
    required this.getScheduleDetail,
  }) : super(ScheduleState.initial()) {
    on<LoadMonthlySchedule>(_onLoadMonthlySchedule);
    on<LoadShiftDetail>(_onLoadShiftDetail);
    on<LoadDailyAgenda>(_onLoadDailyAgenda);
    on<ChangeMonth>(_onChangeMonth);
    on<LoadScheduleDetail>(_onLoadScheduleDetail);
  }

  Future<void> _onLoadMonthlySchedule(
    LoadMonthlySchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getMonthlySchedule(
      userId: event.userId,
      year: event.year,
      month: event.month,
    );

    if (result.isSuccess && result.schedules != null) {
      emit(state.copyWith(
        isLoading: false,
        schedules: result.schedules,
        selectedYear: event.year,
        selectedMonth: event.month,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        error: result.failure?.message ?? 'Gagal memuat jadwal',
      ));
    }
  }

  Future<void> _onLoadShiftDetail(
    LoadShiftDetail event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetail: true));

    final result = await getShiftDetail(
      userId: event.userId,
      date: event.date,
    );

    if (result.isSuccess && result.shiftDetail != null) {
      emit(state.copyWith(
        isLoadingDetail: false,
        selectedShift: result.shiftDetail,
      ));
    } else {
      emit(state.copyWith(
        isLoadingDetail: false,
        error: result.failure?.message ?? 'Gagal memuat detail shift',
      ));
    }
  }

  Future<void> _onLoadDailyAgenda(
    LoadDailyAgenda event,
    Emitter<ScheduleState> emit,
  ) async {
    final result = await getDailyAgenda(
      userId: event.userId,
      year: event.year,
      month: event.month,
    );

    if (result.isSuccess && result.agendas != null) {
      emit(state.copyWith(
        dailyAgendas: result.agendas,
      ));
    }
  }

  Future<void> _onChangeMonth(
    ChangeMonth event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(
      selectedYear: event.year,
      selectedMonth: event.month,
    ));

    // Load schedule dan agenda untuk bulan baru
    add(LoadMonthlySchedule(
      userId: event.userId,
      year: event.year,
      month: event.month,
    ));

    add(LoadDailyAgenda(
      userId: event.userId,
      year: event.year,
      month: event.month,
    ));
  }

  Future<void> _onLoadScheduleDetail(
    LoadScheduleDetail event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetail: true));

    final result = await getScheduleDetail(
      userId: event.userId,
      date: event.date,
    );

    if (result.isSuccess) {
      // Success case - shiftDetail can be null (no schedule for this date)
      if (result.shiftDetail == null) {
        // Explicitly clear selectedShift when no data
        print('[ScheduleBloc] ✅ No schedule data - clearing selectedShift');
        final newState = state.copyWith(
          isLoadingDetail: false,
          clearSelectedShift: true,
          clearError: true,
        );
        emit(newState);
        print('[ScheduleBloc] ✅ State updated - selectedShift is now: ${newState.selectedShift}');
      } else {
        // Has data
        print('[ScheduleBloc] ✅ Schedule data found: ${result.shiftDetail!.shiftName}');
        emit(state.copyWith(
          isLoadingDetail: false,
          selectedShift: result.shiftDetail,
          clearError: true,
        ));
      }
    } else {
      // Failure case - show error
      print('[ScheduleBloc] ❌ Error loading schedule: ${result.failure?.message}');
      emit(state.copyWith(
        isLoadingDetail: false,
        error: result.failure?.message ?? 'Gagal memuat detail jadwal',
      ));
    }
  }
}
