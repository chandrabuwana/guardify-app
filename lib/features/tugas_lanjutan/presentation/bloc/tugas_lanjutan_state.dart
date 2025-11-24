part of 'tugas_lanjutan_bloc.dart';

/// Base state class
abstract class TugasLanjutanState extends Equatable {
  const TugasLanjutanState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TugasLanjutanInitial extends TugasLanjutanState {}

/// Loading state
class TugasLanjutanLoading extends TugasLanjutanState {}

/// List loaded state
class TugasLanjutanListLoaded extends TugasLanjutanState {
  final List<TugasLanjutanEntity> tugasList;

  const TugasLanjutanListLoaded({required this.tugasList});

  @override
  List<Object?> get props => [tugasList];
}

/// Detail loaded state
class TugasLanjutanDetailLoaded extends TugasLanjutanState {
  final TugasLanjutanEntity tugas;

  const TugasLanjutanDetailLoaded({required this.tugas});

  @override
  List<Object?> get props => [tugas];
}

/// Updated state
class TugasLanjutanUpdated extends TugasLanjutanState {
  final TugasLanjutanEntity tugas;

  const TugasLanjutanUpdated({required this.tugas});

  @override
  List<Object?> get props => [tugas];
}

/// Progress summary loaded state
class TugasLanjutanProgressLoaded extends TugasLanjutanState {
  final Map<String, dynamic> summary;

  const TugasLanjutanProgressLoaded({required this.summary});

  @override
  List<Object?> get props => [summary];
}

/// Error state
class TugasLanjutanError extends TugasLanjutanState {
  final String message;

  const TugasLanjutanError({required this.message});

  @override
  List<Object?> get props => [message];
}

