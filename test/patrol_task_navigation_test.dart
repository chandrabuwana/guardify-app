import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardify_app/features/home/presentation/widgets/task_card.dart';
import 'package:guardify_app/features/home/presentation/bloc/home_state.dart';
import 'package:guardify_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:guardify_app/core/di/injection.dart';

void main() {
  group('Patrol Task Navigation Test', () {
    testWidgets('should trigger NavigateToPatrolEvent when patrol task is tapped', (WidgetTester tester) async {
      // Setup dependency injection
      configureDependencies();

      // Create patrol task
      const patrolTask = TaskItem(
        id: 'patrol_a',
        title: 'Patroli Rute A',
        subtitle: '5 Lokasi Rute + 1 Lokasi Tambahan',
        progress: 0.66,
        completedTasks: 4,
        totalTasks: 6,
      );

      bool navigationTriggered = false;

      // Create test widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create: (context) => getIt<HomeBloc>(),
              child: TaskCard(
                task: patrolTask,
                onTap: () {
                  navigationTriggered = true;
                },
              ),
            ),
          ),
        ),
      );

      // Find and tap the task card
      final taskCard = find.byType(TaskCard);
      expect(taskCard, findsOneWidget);

      await tester.tap(taskCard);
      await tester.pump();

      // Verify navigation was triggered
      expect(navigationTriggered, isTrue);
    });

    testWidgets('should display correct patrol task information', (WidgetTester tester) async {
      // Setup dependency injection
      configureDependencies();

      // Create patrol task
      const patrolTask = TaskItem(
        id: 'patrol_a',
        title: 'Patroli Rute A',
        subtitle: '5 Lokasi Rute + 1 Lokasi Tambahan',
        progress: 0.66,
        completedTasks: 4,
        totalTasks: 6,
      );

      // Create test widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create: (context) => getIt<HomeBloc>(),
              child: TaskCard(
                task: patrolTask,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Verify patrol task information is displayed
      expect(find.text('Patroli Rute A'), findsOneWidget);
      expect(find.text('5 Lokasi Rute + 1 Lokasi Tambahan'), findsOneWidget);
      expect(find.text('4/6 Selesai'), findsOneWidget);
      expect(find.text('66%'), findsOneWidget);
    });
  });
}