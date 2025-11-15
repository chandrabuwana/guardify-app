import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/check_out_usecase.dart';
import '../../domain/usecases/get_attendance_status_usecase.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final CheckInUseCase checkInUseCase;
  final CheckOutUseCase checkOutUseCase;
  final GetAttendanceStatusUseCase getAttendanceStatusUseCase;

  AttendanceBloc({
    required this.checkInUseCase,
    required this.checkOutUseCase,
    required this.getAttendanceStatusUseCase,
  }) : super(const AttendanceInitial()) {
    on<GetAttendanceStatusEvent>(_onGetAttendanceStatus);
    on<CheckInStartedEvent>(_onCheckInStarted);
    on<CheckInSubmittedEvent>(_onCheckInSubmitted);
    on<CheckOutStartedEvent>(_onCheckOutStarted);
    on<CheckOutSubmittedEvent>(_onCheckOutSubmitted);
    on<UpdateCheckInFormEvent>(_onUpdateCheckInForm);
    on<UpdateCheckOutFormEvent>(_onUpdateCheckOutForm);
    on<ResetAttendanceEvent>(_onResetAttendance);
    on<ClearErrorEvent>(_onClearError);
  }

  void _onGetAttendanceStatus(
    GetAttendanceStatusEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());

    final result = await getAttendanceStatusUseCase(event.userId);

    result.fold(
      (failure) => emit(AttendanceFailure(failure.message)),
      (statusResult) => emit(AttendanceStatusLoaded(
        status: statusResult.status,
        currentAttendance: statusResult.currentAttendance,
      )),
    );
  }

  void _onCheckInStarted(
    CheckInStartedEvent event,
    Emitter<AttendanceState> emit,
  ) {
    emit(const CheckInFormState());
  }

  void _onCheckInSubmitted(
    CheckInSubmittedEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());

    final result = await checkInUseCase(event.request);

    result.fold(
      (failure) => emit(AttendanceFailure(failure.message)),
      (attendance) => emit(AttendanceCheckedIn(attendance: attendance)),
    );
  }

  void _onCheckOutStarted(
    CheckOutStartedEvent event,
    Emitter<AttendanceState> emit,
  ) {
    emit(const CheckOutFormState());
  }

  void _onCheckOutSubmitted(
    CheckOutSubmittedEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());

    final result = await checkOutUseCase(event.request);

    result.fold(
      (failure) => emit(AttendanceFailure(failure.message)),
      (attendance) => emit(AttendanceCheckedOut(attendance: attendance)),
    );
  }

  void _onUpdateCheckInForm(
    UpdateCheckInFormEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is CheckInFormState) {
      final currentState = state as CheckInFormState;
      final newState = currentState.copyWith(
        lokasiPenugasan: event.lokasiPenugasan,
        lokasiTerkini: event.lokasiTerkini,
        ratePatrol: event.ratePatrol,
        pakaianPersonil: event.pakaianPersonil,
        laporanPengamanan: event.laporanPengamanan,
        fotoPengamanan: event.fotoPengamanan,
        tugasLanjutan: event.tugasLanjutan,
        fotoWajah: event.fotoWajah,
      );

      // Validate form
      final errors = _validateCheckInForm(newState);
      final isValid = errors.isEmpty;

      emit(newState.copyWith(
        errors: errors,
        isValid: isValid,
      ));
    }
  }

  void _onUpdateCheckOutForm(
    UpdateCheckOutFormEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is CheckOutFormState) {
      final currentState = state as CheckOutFormState;
      final newState = currentState.copyWith(
        lokasiPenugasanAkhir: event.lokasiPenugasanAkhir,
        statusTugas: event.statusTugas,
        pakaianPersonil: event.pakaianPersonil,
        laporanPengamanan: event.laporanPengamanan,
        fotoPengamanan: event.fotoPengamanan,
        buktiLaporan: event.buktiLaporan,
      );

      // Validate form
      final errors = _validateCheckOutForm(newState);
      final isValid = errors.isEmpty;

      emit(newState.copyWith(
        errors: errors,
        isValid: isValid,
      ));
    }
  }

  void _onResetAttendance(
    ResetAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) {
    emit(const AttendanceInitial());
  }

  void _onClearError(
    ClearErrorEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is AttendanceFailure) {
      emit(const AttendanceInitial());
    }
  }

  Map<String, String> _validateCheckInForm(CheckInFormState state) {
    final errors = <String, String>{};

    if (state.lokasiPenugasan.trim().isEmpty) {
      errors['lokasiPenugasan'] = 'Lokasi Penugasan harus diisi';
    }

    if (state.lokasiTerkini.trim().isEmpty) {
      errors['lokasiTerkini'] = 'Lokasi Terkini harus diisi';
    }

    if (state.ratePatrol.trim().isEmpty) {
      errors['ratePatrol'] = 'Rate Patrol harus dipilih';
    }

    if (state.pakaianPersonil.trim().isEmpty) {
      errors['pakaianPersonil'] = 'Pakaian Personil harus dipilih';
    }

    if (state.laporanPengamanan.trim().isEmpty) {
      errors['laporanPengamanan'] = 'Laporan Pengamanan harus diisi';
    }

    if (state.fotoPengamanan.isEmpty) {
      errors['fotoPengamanan'] = 'Foto Pengamanan harus diambil';
    }

    return errors;
  }

  Map<String, String> _validateCheckOutForm(CheckOutFormState state) {
    final errors = <String, String>{};

    if (state.lokasiPenugasanAkhir.trim().isEmpty) {
      errors['lokasiPenugasanAkhir'] = 'Lokasi Penugasan Akhir harus diisi';
    }

    if (state.statusTugas.trim().isEmpty) {
      errors['statusTugas'] = 'Status Tugas harus dipilih';
    }

    if (state.pakaianPersonil.trim().isEmpty) {
      errors['pakaianPersonil'] = 'Pakaian Personil harus dipilih';
    }

    if (state.laporanPengamanan.trim().isEmpty) {
      errors['laporanPengamanan'] = 'Laporan Pengamanan harus diisi';
    }

    if (state.fotoPengamanan.isEmpty) {
      errors['fotoPengamanan'] = 'Foto Pengamanan harus diambil';
    }

    return errors;
  }
}
