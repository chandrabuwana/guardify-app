import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitial);
    on<BottomNavigationTappedEvent>(_onBottomNavigationTapped);
    on<ShowSnackbarEvent>(_onShowSnackbar);
    on<PanicButtonPressedEvent>(_onPanicButtonPressed);
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(const HomeLoaded(currentBottomNavIndex: 0));
  }

  void _onBottomNavigationTapped(
    BottomNavigationTappedEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      String message;
      switch (event.index) {
        case 0:
          message = 'Beranda';
          break;
        case 1:
          message = 'Pesan';
          break;
        case 2:
          message = 'Notifikasi';
          break;
        case 3:
          message = 'Profil';
          break;
        default:
          message = 'Menu';
      }

      emit(currentState.copyWith(
        currentBottomNavIndex: event.index,
        snackbarMessage: message,
      ));
    }
  }

  void _onShowSnackbar(ShowSnackbarEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(snackbarMessage: event.message));
    }
  }

  void _onPanicButtonPressed(
    PanicButtonPressedEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(showPanicDialog: true));
    }
  }

  void clearSnackbar() {
    add(const ShowSnackbarEvent(''));
  }

  void hidePanicDialog() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      // Emit through event
      _emitState(currentState.copyWith(showPanicDialog: false));
    }
  }

  void _emitState(HomeState newState) {
    // This is a helper method - in practice, state changes should go through events
  }
}
