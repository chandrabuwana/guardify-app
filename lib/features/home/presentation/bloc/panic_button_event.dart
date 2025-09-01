import 'package:equatable/equatable.dart';

abstract class PanicButtonEvent extends Equatable {
  const PanicButtonEvent();

  @override
  List<Object> get props => [];
}

class UpdateVerificationEvent extends PanicButtonEvent {
  final int index;
  final bool value;

  const UpdateVerificationEvent(this.index, this.value);

  @override
  List<Object> get props => [index, value];
}

class ResetVerificationEvent extends PanicButtonEvent {
  const ResetVerificationEvent();
}

class ActivatePanicButtonEvent extends PanicButtonEvent {
  final String userId;

  const ActivatePanicButtonEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
