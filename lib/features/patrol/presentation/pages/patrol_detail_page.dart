import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_location.dart';
import '../bloc/patrol_bloc.dart';
import '../bloc/attendance_bloc.dart';
import '../widgets/patrol_progress_widget.dart';
import 'attendance_form_page.dart';
import 'add_patrol_location_page.dart';

class PatrolDetailPage extends StatelessWidget {
  final PatrolRoute route;

  const PatrolDetailPage({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PatrolBloc>()
        ..add(SelectPatrolRoute(route.id))
        ..add(LoadPatrolProgress(route.id)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            'Patroli Hari Ini',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF8B1538),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: BlocBuilder<PatrolBloc, PatrolState>(
          builder: (context, state) {
            if (state is PatrolLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8B1538),
                ),
              );
            }

            if (state is PatrolError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final completedCount = route.locations
                .where((loc) => loc.status == PatrolLocationStatus.completed)
                .length;
            final totalCount = route.locations.length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Progress Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        PatrolProgressWidget(
                          completedCount: completedCount,
                          totalCount: totalCount,
                          size: 120,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          completedCount == totalCount && totalCount > 0
                              ? 'Patroli Selesai'
                              : 'Patroli Selesai',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B1538),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Route Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${route.name} (${route.locations.length} Lokasi)*',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location List
                  ...route.locations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final location = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _LocationCard(
                        location: location,
                        locationNumber: index + 1,
                        onAbsenTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => getIt<PatrolAttendanceBloc>(),
                                child: AttendanceFormPage(location: location),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Additional Patrol Section
                  if (route.additionalLocations.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Patroli Tambahan (${route.additionalLocations.length} Lokasi)*',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...route.additionalLocations.asMap().entries.map((entry) {
                      final location = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _LocationCard(
                          location: location,
                          locationNumber: route.locations.length + entry.key + 1,
                          onAbsenTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => getIt<PatrolAttendanceBloc>(),
                                  child: AttendanceFormPage(location: location),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],

                  // Add Location Button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddPatrolLocationPage(routeId: route.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1538),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '+ Tambah Lokasi Patroli',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Bottom padding
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final PatrolLocation location;
  final int locationNumber;
  final VoidCallback onAbsenTap;

  const _LocationCard({
    required this.location,
    required this.locationNumber,
    required this.onAbsenTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: location.status == PatrolLocationStatus.completed
                      ? Colors.blue[50]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  location.status == PatrolLocationStatus.completed
                      ? 'Selesai'
                      : 'Belum',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: location.status == PatrolLocationStatus.completed
                        ? Colors.blue[600]
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lokasi $locationNumber',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jam Patroli',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                location.completedAt != null
                                    ? '${location.completedAt!.hour.toString().padLeft(2, '0')}.${location.completedAt!.minute.toString().padLeft(2, '0')} WIB'
                                    : '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bukti Patroli',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                location.proofImagePath != null
                                    ? location.proofImagePath!
                                    : '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: location.proofImagePath != null
                                      ? const Color(0xFF8B1538)
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Absen Button
              ElevatedButton(
                onPressed: location.status == PatrolLocationStatus.completed
                    ? null
                    : onAbsenTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: location.status == PatrolLocationStatus.completed
                      ? Colors.grey[400]
                      : const Color(0xFF8B1538),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Absen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}