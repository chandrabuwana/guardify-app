import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();
}

class BottomNavigationTappedEvent extends HomeEvent {
  final int index;

  const BottomNavigationTappedEvent(this.index);

  @override
  List<Object> get props => [index];
}

class ShowSnackbarEvent extends HomeEvent {
  final String message;

  const ShowSnackbarEvent(this.message);

  @override
  List<Object> get props => [message];
}

class PanicButtonPressedEvent extends HomeEvent {
  const PanicButtonPressedEvent();
}
