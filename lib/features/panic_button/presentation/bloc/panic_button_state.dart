import 'package:equatable/equatable.dart';
import '../../domain/entities/panic_alert.dart';

enum PanicButtonStateStatus {
  initial,
  loading,
  loaded,
  activated,
  error,
  showDialog,
}

class PanicButtonState extends Equatable {
  final PanicButtonStateStatus status;
  final List<String> verificationItems;
  final List<bool> verificationStates;
  final PanicAlert? panicAlert;
  final String? errorMessage;
  final bool showPanicDialog;

  const PanicButtonState({
    this.status = PanicButtonStateStatus.initial,
    this.verificationItems = const [],
    this.verificationStates = const [],
    this.panicAlert,
    this.errorMessage,
    this.showPanicDialog = false,
  });

  bool get allVerified =>
      verificationStates.isNotEmpty &&
      verificationStates.every((verified) => verified);

  PanicButtonState copyWith({
    PanicButtonStateStatus? status,
    List<String>? verificationItems,
    List<bool>? verificationStates,
    PanicAlert? panicAlert,
    String? errorMessage,
    bool? showPanicDialog,
  }) {
    return PanicButtonState(
      status: status ?? this.status,
      verificationItems: verificationItems ?? this.verificationItems,
      verificationStates: verificationStates ?? this.verificationStates,
      panicAlert: panicAlert ?? this.panicAlert,
      errorMessage: errorMessage ?? this.errorMessage,
      showPanicDialog: showPanicDialog ?? this.showPanicDialog,
    );
  }

  @override
  List<Object?> get props => [
        status,
        verificationItems,
        verificationStates,
        panicAlert,
        errorMessage,
        showPanicDialog,
      ];
}
