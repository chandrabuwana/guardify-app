import 'package:equatable/equatable.dart';

class PatrolProgress extends Equatable {
  final int completedCount;
  final int totalCount;
  final double percentage;

  const PatrolProgress({
    required this.completedCount,
    required this.totalCount,
  }) : percentage = totalCount > 0 ? (completedCount / totalCount) * 100 : 0;

  bool get isCompleted => completedCount == totalCount && totalCount > 0;

  @override
  List<Object?> get props => [completedCount, totalCount, percentage];
}