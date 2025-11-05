part of 'schedule_bloc.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

class LoadMonthlySchedule extends ScheduleEvent {
  final String userId;
  final int year;
  final int month;

  const LoadMonthlySchedule({
    required this.userId,
    required this.year,
    required this.month,
  });
}

class LoadShiftDetail extends ScheduleEvent {
  final String userId;
  final DateTime date;

  const LoadShiftDetail({
    required this.userId,
    required this.date,
  });
}

class LoadDailyAgenda extends ScheduleEvent {
  final String userId;
  final int year;
  final int month;

  const LoadDailyAgenda({
    required this.userId,
    required this.year,
    required this.month,
  });
}

class ChangeMonth extends ScheduleEvent {
  final String userId;
  final int year;
  final int month;

  const ChangeMonth({
    required this.userId,
    required this.year,
    required this.month,
  });
}
