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
  bool _hasInitialLoad = false; // Flag untuk mencegah multiple initial loads

  @override
  void initState() {
    super.initState();
    _loadBMIHistory();
  }

  void _loadBMIHistory() {
    // Load user profile dengan data BMI dan history hanya sekali
    if (_hasInitialLoad) {
      print('⏭️ BMIDetailPage: Skip _loadBMIHistory - _hasInitialLoad=true');
      return; // Skip jika sudah pernah load
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      if (_hasInitialLoad) {
        print('⏭️ BMIDetailPage: Skip _loadBMIHistory - _hasInitialLoad=true (double check)');
        return; // Double check
      }
      
      final state = _bmiBloc.state;
      bool shouldLoadProfile = false;
      bool shouldLoadHistory = false;
      
      // Load user profile dengan data BMI (dari Bmi/list API)
      // Hanya load jika user berbeda atau belum ada BMI data dan tidak sedang loading
      // DAN belum ada profile untuk user ini di state
      if (state.currentUserProfile?.id != widget.userProfile.id) {
        // User berbeda atau belum ada profile
        if (!state.isLoading) {
          shouldLoadProfile = true;
        } else {
          print('⏭️ BMIDetailPage: Skip load profile - already loading');
        }
      } else {
        // Sudah ada profile untuk user ini
        print('⏭️ BMIDetailPage: Skip load profile - already has profile for user ${widget.userProfile.id}');
      }
      
      // Load BMI history hanya jika belum pernah load untuk user ini
      // Check: bmiHistoryUserId harus null atau berbeda dengan userProfile.id
      if (state.bmiHistoryUserId != widget.userProfile.id) {
        // Belum pernah load history untuk user ini
        if (!state.isLoading) {
          shouldLoadHistory = true;
          print('🔄 BMIDetailPage: Will load history - history not loaded for user ${widget.userProfile.id}');
        } else {
          print('⏭️ BMIDetailPage: Skip load history - already loading');
        }
      } else {
        // Sudah pernah load history untuk user ini (meskipun kosong)
        print('⏭️ BMIDetailPage: Skip load history - already loaded history for user ${widget.userProfile.id} (${state.bmiHistory.length} records, bmiHistoryUserId=${state.bmiHistoryUserId})');
      }
      
      if (shouldLoadProfile || shouldLoadHistory) {
        _hasInitialLoad = true;
        if (shouldLoadProfile) {
          print('🔄 BMIDetailPage: Loading user profile for ${widget.userProfile.id}');
          _bmiBloc.add(BMIGetUserProfile(widget.userProfile.id));
        }
        if (shouldLoadHistory) {
          print('🔄 BMIDetailPage: Loading BMI history for ${widget.userProfile.id}');
          _bmiBloc.add(BMILoadHistory(widget.userProfile.id));
        }
      } else {
        print('⏭️ BMIDetailPage: Skip all loads - no need to load');
        _hasInitialLoad = true; // Set flag meskipun tidak load untuk mencegah retry
      }
    });
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
                if (state.bmiHistory.isNotEmpty)
                  Padding(
                    padding: REdgeInsets.symmetric(horizontal: 16),
                    child: _buildBMIHistorySection(state.bmiHistory, state.currentUserProfile ?? widget.userProfile),
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
    return BlocBuilder<BMIBloc, BMIState>(
      builder: (context, state) {
        // Use currentUserProfile from state if available (has BMI data), otherwise use widget.userProfile
        // If loading, show loading state
        if (state.isLoading && state.currentUserProfile == null) {
          return Container(
            width: double.infinity,
            padding: REdgeInsets.all(32),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final userProfile = state.currentUserProfile ?? widget.userProfile;
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
              width: 130.w,
              height: 130.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: neutral50.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: userProfile.profileImageUrl != null
                    ? Image.network(
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
            ),

            24.verticalSpace,

            // BMI Status - Map to display text
            Container(
              padding: REdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2C5F7C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                _getBMIStatusDisplayText(bmiStatus!),
                style: TS.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C5F7C),
                  letterSpacing: 1.5,
                  fontSize: 26.sp,
                ),
              ),
            ),

            20.verticalSpace,

            // BMI Value
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TS.titleLarge.copyWith(
                  color: const Color(0xFFB71C1C),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: 'Your BMI is '),
                  TextSpan(
                    text: userProfile.currentBMI!.toStringAsFixed(1).replaceAll('.', ','),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                    ),
                  ),
                  const TextSpan(text: ' Kg/M2'),
                ],
              ),
            ),

            32.verticalSpace,

            // Height, Weight, Updated Info
            Container(
              margin: REdgeInsets.symmetric(horizontal: 24),
              padding: REdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'Height',
                      '${userProfile.height!.toStringAsFixed(1).replaceAll('.', ',')} CM',
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB71C1C).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'Weight',
                      '${userProfile.currentWeight!.toStringAsFixed(1).replaceAll('.', ',')} KG',
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB71C1C).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'Updated',
                      userProfile.lastUpdated != null
                          ? _formatDateShort(userProfile.lastUpdated!)
                          : (state.bmiHistory.isNotEmpty 
                              ? _formatDateShort(state.bmiHistory.first.recordedAt)
                              : '-'),
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
              padding: REdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFF5F5),
                    const Color(0xFFFFF9F9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color(0xFFB71C1C).withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: const Color(0xFF2C5F7C),
                        size: 20.w,
                      ),
                      8.horizontalSpace,
                      Text(
                        'Recommendation',
                        style: TS.titleMedium.copyWith(
                          color: const Color(0xFF2C5F7C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Text(
                    // Prioritas: 1. Dari API, 2. Fallback ke default recommendation
                    userProfile.recommendation ?? _getRecommendation(bmiStatus),
                    style: TS.bodyMedium.copyWith(
                      color: const Color(0xFFB71C1C),
                      height: 1.6,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            24.verticalSpace,
          ] else ...[
            // No Data State - Info Page
            // Profile Photo
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: neutral30, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: neutral50.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 1,
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

            32.verticalSpace,

            // User Name
            Text(
              userProfile.name,
              style: TS.titleLarge.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),

            40.verticalSpace,

            // Icon and Message dengan desain lebih menarik
            Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFF5F5),
                    const Color(0xFFFFF9F9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer circle decoration
                  Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      color: white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB71C1C).withOpacity(0.2),
                        width: 2.5,
                      ),
                    ),
                  ),
                  // Icon
                  Icon(
                    Icons.scale_outlined,
                    size: 85.w,
                    color: const Color(0xFFB71C1C).withOpacity(0.75),
                  ),
                ],
              ),
            ),

            32.verticalSpace,

            Text(
              'Belum ada data body mass index',
              style: TS.headlineSmall.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),

            20.verticalSpace,

            // Description dengan card style yang lebih menarik
            Container(
              margin: REdgeInsets.symmetric(horizontal: 24),
              padding: REdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFF5F5),
                    const Color(0xFFFFF9F9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color(0xFFB71C1C).withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 22.w,
                        color: const Color(0xFFB71C1C).withOpacity(0.8),
                      ),
                      10.horizontalSpace,
                      Text(
                        'Panduan',
                        style: TS.titleMedium.copyWith(
                          color: const Color(0xFF2C5F7C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Text(
                    'Data Body Mass Index untuk user ini belum tersedia. Silakan hitung body mass index terlebih dahulu untuk melihat status kesehatan dan mendapatkan rekomendasi yang tepat.',
                    style: TS.bodyLarge.copyWith(
                      color: const Color(0xFFB71C1C),
                      height: 1.7,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            40.verticalSpace,

            // Info Card dengan desain lebih menarik
            Container(
              width: double.infinity,
              margin: REdgeInsets.symmetric(horizontal: 24),
              padding: REdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFF5F5),
                    const Color(0xFFFFF9F9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: const Color(0xFFB71C1C).withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: REdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB71C1C).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB71C1C).withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: const Color(0xFFB71C1C),
                          size: 26.w,
                        ),
                      ),
                      12.horizontalSpace,
                      Text(
                        'Informasi Body Mass Index',
                        style: TS.titleMedium.copyWith(
                          color: const Color(0xFF2C5F7C),
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Text(
                    'Body Mass Index adalah indikator untuk menilai status gizi seseorang berdasarkan berat dan tinggi badan. Nilai Body Mass Index membantu menentukan apakah seseorang memiliki berat badan normal, kurang, berlebih, atau obesitas.',
                    style: TS.bodyMedium.copyWith(
                      color: const Color(0xFFB71C1C),
                      height: 1.7,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            32.verticalSpace,
          ],
        ],
      ),
    );
      },
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TS.bodyMedium.copyWith(
            color: const Color(0xFF2C5F7C),
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        10.verticalSpace,
        Text(
          value,
          style: TS.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB71C1C),
            fontSize: 15.sp,
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

  String _getBMIStatusDisplayText(BMIStatus status) {
    // Map BMI status to display text based on image
    switch (status) {
      case BMIStatus.underweight:
        return 'UNDERWEIGHT';
      case BMIStatus.normal:
        return 'EXCELLENT'; // Based on image, normal shows as "EXCELLENT"
      case BMIStatus.overweight:
        return 'OVERWEIGHT';
      case BMIStatus.obese:
        return 'OBESE';
    }
  }

  Widget _buildBMIHistorySection(List bmiHistory, dynamic currentUserProfile) {
    if (bmiHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show all history records except the first one (which is shown in main card)
    // The first record in history is the latest one, which is displayed in the main card
    // So we skip the first record and show the rest
    final filteredHistory = bmiHistory.length > 1 
        ? bmiHistory.skip(1).toList() 
        : [];

    if (filteredHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredHistory.length,
          separatorBuilder: (context, index) => 0.verticalSpace,
          itemBuilder: (context, index) {
            final record = filteredHistory[index];
            return _buildBMIHistoryItem(record);
          },
        ),
      ],
    );
  }

  Widget _buildBMIHistoryItem(dynamic record) {
    return Container(
      margin: REdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFF5F5),
            const Color(0xFFFFF9F9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFB71C1C).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB71C1C).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: REdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Section - Status and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C5F7C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          record.status.label,
                          style: TS.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C5F7C),
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      Row(
                        children: [
                          SizedBox(
                            width: 60.w,
                            child: Text(
                              'Height',
                              style: TS.bodySmall.copyWith(
                                color: const Color(0xFFB71C1C),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Text(
                            '${record.height.toStringAsFixed(1).replaceAll('.', ',')} CM',
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB71C1C),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          SizedBox(
                            width: 60.w,
                            child: Text(
                              'Weight',
                              style: TS.bodySmall.copyWith(
                                color: const Color(0xFFB71C1C),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Text(
                            '${record.weight.toStringAsFixed(1).replaceAll('.', ',')} Kg',
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB71C1C),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                16.horizontalSpace,

                // Right Section - BMI Value
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB71C1C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '${record.bmi.toStringAsFixed(1).replaceAll('.', ',')}\nKg/M2',
                    textAlign: TextAlign.center,
                    style: TS.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFB71C1C),
                      fontSize: 16.sp,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recommendation Section
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF2C5F7C),
                      size: 18.w,
                    ),
                    8.horizontalSpace,
                    Text(
                      'Recommendation',
                      style: TS.bodyMedium.copyWith(
                        color: const Color(0xFF2C5F7C),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                Text(
                  // Prioritas: 1. Dari notes (API), 2. Fallback ke default
                  record.notes ?? _getRecommendation(record.status),
                  style: TS.bodySmall.copyWith(
                    color: const Color(0xFFB71C1C),
                    height: 1.5,
                    fontSize: 13.sp,
                  ),
                ),
                12.verticalSpace,
                // Updated Date
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: neutral10,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Updated ${_formatDateShort(record.recordedAt)}',
                      style: TS.bodySmall.copyWith(
                        color: neutral50,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
