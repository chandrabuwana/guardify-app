import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_attendance_rekap_detail_usecase.dart';
import '../../domain/usecases/update_attendance_rekap_usecase.dart';
import 'attendance_rekap_detail_event.dart';
import 'attendance_rekap_detail_state.dart';

@injectable
class AttendanceRekapDetailBloc
    extends Bloc<AttendanceRekapDetailEvent, AttendanceRekapDetailState> {
  final GetAttendanceRekapDetailUseCase getAttendanceRekapDetailUseCase;
  final UpdateAttendanceRekapUseCase updateAttendanceRekapUseCase;

  AttendanceRekapDetailBloc({
    required this.getAttendanceRekapDetailUseCase,
    required this.updateAttendanceRekapUseCase,
  }) : super(const AttendanceRekapDetailInitial()) {
    on<LoadAttendanceRekapDetailEvent>(_onLoadAttendanceRekapDetail);
    on<UpdateAttendanceRekapDetailEvent>(_onUpdateAttendanceRekapDetail);
  }

  Future<void> _onLoadAttendanceRekapDetail(
    LoadAttendanceRekapDetailEvent event,
    Emitter<AttendanceRekapDetailState> emit,
  ) async {
    emit(const AttendanceRekapDetailLoading());

    final result = await getAttendanceRekapDetailUseCase(event.idAttendance);

    result.fold(
      (failure) => emit(AttendanceRekapDetailFailure(failure.message)),
      (response) {
        if (response.succeeded && response.data != null) {
          emit(AttendanceRekapDetailLoaded(detail: response.data!));
        } else {
          emit(AttendanceRekapDetailFailure(
              response.message.isEmpty ? 'Data tidak ditemukan' : response.message));
        }
      },
    );
  }

  Future<void> _onUpdateAttendanceRekapDetail(
    UpdateAttendanceRekapDetailEvent event,
    Emitter<AttendanceRekapDetailState> emit,
  ) async {
    emit(const AttendanceRekapDetailUpdating());

    final result = await updateAttendanceRekapUseCase(event.request);

    result.fold(
      (failure) => emit(AttendanceRekapDetailFailure(failure.message)),
      (_) {
        emit(const AttendanceRekapDetailUpdateSuccess());
        // Reload detail after successful update
        add(LoadAttendanceRekapDetailEvent(event.request.idAttendance));
      },
    );
  }
}

