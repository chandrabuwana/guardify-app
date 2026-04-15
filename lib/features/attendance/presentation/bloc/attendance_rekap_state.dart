import '../../domain/entities/attendance_rekap_entity.dart';

abstract class AttendanceRekapState {
  const AttendanceRekapState();
}

class AttendanceRekapInitial extends AttendanceRekapState {
  const AttendanceRekapInitial();
}

class AttendanceRekapLoading extends AttendanceRekapState {
  const AttendanceRekapLoading();
}

class AttendanceRekapLoaded extends AttendanceRekapState {
  final List<AttendanceRekapEntity> allItems;
  final List<AttendanceRekapEntity> filteredItems;
  final String? searchQuery;
  final String? statusFilter;
  final int count;
  final int filtered;

  const AttendanceRekapLoaded({
    required this.allItems,
    required this.filteredItems,
    this.searchQuery,
    this.statusFilter,
    required this.count,
    required this.filtered,
  });

  AttendanceRekapLoaded copyWith({
    List<AttendanceRekapEntity>? allItems,
    List<AttendanceRekapEntity>? filteredItems,
    String? searchQuery,
    String? statusFilter,
    int? count,
    int? filtered,
  }) {
    return AttendanceRekapLoaded(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      count: count ?? this.count,
      filtered: filtered ?? this.filtered,
    );
  }
}

class AttendanceRekapFailure extends AttendanceRekapState {
  final String message;

  const AttendanceRekapFailure(this.message);
}

