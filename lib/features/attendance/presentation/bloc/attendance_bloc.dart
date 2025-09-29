import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/submit_attendance_usecase.dart';
import '../../domain/usecases/validate_attendance_usecase.dart';
import '../../domain/usecases/check_attendance_status_usecase.dart';
import '../../domain/usecases/get_attendance_history_usecase.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final SubmitAttendanceUseCase submitAttendanceUseCase;
  final ValidateAttendanceUseCase validateAttendanceUseCase;
  final CheckAttendanceStatusUseCase checkAttendanceStatusUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;

  AttendanceBloc({
    required this.submitAttendanceUseCase,
    required this.validateAttendanceUseCase,
    required this.checkAttendanceStatusUseCase,
    required this.getAttendanceHistoryUseCase,
  }) : super(const AttendanceInitial()) {
    on<AttendanceInitialEvent>(_onAttendanceInitial);
    on<CheckAttendanceStatusEvent>(_onCheckAttendanceStatus);
    on<AttendanceFormFieldChangedEvent>(_onFormFieldChanged);
    on<LocationDetectedEvent>(_onLocationDetected);
    on<PhotoCapturedEvent>(_onPhotoCaptured);
    on<PhotoRemovedEvent>(_onPhotoRemoved);
    on<ValidateAttendanceFormEvent>(_onValidateForm);
    on<ValidateTimeAndLocationEvent>(_onValidateTimeAndLocation);
    on<SubmitAttendanceEvent>(_onSubmitAttendance);
    on<LoadAttendanceHistoryEvent>(_onLoadAttendanceHistory);
    on<ResetAttendanceFormEvent>(_onResetForm);
    on<ClearAttendanceErrorEvent>(_onClearError);
  }

  void _onAttendanceInitial(
    AttendanceInitialEvent event,
    Emitter<AttendanceState> emit,
  ) {
    emit(const AttendanceFormState());
  }

  void _onCheckAttendanceStatus(
    CheckAttendanceStatusEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());

    final result = await checkAttendanceStatusUseCase(event.userId);

    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (result) => emit(AttendanceStatusLoaded(
        hasCheckedIn: result.hasCheckedIn,
        currentAttendance: result.currentAttendance,
      )),
    );
  }

  void _onFormFieldChanged(
    AttendanceFormFieldChangedEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;
      AttendanceFormState newState;

      switch (event.fieldName) {
        case 'personalClothing':
          newState = currentState.copyWith(personalClothing: event.value);
          break;
        case 'securityReport':
          newState = currentState.copyWith(securityReport: event.value);
          break;
        case 'patrolRoute':
          newState = currentState.copyWith(patrolRoute: event.value);
          break;
        default:
          newState = currentState;
      }

      // Validate form after field change
      final isValid = _validateFormFields(newState);
      emit(newState.copyWith(isFormValid: isValid));
    }
  }

  void _onLocationDetected(
    LocationDetectedEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;
      final newState = currentState.copyWith(
        currentLocation: event.locationName,
        latitude: event.latitude,
        longitude: event.longitude,
        isLocationDetected: true,
      );

      final isValid = _validateFormFields(newState);
      emit(newState.copyWith(isFormValid: isValid));
    }
  }

  void _onPhotoCaptured(
    PhotoCapturedEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;
      final newState = currentState.copyWith(photoPath: event.photoPath);

      final isValid = _validateFormFields(newState);
      emit(newState.copyWith(isFormValid: isValid));
    }
  }

  void _onPhotoRemoved(
    PhotoRemovedEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;
      final newState = currentState.copyWith(clearPhoto: true);

      final isValid = _validateFormFields(newState);
      emit(newState.copyWith(isFormValid: isValid));
    }
  }

  void _onValidateForm(
    ValidateAttendanceFormEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;
      final errors = <String, String>{};

      if (currentState.personalClothing.trim().isEmpty) {
        errors['personalClothing'] = 'Pakaian Personil harus diisi';
      }

      if (currentState.securityReport.trim().isEmpty) {
        errors['securityReport'] = 'Laporan Pengamanan harus diisi';
      }

      if (currentState.patrolRoute.trim().isEmpty) {
        errors['patrolRoute'] = 'Rute Patroli harus diisi';
      }

      if (currentState.photoPath.isEmpty) {
        errors['photo'] = 'Foto Pengamanan harus diambil';
      }

      if (!currentState.isLocationDetected) {
        errors['location'] = 'Lokasi belum terdeteksi';
      }

      final isValid = errors.isEmpty;
      emit(currentState.copyWith(
        fieldErrors: errors,
        isFormValid: isValid,
      ));
    }
  }

  void _onValidateTimeAndLocation(
    ValidateTimeAndLocationEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;
      emit(const AttendanceLoading());

      final result = await validateAttendanceUseCase(
        currentTime: DateTime.now(),
        shiftType: event.shiftType,
        guardLocation: event.guardLocation,
        currentLocation: event.currentLocation,
        personalClothing: currentState.personalClothing,
        securityReport: currentState.securityReport,
        patrolRoute: currentState.patrolRoute,
        userRole: event.userRole,
      );

      result.fold(
        (failure) => emit(currentState.copyWith(
          validationMessage: failure.message,
          isTimeValid: false,
        )),
        (message) => emit(currentState.copyWith(
          validationMessage: message,
          isTimeValid: true,
        )),
      );
    }
  }

  void _onSubmitAttendance(
    SubmitAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;

      if (!currentState.isFormValid) {
        emit(const AttendanceSubmissionError(
          'Mohon lengkapi semua field yang diperlukan',
        ));
        return;
      }

      emit(const AttendanceSubmissionLoading());

      final now = DateTime.now();
      final attendance = Attendance(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: event.userId,
        userName: event.userName,
        type: event.type,
        shiftType: event.shiftType,
        timestamp: now,
        guardLocation: event.guardLocation,
        currentLocation: currentState.currentLocation,
        latitude: currentState.latitude,
        longitude: currentState.longitude,
        personalClothing: currentState.personalClothing,
        securityReport: currentState.securityReport,
        photoPath: currentState.photoPath,
        patrolRoute: currentState.patrolRoute,
        createdAt: now,
        updatedAt: now,
      );

      final result = await submitAttendanceUseCase(attendance);

      result.fold(
        (failure) => emit(AttendanceSubmissionError(failure.message)),
        (submittedAttendance) => emit(AttendanceSubmissionSuccess(
          attendance: submittedAttendance,
          message: event.type == AttendanceType.clockIn
              ? 'Check In Berhasil\nSelamat Bekerja!'
              : 'Check Out Berhasil\nTerima Kasih!',
        )),
      );
    }
  }

  void _onLoadAttendanceHistory(
    LoadAttendanceHistoryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());

    final result = await getAttendanceHistoryUseCase(event.userId);

    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (history) => emit(AttendanceHistoryLoaded(history)),
    );
  }

  void _onResetForm(
    ResetAttendanceFormEvent event,
    Emitter<AttendanceState> emit,
  ) {
    emit(const AttendanceFormState());
  }

  void _onClearError(
    ClearAttendanceErrorEvent event,
    Emitter<AttendanceState> emit,
  ) {
    if (state is AttendanceFormState) {
      final currentState = state as AttendanceFormState;
      emit(currentState.copyWith(clearValidationMessage: true));
    }
  }

  bool _validateFormFields(AttendanceFormState state) {
    return state.personalClothing.trim().isNotEmpty &&
        state.securityReport.trim().isNotEmpty &&
        state.patrolRoute.trim().isNotEmpty &&
        state.photoPath.isNotEmpty &&
        state.isLocationDetected;
  }
}
