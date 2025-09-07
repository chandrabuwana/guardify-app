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
