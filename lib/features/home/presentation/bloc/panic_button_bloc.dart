import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/activate_panic_button.dart';
import '../../domain/usecases/verify_panic_button.dart';
import 'panic_button_event.dart';
import 'panic_button_state.dart';

class PanicButtonBloc extends Bloc<PanicButtonEvent, PanicButtonState> {
  final ActivatePanicButtonUseCase activatePanicButtonUseCase;
  final VerifyPanicButtonUseCase verifyPanicButtonUseCase;

  PanicButtonBloc({
    required this.activatePanicButtonUseCase,
    required this.verifyPanicButtonUseCase,
  }) : super(PanicButtonState.initial()) {
    on<UpdateVerificationEvent>(_onUpdateVerification);
    on<ResetVerificationEvent>(_onResetVerification);
    on<ActivatePanicButtonEvent>(_onActivatePanicButton);
  }

  void _onUpdateVerification(
    UpdateVerificationEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    final newVerificationStates = List<bool>.from(state.verificationStates);
    newVerificationStates[event.index] = event.value;

    emit(state.copyWith(verificationStates: newVerificationStates));
  }

  void _onResetVerification(
    ResetVerificationEvent event,
    Emitter<PanicButtonState> emit,
  ) {
    emit(PanicButtonState.initial());
  }

  void _onActivatePanicButton(
    ActivatePanicButtonEvent event,
    Emitter<PanicButtonState> emit,
  ) async {
    emit(state.copyWith(status: PanicButtonStateStatus.loading));

    final params = ActivatePanicButtonParams(
      userId: event.userId,
      verificationItems: state.verificationItems,
      isVerified: state.allVerified,
    );

    final result = await activatePanicButtonUseCase(params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: PanicButtonStateStatus.error,
          errorMessage: _getFailureMessage(failure),
        ));
      },
      (success) {
        if (success) {
          emit(state.copyWith(status: PanicButtonStateStatus.activated));
        } else {
          emit(state.copyWith(
            status: PanicButtonStateStatus.error,
            errorMessage: 'Failed to activate panic button',
          ));
        }
      },
    );
  }

  String _getFailureMessage(failure) {
    // Handle different types of failures
    return failure.toString();
  }
}
