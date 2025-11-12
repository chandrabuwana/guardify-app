# Guardify App - AI Agent Instructions

## Project Overview
Flutter security personnel management app with **Clean Architecture + BLoC pattern**. Features: authentication, scheduling, patrol tracking, leave management, chat, and assessment tracking.

## Architecture & Patterns

### Clean Architecture Structure
```
features/<feature_name>/
├── data/           # API calls, models (@JsonSerializable), repository impl
├── domain/         # Entities, repository contracts, use cases
└── presentation/   # BLoC (@injectable), pages, widgets
```

**Critical Rules:**
- Domain layer has NO dependencies on data/presentation
- Data models use `@JsonSerializable()` + code generation (`.g.dart` files)
- Repository implementations bridge data ↔ domain layers
- All BLoCs/repositories/use cases use `@injectable`, `@LazySingleton(as: Interface)` for DI

### Dependency Injection
- **GetIt + Injectable**: All services registered in `lib/core/di/injection.dart`
- Call `await configureDependencies()` in `main()` before `runApp()`
- BLoCs provided via `BlocProvider(create: (context) => getIt<FooBloc>())`
- After adding `@injectable` annotations, run: `flutter pub run build_runner build --delete-conflicting-outputs`

### State Management (BLoC)
- **Events**: User actions (e.g., `LoadMonthlySchedule`, `SubmitLeaveRequest`)
- **States**: Immutable snapshots with `isLoading`, `data`, `error` fields
- Navigate with existing BLoC: `BlocProvider.value(value: bloc, child: NextPage())`
- Create new BLoC for routes: Use `getIt<Bloc>()` in route definitions (`main.dart`)

## API Integration

### Network Layer
- **Base URL**: `https://api-guardify.abb-apps.com/api/v1`
- **Auth**: `Authorization: Bearer <token>` (auto-injected by `NetworkManager`)
- **Response Format**: `{ "Code": 200, "Succeeded": true, "Data": {...}, "Message": "...", "Description": "..." }`
- **Token Storage**: `SecurityManager.storeSecurely(AppConstants.tokenKey, token)`

### API Response Handling Pattern
```dart
// 1. Check Succeeded flag first
if (!response.succeeded || response.data == null) {
  return Result.failure(ServerFailure(response.message));
}

// 2. Map data model to entity
final entity = response.data!.toEntity();

// 3. Return success result
return Result.success(entity);
```

### Code Generation Workflow
1. Add models with `@JsonSerializable()` and `part 'file.g.dart';`
2. Use `@JsonKey(name: 'ApiFieldName')` for field mapping (API uses PascalCase)
3. Run: `flutter pub run build_runner build --delete-conflicting-outputs`
4. Generated `.g.dart` files handle JSON serialization

## Security & Authentication

### Secure Storage
- **FlutterSecureStorage** via `SecurityManager` for sensitive data
- Key constants in `AppConstants`: `tokenKey`, `refreshTokenKey`, `userIdKey`, `user_role_id`
- Always read user context from storage: `await SecurityManager.readSecurely('user_role_id')`

### Role-Based Access (UserRole enum)
- **IDs**: `AGT` (Anggota), `DTN` (Danton), `PJO` (PJO), `DPT` (Deputy), `PGW` (Pengawas), `ADM` (Admin)
- Use `UserRole.fromValue(roleId)` to parse from storage
- Example: Schedule routes differently for PJO/Deputy vs Anggota/Danton (see `main.dart` route `/schedule`)

## Development Workflows

### Running the App
```powershell
# First time setup
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Clean build (if issues)
flutter clean; flutter pub get; flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing
- Tests in `test/` directory use `configureDependencies()` for DI setup
- Mock `SharedPreferences` MethodChannel in `setUpAll()` (see `patrol_dependencies_test.dart`)
- Run: `flutter test` or `flutter test --coverage`

### Code Generation Triggers
Run code generation after:
- Adding/modifying `@JsonSerializable` models
- Adding/modifying `@injectable` classes
- Adding `@RestApi` endpoints (Retrofit)

## Common Patterns

### Navigation with Routes
- All routes defined in `main.dart` `routes` map
- Pass arguments: `Navigator.pushNamed(context, '/route', arguments: {'key': value})`
- Retrieve: `ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?`

### Error Handling
- Use custom failure classes: `AuthenticationFailure`, `ServerFailure`, `NetworkFailure`
- User-friendly messages: For security, show generic "Username atau password salah" for all 4xx auth errors
- Log detailed errors but show simplified messages to users

### UI Conventions
- **Design Size**: 375x812 (iPhone 11 Pro) with `flutter_screenutil`
- **Primary Color**: `#E74C3C` (red for security/emergency context)
- **Date Formatting**: Indonesian locale (`id_ID`) - initialize in `main()` with `initializeDateFormatting('id_ID')`
- Bottom navigation: 5 items (Beranda, Kalender, Tugas, Chat, Akun)

### Shared Widgets
Located in `lib/shared/widgets/`:
- `custom_bottom_navigation.dart`: Bottom nav bar
- `confirm_dialog.dart`: Confirmation dialogs
- `red_card_widget.dart`: Emergency/alert cards
- `upload_photo_field.dart`: Photo upload with validation

## Key Features

### Schedule Module
- **Two variants**: `SchedulePage` (Anggota/Danton) vs `SchedulePJODeputyPage` (PJO/Deputy)
- **Routing logic**: Check `user_role_id` to determine which page (see `main.dart` `/schedule`)
- Uses `table_calendar` with mock data (ready for API integration)

### Authentication
- Login stores: token, refresh token, user ID, username, full name, role ID/name
- **Logout**: Clear ALL secure storage keys (see `AuthRepositoryImpl.logout()`)
- Role-based routing: Different home screens per role

### Mock Data Strategy
- Many modules use mock data sources (marked with comments like `// Mock data - ready for @RestApi`)
- API-ready: Comment out mock, uncomment `@RestApi()`, add endpoints, run code generation

## Files to Check for Patterns
- **DI Setup**: `lib/core/di/injection.dart`
- **Network**: `lib/core/network/network_manager.dart`
- **Security**: `lib/core/security/security_manager.dart`
- **Enums**: `lib/core/constants/enums.dart` (UserRole, BMIStatus)
- **Example Feature**: `lib/features/schedule/` (complete Clean Architecture example)
- **Testing Example**: `test/patrol_dependencies_test.dart`

## Linting & Code Quality
- Follows `package:flutter_lints/flutter.yaml`
- **Excludes**: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.config.dart` from analysis
- Prefer `const` constructors, final fields, collection literals
- Avoid `print` in production (use `logger` package)
