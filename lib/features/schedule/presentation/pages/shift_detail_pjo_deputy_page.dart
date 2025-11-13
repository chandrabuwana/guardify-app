import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../bloc/schedule_bloc.dart';
import '../../domain/entities/shift_schedule.dart';

/// Shift Detail Page for PJO & Deputy
///
/// Halaman detail shift khusus untuk PJO dan Deputy
/// dengan tampilan:
/// - Tab untuk Shift Pagi dan Shift Malam
/// - Total personil per shift
/// - Jam mulai dan selesai bekerja
/// - Lokasi per pos (Pos Gajah, Pos Merpati, Pos Ayam)
/// - Tim jaga dengan route assignment
class ShiftDetailPJODeputyPage extends StatefulWidget {
  final String userId;
  final DateTime date;

  const ShiftDetailPJODeputyPage({
    super.key,
    required this.userId,
    required this.date,
  });

  @override
  State<ShiftDetailPJODeputyPage> createState() =>
      _ShiftDetailPJODeputyPageState();
}

class _ShiftDetailPJODeputyPageState extends State<ShiftDetailPJODeputyPage>
    with SingleTickerProviderStateMixin {
  bool _hasLoadedData = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          // Load shift detail when first built
          if (!_hasLoadedData && !state.isLoadingDetail) {
            _hasLoadedData = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ScheduleBloc>().add(LoadScheduleDetail(
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
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
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
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today,
                        size: 64.r, color: Colors.white70),
                    SizedBox(height: 16.h),
                    Text(
                      'Tidak ada jadwal shift',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            SizedBox(height: 16.h),

            // Date Display
            _buildDateDisplay(),
            SizedBox(height: 24.h),

            // Content Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                ),
                child: Column(
                  children: [
                    // Tabs
                    _buildTabs(),

                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildShiftContent(shift, 'Pagi'),
                          _buildShiftContent(shift, 'Malam'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'Jadwal Kerja',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          SizedBox(width: 48.w), // Balance for back button
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Column(
      children: [
        Icon(
          Icons.calendar_month,
          color: Colors.white,
          size: 48.r,
        ),
        SizedBox(height: 8.h),
        Text(
          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(widget.date),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: TabBar(
        controller: _tabController,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: primaryColor,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Shift Pagi'),
          Tab(text: 'Shift Malam'),
        ],
      ),
    );
  }

  Widget _buildShiftContent(ShiftSchedule shift, String shiftType) {
    // Simulasi data - nanti akan diambil dari API based on shiftType
    final totalPersonil = shift.teamMembers.length;
    final jamMulai = shiftType == 'Pagi' ? '07.00 WIB' : '19.00 WIB';
    final jamSelesai = shiftType == 'Pagi' ? '19.00 WIB' : '07.00 WIB';

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Cards
          Row(
            children: [
              Expanded(
                child: _buildInfoCard('Total Personil', '$totalPersonil Orang'),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: _buildInfoCard('Jam Mulai Bekerja', jamMulai),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildInfoCard('Jam Selesai Bekerja', jamSelesai),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Lokasi Sections
          ...shift.patrolLocations.map((location) {
            return Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: _buildLocationSection(location, shift.teamMembers),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(
      PatrolLocation location, List<TeamMember> allMembers) {
    // Filter team members untuk lokasi ini (simulasi)
    final locationMembers = allMembers.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lokasi : ${location.name}',
          style: TextStyle(
            color: primaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        Text(
          'Tim Jaga',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),

        // Team Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          itemCount: locationMembers.length,
          itemBuilder: (context, index) {
            final member = locationMembers[index];
            return _buildTeamMemberCard(member);
          },
        ),
      ],
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage:
                member.photoUrl != null ? NetworkImage(member.photoUrl!) : null,
            backgroundColor: Colors.grey.shade300,
            child: member.photoUrl == null
                ? Icon(Icons.person, size: 24.r, color: Colors.grey.shade600)
                : null,
          ),
          SizedBox(height: 8.h),
          Text(
            member.name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            member.position,
            style: TextStyle(
              fontSize: 10.sp,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement kirim pesan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
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
  }
}
