import 'package:flutter/material.dart';
import 'package:guardify_app/core/design/colors.dart';
import 'package:guardify_app/features/home/presentation/bloc/home_state.dart';

class ShiftCard extends StatelessWidget {
  final AttendanceInfo attendanceInfo;
  final List<String> teamMembersImages;
  final VoidCallback onWorkButtonPressed;

  const ShiftCard({
    super.key,
    required this.attendanceInfo,
    required this.teamMembersImages,
    required this.onWorkButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = attendanceInfo.isCheckedIn;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Shift Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(attendanceInfo.date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: neutral90,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      attendanceInfo.shift,
                      style: const TextStyle(
                        fontSize: 14,
                        color: neutral70,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCheckedIn ? successColor : primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCheckedIn ? 'Masuk' : 'Menunggu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Attendance Time Row
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: neutral50,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Jam Absen: ${attendanceInfo.currentTime}',
                style: const TextStyle(
                  fontSize: 14,
                  color: neutral70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Team Members Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tim Jaga',
                    style: TextStyle(
                      fontSize: 14,
                      color: neutral70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTeamAvatars(),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Work Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onWorkButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isCheckedIn ? 'Akhiri Bekerja' : 'Mulai Bekerja',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamAvatars() {
    return Row(
      children: [
        // Show up to 3 avatars
        ...List.generate(
          teamMembersImages.length > 3 ? 3 : teamMembersImages.length,
          (index) => Container(
            margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primary30,
              backgroundImage: teamMembersImages[index].isNotEmpty
                  ? NetworkImage(teamMembersImages[index])
                  : null,
              child: teamMembersImages[index].isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
        // Show +X if more than 3 members
        if (teamMembersImages.length > 3)
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: Text(
                '+${teamMembersImages.length - 3}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month]} ${date.year}';
  }
}
