import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../bloc/schedule_bloc.dart';
import '../../domain/entities/shift_schedule.dart';

/// Shift Detail Page - Detail Jadwal Shift
///
/// Halaman detail yang menampilkan informasi lengkap shift termasuk:
/// - Informasi shift (nama, jam kerja, lokasi)
/// - Detail lokasi patroli (Pos Merak, Pos Gajah, Pos Merpati, dll)
/// - Daftar anggota tim jaga dengan pembagian rute
/// - Fitur "Kirim Pesan" untuk koordinasi tim
///
/// **Accessible by roles:**
/// - Anggota (AGT): Dapat melihat detail shift pribadi
/// - Danton: Dapat melihat detail shift tim
/// - PJO (Petugas Jaga): Dapat melihat detail shift operasional
/// - Deputy (DPT): Dapat melihat detail shift tim
class ShiftDetailPage extends StatefulWidget {
  final String userId;
  final DateTime date;

  const ShiftDetailPage({
    super.key,
    required this.userId,
    required this.date,
  });

  @override
  State<ShiftDetailPage> createState() => _ShiftDetailPageState();
}

class _ShiftDetailPageState extends State<ShiftDetailPage> {
  bool _hasLoadedData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          // Load shift detail when first built
          if (!_hasLoadedData && !state.isLoadingDetail) {
            _hasLoadedData = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ScheduleBloc>().add(LoadShiftDetail(
                    userId: widget.userId,
                    date: widget.date,
                  ));
            });
          }

          if (state.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.selectedShift == null) {
            return _buildEmptyState();
          }

          return _buildContent(state.selectedShift!);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primary50, primary50.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Jadwal Kerja',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Tidak ada jadwal untuk tanggal ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ShiftSchedule shift) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primary50, primary50.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header dengan AppBar
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Jadwal Kerja',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Calendar Icon dan Tanggal
            SizedBox(height: 16.h),
            Icon(
              Icons.calendar_month,
              size: 60.w,
              color: Colors.white,
            ),
            SizedBox(height: 12.h),
            Text(
              DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(shift.date),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 32.h),

            // Content Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nama Shift', shift.shiftName),
                      _buildInfoRow('Jam Mulai Bekerja', shift.shiftTime),
                      _buildInfoRow('Lokasi Jaga', shift.location),
                      _buildInfoRow('Rute Patroli', shift.route),

                      SizedBox(height: 24.h),

                      // Detail Lokasi Patroli
                      Text(
                        'Detail Lokasi Patroli',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: primary50,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildPatrolLocations(shift.patrolLocations),

                      SizedBox(height: 24.h),

                      // Tim Jaga
                      Text(
                        'Tim Jaga',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: primary50,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildTeamMembers(shift.teamMembers),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: primary50,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatrolLocations(List<PatrolLocation> locations) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: locations.map((location) {
        return Container(
          width: (MediaQuery.of(context).size.width - 64.w) / 3,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Icon(
                Icons.home_outlined,
                size: 32.w,
                color: primary50,
              ),
              SizedBox(height: 8.h),
              Text(
                location.type,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTeamMembers(List<TeamMember> members) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: members.map((member) {
        return Container(
          width: (MediaQuery.of(context).size.width - 64.w) / 3,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24.w,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: member.photoUrl != null
                    ? NetworkImage(member.photoUrl!)
                    : null,
                child: member.photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 24.w,
                        color: Colors.grey.shade600,
                      )
                    : null,
              ),
              SizedBox(height: 8.h),

              // Name
              Text(
                member.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),

              // Position
              Text(
                member.position,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: primary50,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),

              // Button Kirim Pesan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement send message
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary50,
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    'Kirim Pesan',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
