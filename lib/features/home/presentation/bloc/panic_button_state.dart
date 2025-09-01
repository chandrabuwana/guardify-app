import 'package:equatable/equatable.dart';
import '../../domain/entities/panic_button.dart';

enum PanicButtonStateStatus {
  initial,
  loading,
  verified,
  activated,
  error,
}

class PanicButtonState extends Equatable {
  final PanicButtonStateStatus status;
  final String? errorMessage;
  final List<bool> verificationStates;
  final PanicButton? currentPanicButton;

  const PanicButtonState({
    required this.status,
    this.errorMessage,
    required this.verificationStates,
    this.currentPanicButton,
  });

  factory PanicButtonState.initial() {
    return const PanicButtonState(
      status: PanicButtonStateStatus.initial,
      verificationStates: [false, false, false, false],
    );
  }

  PanicButtonState copyWith({
    PanicButtonStateStatus? status,
    String? errorMessage,
    List<bool>? verificationStates,
    PanicButton? currentPanicButton,
    bool clearError = false,
  }) {
    return PanicButtonState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      verificationStates: verificationStates ?? this.verificationStates,
      currentPanicButton: currentPanicButton ?? this.currentPanicButton,
    );
  }

  bool get allVerified => verificationStates.every((state) => state);

  // Verification items
  List<String> get verificationItems => [
        'Kejadian yang terjadi saat ini membutuhkan respon darurat.',
        'Saya sudah memverifikasi bahwa situasi ini membahayakan keselamatan atau keamanan',
        'Saya memahami bahwa tindakan ini akan menghubungi atasan secara langsung',
        'Saya sudah memastikan bahwa tidak ada ancaman palsu atau salah pengertian'
      ];

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        verificationStates,
        currentPanicButton,
      ];
}
