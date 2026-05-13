# MSAL Login Redirect Loop & breakConnection=true - Troubleshooting Guide

## Problem
- ✅ MSAL login succeeds
- ❌ After success, redirected back to login page
- ❌ `breakConnection=true` error appears
- 🔄 Infinite redirect loop

## Root Causes

### 1. Token Not Saved Properly
```
MSAL returns token → Not saved to storage → App thinks user is not logged in → Redirect to login
```

### 2. Token Validation Fails
```
Token saved → But validation endpoint returns 401 → App thinks token is invalid → Redirect to login
```

### 3. SignalR Connection Fails
```
breakConnection=true → SignalR can't connect → App treats as authentication failure → Redirect to login
```

### 4. Token Expired Immediately
```
Token received → Expires before app checks it → Validation fails → Redirect to login
```

---

## Solution 1: Fix Token Storage After MSAL Login

### Step 1: Check MSAL Login Handler

**In your login page/bloc:**

```dart
// ❌ WRONG: Not saving token
Future<void> loginWithMSAL() async {
  final result = await msalClient.acquireTokenInteractive(scopes);
  // Token received but not saved!
  // App doesn't know user is logged in
}

// ✅ CORRECT: Save token immediately
Future<void> loginWithMSAL() async {
  try {
    final result = await msalClient.acquireTokenInteractive(scopes);
    
    // Save token immediately
    await SecurityManager.saveSecurely(
      AppConstants.tokenKey,
      result.accessToken,
    );
    
    // Save refresh token if available
    if (result.refreshToken != null) {
      await SecurityManager.saveSecurely(
        AppConstants.refreshTokenKey,
        result.refreshToken!,
      );
    }
    
    // Verify token was saved
    final savedToken = await SecurityManager.readSecurely(AppConstants.tokenKey);
    if (savedToken == null || savedToken.isEmpty) {
      throw Exception('Failed to save token');
    }
    
    print('✅ Token saved successfully');
    
    // Now redirect to home
    Navigator.of(context).pushReplacementNamed('/home');
  } catch (e) {
    print('❌ MSAL login failed: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: $e')),
    );
  }
}
```

### Step 2: Verify Token in AuthGate

**In `main.dart` `_AuthGate`:**

```dart
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getAndValidateToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;
        final hasToken = token != null && token.trim().isNotEmpty;

        print('🔐 AuthGate - Token exists: $hasToken');
        print('🔐 AuthGate - Token length: ${token?.length ?? 0}');

        if (hasToken) {
          return BlocProvider(
            create: (context) => getIt<HomeBloc>(),
            child: const HomePage(),
          );
        }

        return BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: const LoginPage(),
        );
      },
    );
  }

  Future<String?> _getAndValidateToken() async {
    try {
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      
      if (token == null || token.isEmpty) {
        print('⚠️ No token found');
        return null;
      }

      // Validate token with backend
      final isValid = await _validateTokenWithBackend(token);
      
      if (!isValid) {
        print('❌ Token validation failed');
        // Clear invalid token
        await SecurityManager.deleteSecurely(AppConstants.tokenKey);
        return null;
      }

      print('✅ Token is valid');
      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  Future<bool> _validateTokenWithBackend(String token) async {
    try {
      // Call your validation endpoint
      final response = await http.get(
        Uri.parse('${AppConstants.apiUrl}/auth/validate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Token validation error: $e');
      return false;
    }
  }
}
```

---

## Solution 2: Fix SignalR Connection (breakConnection=true)

### Step 1: Check SignalR Service

**In your SignalR service:**

```dart
import 'package:microsoft_signalr/microsoft_signalr.dart';
import 'core/security/security_manager.dart';
import 'core/constants/app_constants.dart';

class SignalRService {
  HubConnection? _connection;

  Future<void> connect() async {
    try {
      // Get token
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      
      if (token == null || token.isEmpty) {
        print('❌ No token available for SignalR');
        throw Exception('Token not available');
      }

      print('🔗 Connecting to SignalR with token...');

      _connection = HubConnectionBuilder()
          .withUrl(
            AppConstants.signalRHubUrl,
            HttpConnectionOptions(
              accessTokenFactory: () async => token,
              // Important: Skip certificate validation for dev
              skipNegotiation: false,
              transport: HttpTransportType.webSockets,
              logMessageContent: true,
            ),
          )
          .withAutomaticReconnect(
            retryDelays: [
              Duration(milliseconds: 0),
              Duration(milliseconds: 500),
              Duration(seconds: 1),
              Duration(seconds: 5),
              Duration(seconds: 10),
            ],
          )
          .build();

      // Listen for connection events
      _connection?.onclose(({error}) {
        print('❌ SignalR disconnected: $error');
      });

      _connection?.onreconnected(({connectionId}) {
        print('✅ SignalR reconnected: $connectionId');
      });

      _connection?.onreconnecting(({error}) {
        print('⚠️ SignalR reconnecting: $error');
      });

      await _connection?.start();
      print('✅ SignalR connected successfully');
    } catch (e) {
      print('❌ SignalR connection failed: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await _connection?.stop();
      print('✅ SignalR disconnected');
    } catch (e) {
      print('❌ Error disconnecting SignalR: $e');
    }
  }

  bool get isConnected => _connection?.state == HubConnectionState.connected;
}
```

### Step 2: Handle breakConnection in Bloc

**In your home bloc or auth bloc:**

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignalRService _signalRService;

  AuthBloc(this._signalRService) : super(AuthInitial()) {
    on<LoginSuccessEvent>(_onLoginSuccess);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoginSuccess(
    LoginSuccessEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // 1. Save token
      await SecurityManager.saveSecurely(
        AppConstants.tokenKey,
        event.token,
      );

      // 2. Wait a bit for token to be saved
      await Future.delayed(Duration(milliseconds: 500));

      // 3. Connect SignalR with the token
      try {
        await _signalRService.connect();
        print('✅ SignalR connected after login');
      } catch (e) {
        print('⚠️ SignalR connection failed: $e');
        // Don't fail login if SignalR fails
        // User can still use app
      }

      // 4. Emit success
      emit(AuthSuccess(token: event.token));
    } catch (e) {
      print('❌ Login success handler failed: $e');
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Disconnect SignalR first
      await _signalRService.disconnect();
      
      // Clear token
      await SecurityManager.deleteSecurely(AppConstants.tokenKey);
      
      emit(AuthInitial());
    } catch (e) {
      print('❌ Logout failed: $e');
    }
  }
}
```

---

## Solution 3: Fix Token Expiration Issue

### Step 1: Check Token Expiry

```dart
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      print('❌ Error checking token expiry: $e');
      return true; // Treat as expired if can't decode
    }
  }

  static Duration? getTimeUntilExpiry(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        (decodedToken['exp'] as int) * 1000,
      );
      return expiryTime.difference(DateTime.now());
    } catch (e) {
      print('❌ Error getting token expiry: $e');
      return null;
    }
  }
}
```

### Step 2: Refresh Token Before Expiry

```dart
class AuthInterceptor extends HttpInterceptor {
  final AuthBloc _authBloc;

  AuthInterceptor(this._authBloc);

  @override
  Future<HttpResponse<dynamic>> onRequest(
    HttpRequest request,
  ) async {
    try {
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);

      if (token != null) {
        // Check if token is about to expire (within 5 minutes)
        final timeUntilExpiry = TokenManager.getTimeUntilExpiry(token);
        
        if (timeUntilExpiry != null && 
            timeUntilExpiry.inMinutes < 5) {
          print('⚠️ Token expiring soon, refreshing...');
          
          // Refresh token
          final refreshToken = await SecurityManager.readSecurely(
            AppConstants.refreshTokenKey,
          );
          
          if (refreshToken != null) {
            final newToken = await _refreshToken(refreshToken);
            if (newToken != null) {
              await SecurityManager.saveSecurely(
                AppConstants.tokenKey,
                newToken,
              );
              request.headers['Authorization'] = 'Bearer $newToken';
            }
          }
        } else {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (e) {
      print('❌ Error in auth interceptor: $e');
    }

    return super.onRequest(request);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['accessToken'];
      }
      return null;
    } catch (e) {
      print('❌ Token refresh failed: $e');
      return null;
    }
  }
}
```

---

## Solution 4: Debug Checklist

### ✅ Step 1: Verify Token is Saved

```dart
// After MSAL login succeeds
final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
print('Token saved: ${token != null}');
print('Token length: ${token?.length ?? 0}');
print('Token preview: ${token?.substring(0, 20)}...');
```

### ✅ Step 2: Check Token Format

```dart
// Token should start with "eyJ"
if (token.startsWith('eyJ')) {
  print('✅ Token format looks correct (JWT)');
} else {
  print('❌ Token format is wrong');
}
```

### ✅ Step 3: Verify Token Expiry

```dart
final isExpired = JwtDecoder.isExpired(token);
print('Token expired: $isExpired');

final decodedToken = JwtDecoder.decode(token);
print('Token claims: $decodedToken');
```

### ✅ Step 4: Check API Response

```dart
// Make test request with token
final response = await http.get(
  Uri.parse('${AppConstants.apiUrl}/auth/validate'),
  headers: {'Authorization': 'Bearer $token'},
);

print('Validation response: ${response.statusCode}');
print('Response body: ${response.body}');
```

### ✅ Step 5: Monitor SignalR Connection

```dart
// Add logging to SignalR service
_connection?.onclose(({error}) {
  print('❌ SignalR closed: $error');
  // Check if this triggers logout
});
```

---

## Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Token not saved | Missing `SecurityManager.saveSecurely()` | Add token save after MSAL login |
| Token saved but not read | Wrong key name | Check `AppConstants.tokenKey` matches |
| 401 Unauthorized | Token invalid/expired | Validate token before using |
| breakConnection=true | SignalR auth fails | Pass token in `accessTokenFactory` |
| Infinite redirect loop | AuthGate checks fail | Add logging to AuthGate |
| Token expires immediately | Wrong expiry time | Check token claims with JWT decoder |

---

## Complete Working Example

### 1. MSAL Login Handler

```dart
Future<void> loginWithMSAL() async {
  try {
    print('🔐 Starting MSAL login...');
    
    final result = await msalClient.acquireTokenInteractive(
      scopes: ['api://your-app-id/.default'],
    );

    print('✅ MSAL login successful');
    print('🔐 Saving token...');

    // Save token
    await SecurityManager.saveSecurely(
      AppConstants.tokenKey,
      result.accessToken,
    );

    // Verify save
    final savedToken = await SecurityManager.readSecurely(AppConstants.tokenKey);
    if (savedToken == null) {
      throw Exception('Token save failed');
    }

    print('✅ Token saved: ${savedToken.length} bytes');

    // Navigate to home
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  } catch (e) {
    print('❌ MSAL login failed: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
}
```

### 2. AuthGate with Validation

```dart
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getValidToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hasToken = snapshot.data != null;
        print('🔐 AuthGate - Has token: $hasToken');

        if (hasToken) {
          return BlocProvider(
            create: (context) => getIt<HomeBloc>(),
            child: const HomePage(),
          );
        }

        return BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: const LoginPage(),
        );
      },
    );
  }

  Future<String?> _getValidToken() async {
    try {
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      
      if (token == null || token.isEmpty) {
        return null;
      }

      // Check expiry
      if (JwtDecoder.isExpired(token)) {
        print('⚠️ Token expired');
        await SecurityManager.deleteSecurely(AppConstants.tokenKey);
        return null;
      }

      print('✅ Token is valid');
      return token;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }
}
```

### 3. SignalR Service

```dart
class SignalRService {
  HubConnection? _connection;

  Future<void> connect(String token) async {
    try {
      _connection = HubConnectionBuilder()
          .withUrl(
            AppConstants.signalRHubUrl,
            HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      await _connection?.start();
      print('✅ SignalR connected');
    } catch (e) {
      print('❌ SignalR failed: $e');
      rethrow;
    }
  }
}
```

---

## Next Steps

1. **Add logging** to MSAL login handler
2. **Verify token is saved** after login
3. **Check token format** (should be JWT starting with "eyJ")
4. **Validate token expiry** with JWT decoder
5. **Test SignalR connection** separately
6. **Monitor AuthGate** to see where redirect happens
7. **Check API responses** for 401 errors

If still failing, share:
- Console logs from MSAL login
- Token validation response
- SignalR connection error
- AuthGate logs
