import 'package:equatable/equatable.dart';

abstract class PanicButtonEvent extends Equatable {
  const PanicButtonEvent();

  @override
  List<Object?> get props => [];
}

class LoadVerificationItemsEvent extends PanicButtonEvent {
  const LoadVerificationItemsEvent();
}

class UpdateVerificationEvent extends PanicButtonEvent {
  final int index;
  final bool isChecked;

  const UpdateVerificationEvent(this.index, this.isChecked);

  @override
  List<Object?> get props => [index, isChecked];
}

class ActivatePanicButtonEvent extends PanicButtonEvent {
  final String userId;

  const ActivatePanicButtonEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ResetVerificationEvent extends PanicButtonEvent {
  const ResetVerificationEvent();
}

class ShowPanicDialogEvent extends PanicButtonEvent {
  const ShowPanicDialogEvent();
}

// History Events
class LoadPanicButtonHistoryEvent extends PanicButtonEvent {
  final int start;
  final int length;
  final String? searchQuery;

  const LoadPanicButtonHistoryEvent({
    this.start = 0,
    this.length = 10,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [start, length, searchQuery];
}

class LoadMorePanicButtonHistoryEvent extends PanicButtonEvent {
  const LoadMorePanicButtonHistoryEvent();
}

class SearchPanicButtonHistoryEvent extends PanicButtonEvent {
  final String query;

  const SearchPanicButtonHistoryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshPanicButtonHistoryEvent extends PanicButtonEvent {
  const RefreshPanicButtonHistoryEvent();
}

class LoadPanicButtonDetailEvent extends PanicButtonEvent {
  final String id;

  const LoadPanicButtonDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SubmitPanicButtonVerificationEvent extends PanicButtonEvent {
  final String id;
  final String status;
  final String? notes;

  const SubmitPanicButtonVerificationEvent({
    required this.id,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [id, status, notes];
}