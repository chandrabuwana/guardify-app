import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoaded extends HomeState {
  final int currentBottomNavIndex;
  final String? snackbarMessage;
  final bool showPanicDialog;

  const HomeLoaded({
    required this.currentBottomNavIndex,
    this.snackbarMessage,
    this.showPanicDialog = false,
  });

  HomeLoaded copyWith({
    int? currentBottomNavIndex,
    String? snackbarMessage,
    bool? showPanicDialog,
    bool clearSnackbar = false,
  }) {
    return HomeLoaded(
      currentBottomNavIndex:
          currentBottomNavIndex ?? this.currentBottomNavIndex,
      snackbarMessage:
          clearSnackbar ? null : (snackbarMessage ?? this.snackbarMessage),
      showPanicDialog: showPanicDialog ?? this.showPanicDialog,
    );
  }

  @override
  List<Object> get props => [
        currentBottomNavIndex,
        snackbarMessage ?? '',
        showPanicDialog,
      ];
}
