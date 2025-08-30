import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.authRepository,
    required this.loginUseCase,
  }) : super(AuthState.initial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthBiometricLoginRequested>(_onBiometricLoginRequested);
    on<AuthPinLoginRequested>(_onPinLoginRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthChangePasswordRequested>(_onChangePasswordRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthUserProfileUpdateRequested>(_onUserProfileUpdateRequested);
    on<AuthBiometricToggleRequested>(_onBiometricToggleRequested);
    on<AuthPinSetRequested>(_onPinSetRequested);
    on<AuthPinChangeRequested>(_onPinChangeRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final result = await loginUseCase(
        email: event.email,
        password: event.password,
      );

      if (result.isSuccess) {
        // Get user data after successful login
        final userResult = await authRepository.getCurrentUser();
        if (userResult.isSuccess && userResult.user != null) {
          emit(AuthState.authenticated(userResult.user!));
        } else {
          emit(AuthState.error('Failed to get user data'));
        }
      } else {
        emit(AuthState.error(result.failure?.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      // Validate inputs
      final emailValidation = Validators.validateEmail(event.email);
      if (emailValidation != null) {
        emit(AuthState.error(emailValidation));
        return;
      }

      final passwordValidation = Validators.validatePassword(event.password);
      if (passwordValidation != null) {
        emit(AuthState.error(passwordValidation));
        return;
      }

      final nameValidation = Validators.validateName(event.name);
      if (nameValidation != null) {
        emit(AuthState.error(nameValidation));
        return;
      }

      if (event.phoneNumber != null) {
        final phoneValidation =
            Validators.validatePhoneNumber(event.phoneNumber);
        if (phoneValidation != null) {
          emit(AuthState.error(phoneValidation));
          return;
        }
      }

      final result = await authRepository.register(
        email: event.email.trim().toLowerCase(),
        password: event.password,
        name: event.name.trim(),
        phoneNumber: event.phoneNumber?.trim(),
      );

      if (result.isSuccess) {
        // Get user data after successful registration
        final userResult = await authRepository.getCurrentUser();
        if (userResult.isSuccess && userResult.user != null) {
          emit(AuthState.authenticated(userResult.user!));
        } else {
          emit(AuthState.error(
              'Registration successful but failed to get user data'));
        }
      } else {
        emit(AuthState.error(result.failure?.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final result = await authRepository.logout();
      if (result.isSuccess) {
        emit(AuthState.unauthenticated());
      } else {
        emit(AuthState.error(result.failure?.message ?? 'Logout failed'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onBiometricLoginRequested(
    AuthBiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final result = await authRepository.loginWithBiometric();
      if (result.isSuccess && result.success == true) {
        final userResult = await authRepository.getCurrentUser();
        if (userResult.isSuccess && userResult.user != null) {
          emit(AuthState.authenticated(userResult.user!));
        } else {
          emit(AuthState.error(
              'Biometric login successful but failed to get user data'));
        }
      } else {
        emit(AuthState.error(
            result.failure?.message ?? 'Biometric login failed'));
      }
    } catch (e) {
      emit(AuthState.error('Biometric login error: ${e.toString()}'));
    }
  }

  Future<void> _onPinLoginRequested(
    AuthPinLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final pinValidation = Validators.validatePin(event.pin);
      if (pinValidation != null) {
        emit(AuthState.error(pinValidation));
        return;
      }

      final result = await authRepository.loginWithPin(event.pin);
      if (result.isSuccess && result.success == true) {
        final userResult = await authRepository.getCurrentUser();
        if (userResult.isSuccess && userResult.user != null) {
          emit(AuthState.authenticated(userResult.user!));
        } else {
          emit(AuthState.error(
              'PIN login successful but failed to get user data'));
        }
      } else {
        emit(AuthState.error(result.failure?.message ?? 'PIN login failed'));
      }
    } catch (e) {
      emit(AuthState.error('PIN login error: ${e.toString()}'));
    }
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final emailValidation = Validators.validateEmail(event.email);
      if (emailValidation != null) {
        emit(AuthState.error(emailValidation));
        return;
      }

      final result =
          await authRepository.forgotPassword(event.email.trim().toLowerCase());
      if (result.isSuccess) {
        emit(state.copyWith(
          status: AuthStatus.initial,
          isLoading: false,
          errorMessage: null,
        ));
      } else {
        emit(AuthState.error(
            result.failure?.message ?? 'Failed to send reset email'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final passwordValidation = Validators.validatePassword(event.newPassword);
      if (passwordValidation != null) {
        emit(AuthState.error(passwordValidation));
        return;
      }

      final result = await authRepository.resetPassword(
        token: event.token,
        newPassword: event.newPassword,
      );

      if (result.isSuccess) {
        emit(AuthState.unauthenticated());
      } else {
        emit(AuthState.error(
            result.failure?.message ?? 'Failed to reset password'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final currentPasswordValidation =
          Validators.validatePassword(event.currentPassword);
      if (currentPasswordValidation != null) {
        emit(AuthState.error('Current password: $currentPasswordValidation'));
        return;
      }

      final newPasswordValidation =
          Validators.validatePassword(event.newPassword);
      if (newPasswordValidation != null) {
        emit(AuthState.error('New password: $newPasswordValidation'));
        return;
      }

      if (event.currentPassword == event.newPassword) {
        emit(AuthState.error(
            'New password must be different from current password'));
        return;
      }

      final result = await authRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );

      if (result.isSuccess) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: null,
        ));
      } else {
        emit(AuthState.error(
            result.failure?.message ?? 'Failed to change password'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        final hasValidToken = await authRepository.hasValidToken();
        if (hasValidToken) {
          final userResult = await authRepository.getCurrentUser();
          if (userResult.isSuccess && userResult.user != null) {
            emit(AuthState.authenticated(userResult.user!));
          } else {
            emit(AuthState.unauthenticated());
          }
        } else {
          emit(AuthState.unauthenticated());
        }
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onUserProfileUpdateRequested(
    AuthUserProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      if (event.name != null) {
        final nameValidation = Validators.validateName(event.name);
        if (nameValidation != null) {
          emit(AuthState.error(nameValidation));
          return;
        }
      }

      if (event.phoneNumber != null) {
        final phoneValidation =
            Validators.validatePhoneNumber(event.phoneNumber);
        if (phoneValidation != null) {
          emit(AuthState.error(phoneValidation));
          return;
        }
      }

      final result = await authRepository.updateProfile(
        name: event.name?.trim(),
        phoneNumber: event.phoneNumber?.trim(),
      );

      if (result.isSuccess) {
        final userResult = await authRepository.getCurrentUser();
        if (userResult.isSuccess && userResult.user != null) {
          emit(AuthState.authenticated(userResult.user!));
        } else {
          emit(AuthState.error(
              'Profile updated but failed to get updated user data'));
        }
      } else {
        emit(AuthState.error(
            result.failure?.message ?? 'Failed to update profile'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onBiometricToggleRequested(
    AuthBiometricToggleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final result = event.enable
          ? await authRepository.enableBiometric()
          : await authRepository.disableBiometric();

      if (result.isSuccess) {
        final userResult = await authRepository.getCurrentUser();
        if (userResult.isSuccess && userResult.user != null) {
          emit(AuthState.authenticated(userResult.user!));
        } else {
          emit(state.copyWith(isLoading: false));
        }
      } else {
        emit(AuthState.error(
            result.failure?.message ?? 'Failed to toggle biometric'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onPinSetRequested(
    AuthPinSetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final pinValidation = Validators.validatePin(event.pin);
      if (pinValidation != null) {
        emit(AuthState.error(pinValidation));
        return;
      }

      final result = await authRepository.setPin(event.pin);
      if (result.isSuccess) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(AuthState.error(result.failure?.message ?? 'Failed to set PIN'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onPinChangeRequested(
    AuthPinChangeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final currentPinValidation = Validators.validatePin(event.currentPin);
      if (currentPinValidation != null) {
        emit(AuthState.error('Current PIN: $currentPinValidation'));
        return;
      }

      final newPinValidation = Validators.validatePin(event.newPin);
      if (newPinValidation != null) {
        emit(AuthState.error('New PIN: $newPinValidation'));
        return;
      }

      if (event.currentPin == event.newPin) {
        emit(AuthState.error('New PIN must be different from current PIN'));
        return;
      }

      final result = await authRepository.changePin(
        currentPin: event.currentPin,
        newPin: event.newPin,
      );

      if (result.isSuccess) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(
            AuthState.error(result.failure?.message ?? 'Failed to change PIN'));
      }
    } catch (e) {
      emit(AuthState.error('An unexpected error occurred: ${e.toString()}'));
    }
  }
}

// Temporary implementations
abstract class AuthRepository {
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  Future<AuthResult> getCurrentUser();
  Future<AuthResult> logout();
  Future<AuthResult> loginWithBiometric();
  Future<AuthResult> loginWithPin(String pin);
  Future<AuthResult> forgotPassword(String email);
  Future<AuthResult> resetPassword(
      {required String token, required String newPassword});
  Future<AuthResult> changePassword(
      {required String currentPassword, required String newPassword});
  Future<bool> isLoggedIn();
  Future<bool> hasValidToken();
  Future<AuthResult> updateProfile({String? name, String? phoneNumber});
  Future<AuthResult> enableBiometric();
  Future<AuthResult> disableBiometric();
  Future<AuthResult> setPin(String pin);
  Future<AuthResult> changePin(
      {required String currentPin, required String newPin});
}

class AuthResult {
  final bool isSuccess;
  final User? user;
  final bool? success;
  final Failure? failure;

  const AuthResult({
    required this.isSuccess,
    this.user,
    this.success,
    this.failure,
  });
}

class Failure {
  final String message;
  const Failure(this.message);
}

class LoginUseCase {
  Future<AuthResult> call(
      {required String email, required String password}) async {
    // Implementation here
    return const AuthResult(isSuccess: true);
  }
}
