import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_monthly_schedule.dart';
import '../../domain/usecases/get_shift_detail.dart';
import '../../domain/usecases/get_daily_agenda.dart';
import '../../domain/entities/shift_schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

@injectable
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetMonthlySchedule getMonthlySchedule;
  final GetShiftDetail getShiftDetail;
  final GetDailyAgenda getDailyAgenda;

  ScheduleBloc({
    required this.getMonthlySchedule,
    required this.getShiftDetail,
    required this.getDailyAgenda,
  }) : super(ScheduleState.initial()) {
    on<LoadMonthlySchedule>(_onLoadMonthlySchedule);
    on<LoadShiftDetail>(_onLoadShiftDetail);
    on<LoadDailyAgenda>(_onLoadDailyAgenda);
    on<ChangeMonth>(_onChangeMonth);
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
}
