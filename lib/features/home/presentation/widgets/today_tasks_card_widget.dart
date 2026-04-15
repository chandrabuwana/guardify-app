import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/home_state.dart';

class TodayTasksCardWidget extends StatelessWidget {
  final List<TaskItem> tasks;
  final Function(String taskId)? onTaskTap;

  const TodayTasksCardWidget({
    super.key,
    required this.tasks,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: REdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tugas Hari Ini',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              16.verticalSpace,

              // Build tasks from BLoC state
              ...tasks
                  .map((task) => Padding(
                        padding: EdgeInsets.only(
                            bottom: tasks.indexOf(task) == tasks.length - 1
                                ? 0
                                : 12.h),
                        child: GestureDetector(
                          onTap: () => onTaskTap?.call(task.id),
                          child: _buildTaskItem(
                            id: task.id,
                            title: task.title,
                            subtitle: task.subtitle,
                            progress:
                                '${task.completedTasks}/${task.totalTasks} Selesai',
                            progressPercent: task.progress,
                            isCompleted: task.isCompleted,
                          ),
                        ),
                      ))
                  .toList(),

              // If no tasks, show empty state
              if (tasks.isEmpty)
                Center(
                  child: Padding(
                    padding: REdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 48.r,
                          color: Colors.grey[400],
                        ),
                        8.verticalSpace,
                        Text(
                          'Belum ada tugas hari ini',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem({
    required String id,
    required String title,
    required String subtitle,
    required String progress,
    required double progressPercent,
    required bool isCompleted,
  }) {
    return Container(
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${(progressPercent * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          8.verticalSpace,
          Text(
            progress,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          8.verticalSpace,
          // Progress bar
          Container(
            width: double.infinity,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: FractionallySizedBox(
              widthFactor: progressPercent,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
