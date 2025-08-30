// Error classes
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

// Validators
class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (password.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (name.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!RegExp(r'^(\+62|62|0)[0-9]{9,12}$').hasMatch(phone)) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  static String? validatePin(String? pin) {
    if (pin == null || pin.isEmpty) {
      return 'PIN tidak boleh kosong';
    }
    if (pin.length != 6) {
      return 'PIN harus 6 digit';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(pin)) {
      return 'PIN hanya boleh berisi angka';
    }
    return null;
  }
}

// Auth Token
class AuthToken {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime issuedAt;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    required this.expiresIn,
    required this.issuedAt,
  });
}

// Repository interface
abstract class AuthRepository {
  Future<LoginResult> login({
    required String email,
    required String password,
  });
}

// Login Use Case
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<LoginResult> call({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      final emailValidation = Validators.validateEmail(email);
      if (emailValidation != null) {
        return LoginResult.failure(ValidationFailure(emailValidation));
      }

      final passwordValidation = Validators.validatePassword(password);
      if (passwordValidation != null) {
        return LoginResult.failure(ValidationFailure(passwordValidation));
      }

      // Perform login
      final result = await repository.login(
        email: email.trim().toLowerCase(),
        password: password,
      );

      return result;
    } catch (e) {
      return LoginResult.failure(
          ServerFailure('Login failed: ${e.toString()}'));
    }
  }
}

// Login Result
class LoginResult {
  final AuthToken? token;
  final Failure? failure;
  final bool isSuccess;

  const LoginResult._({
    this.token,
    this.failure,
    required this.isSuccess,
  });

  factory LoginResult.success(AuthToken token) {
    return LoginResult._(
      token: token,
      isSuccess: true,
    );
  }

  factory LoginResult.failure(Failure failure) {
    return LoginResult._(
      failure: failure,
      isSuccess: false,
    );
  }
}
