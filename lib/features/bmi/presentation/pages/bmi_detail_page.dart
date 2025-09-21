import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/constants/enums.dart';
import '../bloc/bmi_bloc.dart';

/// Page detail untuk melihat profil dan BMI user (untuk role non-anggota)
class BMIDetailPage extends StatefulWidget {
  final dynamic userProfile;
  final UserRole currentUserRole;

  const BMIDetailPage({
    Key? key,
    required this.userProfile,
    required this.currentUserRole,
  }) : super(key: key);

  @override
  State<BMIDetailPage> createState() => _BMIDetailPageState();
}

class _BMIDetailPageState extends State<BMIDetailPage> {
  BMIBloc get _bmiBloc => context.read<BMIBloc>();

  @override
  void initState() {
    super.initState();
    _loadBMIHistory();
  }

  void _loadBMIHistory() {
    _bmiBloc.add(BMILoadHistory(widget.userProfile.id));
  }

  Color _getBMIStatusColor(BMIStatus? status) {
    if (status == null) return neutral50;

    switch (status) {
      case BMIStatus.underweight:
        return const Color(0xFF2196F3);
      case BMIStatus.normal:
        return successColor;
      case BMIStatus.overweight:
        return const Color(0xFFFF9800);
      case BMIStatus.obese:
        return errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail BMI',
          style: TS.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: white,
        elevation: 0,
      ),
      body: BlocBuilder<BMIBloc, BMIState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: REdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Card
                _buildUserProfileCard(),

                20.verticalSpace,

                // Action Button
                _buildActionButton(),

                24.verticalSpace,

                // BMI History Section
                _buildBMIHistorySection(state.bmiHistory),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileCard() {
    final userProfile = widget.userProfile;
    final hasData = userProfile.currentBMI != null;
    final bmiStatus = userProfile.currentBMIStatus;
    final statusColor = _getBMIStatusColor(bmiStatus);

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: hasData
            ? LinearGradient(
                colors: [
                  statusColor.withOpacity(0.1),
                  statusColor.withOpacity(0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [neutral10, neutral5],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: hasData ? statusColor.withOpacity(0.3) : neutral30,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Profile Header
          Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                  border: Border.all(
                      color: primaryColor.withOpacity(0.3), width: 2),
                ),
                child: userProfile.profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          userProfile.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 40.w,
                              color: primaryColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40.w,
                        color: primaryColor,
                      ),
              ),
              20.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name,
                      style: TS.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: neutral90,
                      ),
                    ),
                    8.verticalSpace,
                    Container(
                      padding:
                          REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            Border.all(color: primaryColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        userProfile.role.displayName,
                        style: TS.labelMedium.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          24.verticalSpace,

          if (hasData) ...[
            // BMI Status Badge
            Container(
              padding: REdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24.r),
                border:
                    Border.all(color: statusColor.withOpacity(0.4), width: 1.5),
              ),
              child: Text(
                bmiStatus!.label.toUpperCase(),
                style: TS.titleMedium.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            20.verticalSpace,

            // BMI Value
            Text(
              'BMI ${userProfile.currentBMI!.toStringAsFixed(1)} Kg/M2',
              style: TS.displaySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            20.verticalSpace,

            // Weight and Height Info
            Container(
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Berat Badan',
                      '${userProfile.currentWeight!.toStringAsFixed(1)} KG',
                      Icons.monitor_weight_outlined,
                      statusColor,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                    margin: REdgeInsets.symmetric(horizontal: 20),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Tinggi Badan',
                      '${userProfile.height!.toStringAsFixed(0)} CM',
                      Icons.height_outlined,
                      statusColor,
                    ),
                  ),
                ],
              ),
            ),

            if (userProfile.lastUpdated != null) ...[
              20.verticalSpace,
              Container(
                padding: REdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.update_outlined,
                      size: 16.w,
                      color: statusColor,
                    ),
                    8.horizontalSpace,
                    Text(
                      'Terakhir diperbarui: ${_formatDate(userProfile.lastUpdated!)}',
                      style: TS.bodyMedium.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            // No Data State
            Icon(
              Icons.scale_outlined,
              size: 64.w,
              color: neutral50,
            ),
            20.verticalSpace,
            Text(
              'Belum ada data BMI',
              style: TS.titleLarge.copyWith(
                color: neutral70,
                fontWeight: FontWeight.w600,
              ),
            ),
            12.verticalSpace,
            Text(
              'Hitung BMI untuk melihat status kesehatan',
              style: TS.bodyLarge.copyWith(
                color: neutral50,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: REdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24.w,
            color: color,
          ),
        ),
        12.verticalSpace,
        Text(
          label,
          style: TS.bodyMedium.copyWith(
            color: neutral70,
            fontWeight: FontWeight.w500,
          ),
        ),
        6.verticalSpace,
        Text(
          value,
          style: TS.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: neutral90,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    // Removed BMI calculation since data comes from API
    // Just show a placeholder or remove the button entirely
    return const SizedBox.shrink();
  }

  Widget _buildBMIHistorySection(List bmiHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Riwayat BMI',
                style: TS.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: neutral90,
                ),
              ),
            ),
            if (bmiHistory.isNotEmpty)
              Text(
                '${bmiHistory.length} catatan',
                style: TS.bodyMedium.copyWith(
                  color: neutral50,
                ),
              ),
          ],
        ),
        16.verticalSpace,
        if (bmiHistory.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(32),
            decoration: BoxDecoration(
              color: neutral10,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: neutral30),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history_outlined,
                  size: 64.w,
                  color: neutral50,
                ),
                20.verticalSpace,
                Text(
                  'Belum ada riwayat BMI',
                  style: TS.titleMedium.copyWith(
                    color: neutral70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                12.verticalSpace,
                Text(
                  'Mulai hitung BMI untuk melihat riwayat perkembangan',
                  style: TS.bodyMedium.copyWith(
                    color: neutral50,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ] else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bmiHistory.length,
            separatorBuilder: (context, index) => 16.verticalSpace,
            itemBuilder: (context, index) {
              final record = bmiHistory[index];
              return _buildBMIHistoryItem(record, index == 0);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildBMIHistoryItem(dynamic record, bool isLatest) {
    final statusColor = _getBMIStatusColor(record.status);

    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isLatest ? primaryColor.withOpacity(0.3) : neutral30,
          width: isLatest ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isLatest
                ? primaryColor.withOpacity(0.1)
                : neutral50.withOpacity(0.05),
            blurRadius: isLatest ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              // Status Indicator
              Container(
                width: 6.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),

              16.horizontalSpace,

              // BMI Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'BMI ${record.bmi.toStringAsFixed(1)}',
                          style: TS.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        12.horizontalSpace,
                        Container(
                          padding: REdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border:
                                Border.all(color: statusColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            record.status.label,
                            style: TS.labelMedium.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isLatest) ...[
                          8.horizontalSpace,
                          Container(
                            padding: REdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'TERBARU',
                              style: TS.labelSmall.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    8.verticalSpace,
                    Text(
                      '${record.weight.toStringAsFixed(1)} kg • ${record.height.toStringAsFixed(0)} cm',
                      style: TS.bodyLarge.copyWith(
                        color: neutral70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(record.recordedAt),
                    style: TS.bodyMedium.copyWith(
                      color: neutral50,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    _formatTime(record.recordedAt),
                    style: TS.bodySmall.copyWith(
                      color: neutral50,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (record.notes != null && record.notes.isNotEmpty) ...[
            16.verticalSpace,
            Container(
              width: double.infinity,
              padding: REdgeInsets.all(12),
              decoration: BoxDecoration(
                color: neutral10,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: neutral30),
              ),
              child: Text(
                record.notes,
                style: TS.bodyMedium.copyWith(
                  color: neutral70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
