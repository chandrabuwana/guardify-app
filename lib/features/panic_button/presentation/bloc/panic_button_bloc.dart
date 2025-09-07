import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/activate_panic_button_usecase.dart';
import '../../domain/usecases/get_verification_items_usecase.dart';
import 'panic_button_event.dart';
import 'panic_button_state.dart';

@injectable
class PanicButtonBloc extends Bloc<PanicButtonEvent, PanicButtonState> {
  final ActivatePanicButtonUseCase activatePanicButtonUseCase;
  final GetVerificationItemsUseCase getVerificationItemsUseCase;

  PanicButtonBloc({
    required this.activatePanicButtonUseCase,
    required this.getVerificationItemsUseCase,
  }) : super(const PanicButtonState()) {
    on<LoadVerificationItemsEvent>(_onLoadVerificationItems);
    on<UpdateVerificationEvent>(_onUpdateVerification);
    on<ActivatePanicButtonEvent>(_onActivatePanicButton);
    on<ResetVerificationEvent>(_onResetVerification);
    on<ShowPanicDialogEvent>(_onShowPanicDialog);
  }

  Future<void> _onLoadVerificationItems(
    LoadVerificationItemsEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(status: PanicButtonStateStatus.loading));

    try {
      final items = await getVerificationItemsUseCase();
      emit(state.copyWith(
        status: PanicButtonStateStatus.loaded,
        verificationItems: items,
        verificationStates: List.filled(items.length, false),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PanicButtonStateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateVerification(
    UpdateVerificationEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    final newStates = List<bool>.from(state.verificationStates);
    newStates[event.index] = event.isChecked;

    emit(state.copyWith(verificationStates: newStates));
  }

  Future<void> _onActivatePanicButton(
    ActivatePanicButtonEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(status: PanicButtonStateStatus.loading));

    try {
      final alert = await activatePanicButtonUseCase(event.userId);
      emit(state.copyWith(
        status: PanicButtonStateStatus.activated,
        panicAlert: alert,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PanicButtonStateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetVerification(
    ResetVerificationEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    emit(state.copyWith(
      status: PanicButtonStateStatus.initial,
      verificationStates: List.filled(state.verificationItems.length, false),
      panicAlert: null,
      errorMessage: null,
      showPanicDialog: false,
    ));
  }

  void _onShowPanicDialog(
    ShowPanicDialogEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    emit(state.copyWith(
      showPanicDialog: true,
      status: PanicButtonStateStatus.showDialog,
    ));
  }
}
