part of 'test_result_bloc.dart';

/// Base event class for Test Result
abstract class TestResultEvent extends Equatable {
  const TestResultEvent();

  @override
  List<Object?> get props => [];
}

/// Event untuk load hasil Test
class FetchTestResultEvent extends TestResultEvent {
  final String userId;
  final UserRole role;

  const FetchTestResultEvent({
    required this.userId,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, role];
}

/// Event untuk search hasil Test
class SearchTestEvent extends TestResultEvent {
  final String query;

  const SearchTestEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event untuk filter hasil Test berdasarkan jabatan
class FilterTestByJabatanEvent extends TestResultEvent {
  final String? jabatan;

  const FilterTestByJabatanEvent(this.jabatan);

  @override
  List<Object?> get props => [jabatan];
}

/// Event untuk refresh data
class RefreshTestResultEvent extends TestResultEvent {
  final String userId;
  final UserRole role;

  const RefreshTestResultEvent({
    required this.userId,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, role];
}

/// Event untuk switch tab
class SwitchTestTabEvent extends TestResultEvent {
  final int tabIndex;

  const SwitchTestTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

