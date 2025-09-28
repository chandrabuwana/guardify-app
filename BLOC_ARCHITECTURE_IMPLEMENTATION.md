# BLoC Architecture Implementation - Home Feature

## Overview
Telah berhasil mengimplementasikan pola BLoC (Business Logic Component) yang konsisten untuk seluruh fitur pada home screen, menggantikan penggunaan `setState` dan logika bisnis langsung di UI layer.

## Struktur BLoC yang Diimplementasikan

### 1. Home Events (home_event.dart)
```dart
// Core Events
- HomeInitialEvent: Inisialisasi home screen
- BottomNavigationTappedEvent: Navigasi bottom bar
- ShowSnackbarEvent: Menampilkan notifikasi
- PanicButtonPressedEvent: Tombol emergency

// Attendance Events  
- AttendanceToggleEvent: Toggle check in/out
- AttendanceCheckInEvent: Check in spesifik
- AttendanceCheckOutEvent: Check out spesifik

// Navigation Events (untuk semua menu)
- NavigateToActivityReportEvent
- NavigateToIncidentReportEvent  
- NavigateToAttendanceRecapEvent
- NavigateToBMIEvent
- NavigateToTestResultEvent
- NavigateToLeaveRequestEvent
- NavigateToRegulationsEvent
- NavigateToEmergencyHistoryEvent
- NavigateToDisasterInfoEvent

// Tasks Events
- LoadTodayTasksEvent: Memuat tugas hari ini
- TaskProgressUpdateEvent: Update progress tugas

// Profile Events
- LoadUserProfileEvent: Memuat profil user
- UpdateUserProfileEvent: Update profil user
```

### 2. Home State (home_state.dart)
```dart
// Data Models
- TaskItem: Model untuk tugas harian
- UserProfile: Model untuk profil pengguna  
- AttendanceInfo: Model untuk info absensi

// State Classes
- HomeInitial: State awal
- HomeLoading: State loading
- HomeLoaded: State utama dengan data lengkap
- HomeError: State error handling
```

### 3. Home BLoC (home_bloc.dart)
**Event Handlers:**
- `_onHomeInitial`: Inisialisasi data awal
- `_onAttendanceToggle`: Mengelola check in/out
- `_onNavigateToXXX`: Handler untuk setiap menu navigation
- `_onLoadTodayTasks`: Memuat tugas dari API/local
- `_onTaskProgressUpdate`: Update progress tugas
- `_onUpdateUserProfile`: Update data profil

**Helper Methods:**
- `_getGreeting()`: Generate greeting berdasarkan waktu
- `_getCurrentTime()`: Format waktu saat ini
- `_getInitialTasks()`: Data dummy tugas awal

### 4. UI Integration (home_page.dart)
**BlocConsumer Implementation:**
```dart
BlocConsumer<HomeBloc, HomeState>(
  listener: (context, state) {
    // Handle side effects:
    // - Snackbar messages
    // - Navigation routing  
    // - Dialog management
  },
  builder: (context, state) {
    // Render UI berdasarkan state
  },
)
```

## Benefits dari Implementasi BLoC

### ✅ **Separation of Concerns**
- UI layer hanya menangani rendering
- Business logic terpisah di BLoC
- Data models terdefinisi dengan jelas

### ✅ **State Management yang Reaktif**  
- Semua state changes melalui events
- Immutable state objects
- Predictable state transitions

### ✅ **Testability**
- BLoC dapat di-unit test secara terpisah
- Mock-able dependencies  
- Event-driven testing

### ✅ **Scalability**
- Mudah menambah events dan states baru
- Reusable business logic
- Konsisten dengan arsitektur project

### ✅ **Debugging**
- State changes dapat di-track
- Event history untuk debugging
- Clear data flow

## Migration dari setState ke BLoC

### Before (setState approach):
```dart
setState(() {
  isCheckedIn = !isCheckedIn;
});
```

### After (BLoC approach):
```dart
context.read<HomeBloc>().add(const AttendanceToggleEvent());
```

### Before (Direct navigation):
```dart  
Navigator.pushNamed(context, '/bmi', arguments: {...});
```

### After (BLoC-managed navigation):
```dart
context.read<HomeBloc>().add(const NavigateToBMIEvent());
// Navigation handled in BlocConsumer listener
```

## Data Flow Architecture

1. **UI Trigger** → User interaksi (tap, swipe, etc.)
2. **Event Dispatch** → `context.read<HomeBloc>().add(Event())`
3. **BLoC Processing** → Business logic execution  
4. **State Emission** → `emit(newState)`
5. **UI Update** → `BlocBuilder` rebuilds UI
6. **Side Effects** → `BlocListener` handles navigation/snackbars

## File Structure
```
lib/features/home/presentation/
├── bloc/
│   ├── home_event.dart     # Semua events
│   ├── home_state.dart     # State + Models  
│   └── home_bloc.dart      # Business logic
├── pages/
│   └── home_page.dart      # UI dengan BlocConsumer
└── widgets/
    ├── home_header_widget.dart
    ├── attendance_card_widget.dart  
    ├── today_tasks_card_widget.dart
    ├── menu_grid_widget.dart
    └── sos_button_widget.dart
```

## Testing Strategy
```dart
// Unit Tests untuk BLoC
blocTest<HomeBloc, HomeState>(
  'should emit attendance checked in when AttendanceToggleEvent',
  build: () => HomeBloc(),
  act: (bloc) => bloc.add(const AttendanceToggleEvent()),
  expect: () => [
    isA<HomeLoaded>().having(
      (state) => state.attendanceInfo.isCheckedIn,
      'isCheckedIn',
      true,
    ),
  ],
);
```

Implementasi ini telah memastikan seluruh home screen menggunakan pola BLoC yang konsisten dengan arsitektur project, menghilangkan penggunaan `setState` dan direct navigation calls.