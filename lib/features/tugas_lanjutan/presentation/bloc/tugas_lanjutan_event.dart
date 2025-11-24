part of 'tugas_lanjutan_bloc.dart';

/// Base event class
abstract class TugasLanjutanEvent extends Equatable {
  const TugasLanjutanEvent();

  @override
  List<Object?> get props => [];
}

/// Get list of tugas lanjutan
class GetTugasLanjutanListEvent extends TugasLanjutanEvent {
  final bool filterByToday;
  final String? userId;

  const GetTugasLanjutanListEvent({
    this.filterByToday = false,
    this.userId,
  });

  @override
  List<Object?> get props => [filterByToday, userId];
}

/// Get detail tugas lanjutan
class GetTugasLanjutanDetailEvent extends TugasLanjutanEvent {
  final String id;

  const GetTugasLanjutanDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Selesaikan tugas lanjutan
class SelesaikanTugasEvent extends TugasLanjutanEvent {
  final String id;
  final String lokasi;
  final String buktiUrl;
  final String? catatan;
  final String userId;
  final String userName;

  const SelesaikanTugasEvent({
    required this.id,
    required this.lokasi,
    required this.buktiUrl,
    this.catatan,
    required this.userId,
    required this.userName,
  });

  @override
  List<Object?> get props => [id, lokasi, buktiUrl, catatan, userId, userName];
}

/// Get progress summary
class GetProgressSummaryEvent extends TugasLanjutanEvent {
  final String? userId;

  const GetProgressSummaryEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

