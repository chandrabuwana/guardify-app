import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/patrol_attendance.dart';
import '../../domain/usecases/submit_attendance.dart';
import '../../domain/usecases/verify_location.dart';
import '../../domain/repositories/patrol_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

@injectable
class PatrolAttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final SubmitAttendance submitAttendance;
  final VerifyLocation verifyLocation;
  final PatrolRepository repository;

  PatrolAttendanceBloc({
    required this.submitAttendance,
    required this.verifyLocation,
    required this.repository,
  }) : super(AttendanceInitial()) {
    on<SubmitAttendanceEvent>(_onSubmitAttendance);
    on<VerifyLocationEvent>(_onVerifyLocation);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<UploadProofImageEvent>(_onUploadProofImage);
  }

  Future<void> _onSubmitAttendance(
    SubmitAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final attendance = PatrolAttendance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patrolLocationId: event.patrolLocationId,
      userId: 'current_user_id', // Replace with actual user ID
      timestamp: DateTime.now(),
      currentLatitude: -6.173056780703297, // Replace with actual current location
      currentLongitude: 106.78692883979942,
      currentAddress: event.currentAddress,
      proofImagePath: event.proofImagePath,
      notes: event.notes,
      isLocationVerified: true,
    );

    final result = await submitAttendance(attendance);
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (success) => emit(const AttendanceSubmitted('Absen patroli berhasil!')),
    );
  }

  Future<void> _onVerifyLocation(
    VerifyLocationEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final params = VerifyLocationParams(
      currentLatitude: event.currentLatitude,
      currentLongitude: event.currentLongitude,
      targetLatitude: event.targetLatitude,
      targetLongitude: event.targetLongitude,
    );

    final result = await verifyLocation(params);
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (isVerified) => emit(LocationVerified(
        isVerified: isVerified,
        message: isVerified 
            ? 'Verifikasi lokasi berhasil' 
            : 'Lokasi tidak sesuai',
      )),
    );
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await repository.getCurrentLocation();
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (address) => emit(CurrentLocationLoaded(address)),
    );
  }

  Future<void> _onUploadProofImage(
    UploadProofImageEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await repository.uploadProofImage(event.imagePath);
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (imageUrl) => emit(ImageUploaded(imageUrl)),
    );
  }
}