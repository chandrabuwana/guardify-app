# Schedule Module - Jadwal Kerja

## Overview
Modul Schedule mengelola jadwal kerja shift untuk security personnel dengan fitur calendar view, detail shift, dan informasi tim jaga.

**Module ini memiliki 2 varian UI berdasarkan role:**
1. **SchedulePage** (untuk Anggota & Danton): Tampilan dengan tab "Jadwal Saya" dan "Jadwal Anggota"
2. **SchedulePJODeputyPage** (untuk PJO & Deputy): Tampilan kalender saja tanpa tab, fokus operasional

## Features

### SchedulePage (Anggota & Danton)
- 📅 **Calendar View**: Tampilan kalender bulanan dengan indikator shift
- 📋 **Agenda Esok Hari**: Preview jadwal untuk persiapan shift berikutnya
- 👥 **Detail Tim Jaga**: Informasi lengkap anggota tim dan pembagian rute
- 📍 **Lokasi Patroli**: Detail pos-pos yang harus dipatroli (Pos Merak, Pos Gajah, Pos Merpati)
- 💬 **Kirim Pesan**: Fitur koordinasi dengan anggota tim (via chat integration)
- 📑 **Tab Navigation**: Switch antara "Jadwal Saya" dan "Jadwal Anggota"

### SchedulePJODeputyPage (PJO & Deputy)
- 📅 **Calendar View**: Tampilan kalender bulanan dengan indikator shift
- 🔄 **Shift Tabs**: Tab "Shift Pagi" dan "Shift Malam" pada detail
- 📊 **Total Personil**: Overview jumlah personil per shift
- 🕐 **Jam Kerja**: Informasi waktu kerja (Pagi: 07:00-19:00, Malam: 19:00-07:00)
- 📍 **Lokasi Operasional**: Detail pos jaga (Pos Gajah, Pos Merpati, Pos Ayam)
- 👥 **Tim Jaga Grid**: Grid view anggota tim dengan posisi tugas

## User Role Access & UI Routing

### ✅ Anggota (AGT) → SchedulePage
- Dapat melihat jadwal shift **pribadi**
- Akses: Tab "Jadwal Saya" only (tab "Jadwal Anggota" tersedia tapi kosong untuk AGT)
- View: Calendar dengan detail shift personal

### ✅ Danton (Komandan Regu) → SchedulePage
- Dapat melihat jadwal shift **pribadi dan tim**
- Akses: Tab "Jadwal Saya" dan "Jadwal Anggota"
- View: Full team schedule dengan detail roster

### ✅ PJO (Petugas Jaga) → SchedulePJODeputyPage
- Dapat melihat jadwal shift **operasional**
- Akses: Calendar view langsung tanpa tab personal/anggota
- View: Operational shift schedule dengan detail Pagi/Malam

### ✅ Deputy (DPT) → SchedulePJODeputyPage
- Dapat melihat jadwal shift **pribadi dan tim operasional**
- Akses: Calendar view langsung tanpa tab personal/anggota
- View: Operational team schedule dengan detail Pagi/Malam

**Role Detection**: 
```dart
// In main.dart '/schedule' route
final roleId = await SecurityManager.readSecurely('user_role_id');
if (roleId == 'PJO' || roleId == 'DPT') {
  return SchedulePJODeputyPage();
}
return SchedulePage(); // For AGT & Danton
```
- Akses: "Jadwal Saya" dan "Jadwal Anggota" tabs
- View: Full team schedule dengan detail roster

## Architecture

### Domain Layer
```
lib/features/schedule/domain/
├── entities/
│   └── shift_schedule.dart      # ShiftSchedule, DailyAgenda, PatrolLocation, TeamMember
├── repositories/
│   └── schedule_repository.dart # Abstract repository contract
└── usecases/
    ├── get_monthly_schedule.dart
    ├── get_daily_agenda.dart
    └── get_shift_detail.dart
```

### Data Layer
```
lib/features/schedule/data/
├── datasources/
│   └── schedule_remote_data_source.dart  # Mock data (ready for @RestApi migration)
├── models/
│   └── shift_schedule_model.dart         # @JsonSerializable models
└── repositories/
    └── schedule_repository_impl.dart     # Repository implementation
```

### Presentation Layer
```
lib/features/schedule/presentation/
├── bloc/
│   ├── schedule_bloc.dart        # @injectable BLoC
│   ├── schedule_event.dart       # Events: LoadMonthlySchedule, LoadDailyAgenda, LoadShiftDetail
│   └── schedule_state.dart       # State with schedules, dailyAgendas, selectedShift
├── pages/
│   ├── schedule_page.dart        # Main schedule page with calendar
│   └── shift_detail_page.dart    # Shift detail with team roster
└── widgets/
    └── shift_info_card.dart      # Reusable shift card component
```

## Navigation

### Entry Point
```dart
// From bottom navigation bar (index 1 - Kalender)
Navigator.pushNamed(context, '/schedule');

// Route configuration in main.dart:
'/schedule': (context) => BlocProvider(
  create: (context) => getIt<ScheduleBloc>(),
  child: const SchedulePage(),
),
```

### To Shift Detail
```dart
// From calendar day tap or agenda card
final scheduleBloc = context.read<ScheduleBloc>();

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: scheduleBloc,
      child: ShiftDetailPage(
        userId: userId,
        date: selectedDate,
      ),
    ),
  ),
);
```

## State Management

### BLoC Events
```dart
// Load monthly schedule
LoadMonthlySchedule(userId: String, year: int, month: int)

// Load daily agenda
LoadDailyAgenda(userId: String, year: int, month: int)

// Load shift detail
LoadShiftDetail(userId: String, date: DateTime)
```

### BLoC State
```dart
class ScheduleState {
  final bool isLoading;
  final bool isLoadingDetail;
  final List<ShiftSchedule> schedules;
  final ShiftSchedule? selectedShift;
  final List<DailyAgenda> dailyAgendas;
  final String? error;
  final int selectedYear;
  final int selectedMonth;
}
```

## Mock Data (Development)

Currently using mock data for September 2025:
- **Shift Types**: Shift Pagi (07:00 WIB), Shift Malam (19:00 WIB)
- **Locations**: Pos Merak, Pos Gajah, Pos Merpati
- **Routes**: Route A, Route B, Route BB, Route AN, Route C, Route D, etc.
- **Team Members**: 6 members with profile images and route assignments

### Ready for API Integration
All data sources are structured to easily migrate to real API:
1. Comment out mock implementation in `schedule_remote_data_source.dart`
2. Uncomment `@RestApi()` annotations
3. Add API endpoints:
   - `GET /Schedule/monthly`
   - `GET /Schedule/detail`
   - `GET /Schedule/agenda`
4. Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`

## Dependencies

- `table_calendar: ^3.1.2` - Calendar widget
- `flutter_bloc: ^9.1.1` - State management
- `injectable: ^2.3.2` - Dependency injection
- `intl` - Date formatting (Indonesian locale)

## Usage Example

```dart
// In HomePage or any parent widget with navigation
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/schedule');
  },
  child: Text('Lihat Jadwal'),
)

// Or from bottom navigation
CustomBottomNavigation(
  currentIndex: 1, // Kalender tab
  onTap: (index) {
    if (index == 1) {
      // Will navigate to /schedule via HomeBloc
      context.read<HomeBloc>().add(BottomNavigationTappedEvent(index));
    }
  },
)
```

## Testing

```dart
// Unit test example for ScheduleBloc
void main() {
  group('ScheduleBloc Tests', () {
    late ScheduleBloc scheduleBloc;
    
    setUp(() {
      scheduleBloc = getIt<ScheduleBloc>();
    });
    
    test('should load monthly schedule', () {
      scheduleBloc.add(LoadMonthlySchedule(
        userId: 'test_user',
        year: 2025,
        month: 9,
      ));
      
      expect(scheduleBloc.stream, emitsInOrder([
        isA<ScheduleState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ScheduleState>().having((s) => s.schedules, 'schedules', isNotEmpty),
      ]));
    });
  });
}
```

## Future Enhancements

- [ ] Real-time sync with backend API
- [ ] Push notifications for shift reminders
- [ ] Shift swap/trade functionality
- [ ] Export schedule to PDF/calendar apps
- [ ] Attendance integration from schedule
- [ ] Multi-month view
- [ ] Search/filter by location or team member

## Notes

- All dates use Indonesian locale (`id_ID`)
- Mock data covers September 2025 (current development timeline)
- Design follows Guardify App design system (primary color: #B71C1C)
- Responsive using `flutter_screenutil` (design size: 375x812)
