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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          'Detail Body Mass Index',
          style: TS.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: neutral90,
          ),
        ),
        backgroundColor: white,
        foregroundColor: neutral90,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<BMIBloc, BMIState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Card with BMI Info
                _buildUserProfileCard(),

                24.verticalSpace,

                // BMI History Section
                Padding(
                  padding: REdgeInsets.symmetric(horizontal: 16),
                  child: _buildBMIHistorySection(state.bmiHistory),
                ),

                24.verticalSpace,
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: hasData
            ? LinearGradient(
                colors: [
                  const Color(0xFFFFF5F5),
                  const Color(0xFFFFF9F9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : LinearGradient(
                colors: [neutral10, neutral5],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      child: Column(
        children: [
          32.verticalSpace,
          if (hasData) ...[
            // Profile Photo
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: neutral50.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: userProfile.profileImageUrl != null
                  ? ClipOval(
                      child: Image.network(
                        userProfile.profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: neutral20,
                            child: Icon(
                              Icons.person,
                              size: 60.w,
                              color: neutral50,
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      color: neutral20,
                      child: Icon(
                        Icons.person,
                        size: 60.w,
                        color: neutral50,
                      ),
                    ),
            ),

            24.verticalSpace,

            // BMI Status
            Text(
              bmiStatus!.label.toUpperCase(),
              style: TS.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C5F7C),
                letterSpacing: 1.2,
              ),
            ),

            16.verticalSpace,

            // BMI Value
            RichText(
              text: TextSpan(
                style: TS.titleLarge.copyWith(
                  color: const Color(0xFFB71C1C),
                ),
                children: [
                  const TextSpan(text: 'Your BMI is '),
                  TextSpan(
                    text: userProfile.currentBMI!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' Kg/M2'),
                ],
              ),
            ),

            32.verticalSpace,

            // Height, Weight, Updated Info
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'Height',
                      '${userProfile.height!.toStringAsFixed(0)} CM',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 60.h,
                    color: const Color(0xFFB71C1C).withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'Weight',
                      '${userProfile.currentWeight!.toStringAsFixed(0)} KG',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 60.h,
                    color: const Color(0xFFB71C1C).withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'Updated',
                      userProfile.lastUpdated != null
                          ? _formatDateShort(userProfile.lastUpdated!)
                          : '-',
                    ),
                  ),
                ],
              ),
            ),

            32.verticalSpace,

            // Recommendation Section
            Container(
              width: double.infinity,
              margin: REdgeInsets.symmetric(horizontal: 16),
              padding: REdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFB71C1C).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommendation',
                    style: TS.titleMedium.copyWith(
                      color: const Color(0xFF2C5F7C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    _getRecommendation(bmiStatus),
                    style: TS.bodyMedium.copyWith(
                      color: const Color(0xFFB71C1C),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            24.verticalSpace,
          ] else ...[
            // No Data State
            32.verticalSpace,
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
            32.verticalSpace,
          ],
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TS.bodyMedium.copyWith(
            color: const Color(0xFF2C5F7C),
            fontWeight: FontWeight.w500,
          ),
        ),
        8.verticalSpace,
        Text(
          value,
          style: TS.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB71C1C),
          ),
        ),
      ],
    );
  }

  String _getRecommendation(BMIStatus? status) {
    if (status == null) return '';

    switch (status) {
      case BMIStatus.underweight:
        return 'Increase calorie intake with nutritious foods. Consider consulting a nutritionist for a healthy weight gain plan.';
      case BMIStatus.normal:
        return 'Stay healthy, keep strong, happy tummy happy me. running, tanning, swimming, Let\'s exercise :)';
      case BMIStatus.overweight:
        return 'Maintain a balanced diet and regular exercise. Consider consulting a healthcare professional for personalized advice.';
      case BMIStatus.obese:
        return 'It\'s important to consult with a healthcare professional. Focus on gradual lifestyle changes with proper guidance.';
    }
  }

  String _formatDateShort(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildBMIHistorySection(List bmiHistory) {
    if (bmiHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bmiHistory.length > 1 ? bmiHistory.length - 1 : 0,
          separatorBuilder: (context, index) => 0.verticalSpace,
          itemBuilder: (context, index) {
            // Skip the first item (index 0) as it's shown in the main card
            final record = bmiHistory[index + 1];
            return _buildBMIHistoryItem(record);
          },
        ),
      ],
    );
  }

  Widget _buildBMIHistoryItem(dynamic record) {
    return Container(
      margin: REdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        border: Border(
          top: BorderSide(
            color: neutral30,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Left Section - Status and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.status.label,
                        style: TS.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C5F7C),
                        ),
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          SizedBox(
                            width: 50.w,
                            child: Text(
                              'Height',
                              style: TS.bodySmall.copyWith(
                                color: const Color(0xFFB71C1C),
                              ),
                            ),
                          ),
                          Text(
                            '${record.height.toStringAsFixed(0)} CM',
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB71C1C),
                            ),
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          SizedBox(
                            width: 50.w,
                            child: Text(
                              'Weight',
                              style: TS.bodySmall.copyWith(
                                color: const Color(0xFFB71C1C),
                              ),
                            ),
                          ),
                          Text(
                            '${record.weight.toStringAsFixed(0)} Kg',
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB71C1C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Section - BMI Value
                Text(
                  '${record.bmi.toStringAsFixed(1)} Kg/M2',
                  style: TS.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB71C1C),
                  ),
                ),
              ],
            ),
          ),

          // Recommendation Section
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(16),
            decoration: BoxDecoration(
              color: white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommendation',
                  style: TS.bodyMedium.copyWith(
                    color: const Color(0xFF2C5F7C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                Text(
                  _getRecommendation(record.status),
                  style: TS.bodySmall.copyWith(
                    color: const Color(0xFFB71C1C),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Updated Date
          Container(
            width: double.infinity,
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: white,
            ),
            child: Text(
              'Updated ${_formatDateShort(record.recordedAt)}',
              style: TS.bodySmall.copyWith(
                color: neutral50,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
