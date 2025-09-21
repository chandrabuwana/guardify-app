import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/constants/enums.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';
import '../bloc/bmi_bloc.dart';
import 'bmi_detail_page.dart';

/// Page untuk role non-anggota - menampilkan daftar BMI semua user dengan fitur search dan pin
class BMIListPage extends StatefulWidget {
  final UserRole currentUserRole;

  const BMIListPage({
    Key? key,
    required this.currentUserRole,
  }) : super(key: key);

  @override
  State<BMIListPage> createState() => _BMIListPageState();
}

class _BMIListPageState extends State<BMIListPage> {
  final _searchController = TextEditingController();
  BMIBloc get _bmiBloc => context.read<BMIBloc>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    _bmiBloc.add(BMILoadAllUsers());
    _bmiBloc.add(BMILoadPinnedUsers());
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      _bmiBloc.add(BMILoadAllUsers());
    } else {
      _bmiBloc.add(BMISearchUsers(query));
    }
  }

  void _togglePin(String userId, bool isPinned) {
    _bmiBloc.add(BMITogglePin(userId, !isPinned));
  }

  void _navigateToDetail(dynamic userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _bmiBloc,
          child: BMIDetailPage(
            userProfile: userProfile,
            currentUserRole: widget.currentUserRole,
          ),
        ),
      ),
    );
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
          'Body Mass Index',
          style: TS.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Show filter dialog
              _showFilterDialog();
            },
            icon: const Icon(Icons.filter_list_outlined),
          ),
        ],
      ),
      body: BlocBuilder<BMIBloc, BMIState>(
        builder: (context, state) {
          return Column(
            children: [
              // Search Section
              _buildSearchSection(),

              // Content
              Expanded(
                child: _buildContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          InputPrimary(
            controller: _searchController,
            hint: 'Cari nama atau jabatan...',
            prefixIcon: Icon(
              Icons.search_outlined,
              color: neutral50,
              size: 20.w,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                    icon: Icon(
                      Icons.clear,
                      color: neutral50,
                      size: 20.w,
                    ),
                  )
                : null,
            onChanged: _performSearch,
            textStyle: TS.bodyMedium.copyWith(color: neutral90),
            hintStyle: TS.bodyMedium.copyWith(color: neutral50),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BMIState state) {
    if (state.isSearching && state.searchResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (state.hasError && state.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: neutral50,
            ),
            16.verticalSpace,
            Text(
              state.error!,
              style: TS.bodyLarge.copyWith(color: neutral70),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            UIButton(
              text: 'Coba Lagi',
              onPressed: _loadData,
            ),
          ],
        ),
      );
    }

    final combinedList = state.combinedUserList;

    if (combinedList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 64.w,
              color: neutral50,
            ),
            16.verticalSpace,
            Text(
              'Tidak ada hasil ditemukan',
              style: TS.bodyLarge.copyWith(color: neutral70),
            ),
            8.verticalSpace,
            Text(
              'Coba gunakan kata kunci lain',
              style: TS.bodyMedium.copyWith(color: neutral50),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      color: primaryColor,
      child: ListView.separated(
        padding: REdgeInsets.all(16),
        itemCount: combinedList.length,
        separatorBuilder: (context, index) => 12.verticalSpace,
        itemBuilder: (context, index) {
          final userProfile = combinedList[index];
          return _buildUserProfileCard(userProfile);
        },
      ),
    );
  }

  Widget _buildUserProfileCard(dynamic userProfile) {
    final hasData = userProfile.currentBMI != null;
    final bmiStatus = userProfile.currentBMIStatus;
    final statusColor = _getBMIStatusColor(bmiStatus);

    return GestureDetector(
      onTap: () => _navigateToDetail(userProfile),
      child: Container(
        padding: REdgeInsets.all(16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: userProfile.isPinned
                ? primaryColor.withOpacity(0.3)
                : neutral30,
            width: userProfile.isPinned ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: neutral50.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with Pin button
            Row(
              children: [
                // Profile Image
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.1),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: userProfile.profileImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            userProfile.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 24.w,
                                color: primaryColor,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 24.w,
                          color: primaryColor,
                        ),
                ),

                16.horizontalSpace,

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userProfile.name,
                              style: TS.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: neutral90,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (userProfile.isPinned) ...[
                            8.horizontalSpace,
                            Icon(
                              Icons.push_pin,
                              size: 16.w,
                              color: primaryColor,
                            ),
                          ],
                        ],
                      ),
                      4.verticalSpace,
                      Text(
                        userProfile.role.displayName,
                        style: TS.bodyMedium.copyWith(
                          color: neutral70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Pin Toggle Button
                IconButton(
                  onPressed: () =>
                      _togglePin(userProfile.id, userProfile.isPinned),
                  icon: Icon(
                    userProfile.isPinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    color: userProfile.isPinned ? primaryColor : neutral50,
                    size: 20.w,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: userProfile.isPinned
                        ? primaryColor.withOpacity(0.1)
                        : neutral10,
                    padding: REdgeInsets.all(8),
                  ),
                ),
              ],
            ),

            if (hasData) ...[
              16.verticalSpace,

              // BMI Info
              Container(
                padding: REdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    // BMI Value
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BMI ${userProfile.currentBMI!.toStringAsFixed(1)}',
                            style: TS.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          4.verticalSpace,
                          Container(
                            padding: REdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              bmiStatus!.label,
                              style: TS.labelSmall.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Weight & Height
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Berat',
                                  style:
                                      TS.bodySmall.copyWith(color: neutral50),
                                ),
                                2.verticalSpace,
                                Text(
                                  '${userProfile.currentWeight!.toStringAsFixed(1)} KG',
                                  style: TS.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: neutral90,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30.h,
                            color: statusColor.withOpacity(0.3),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Tinggi',
                                  style:
                                      TS.bodySmall.copyWith(color: neutral50),
                                ),
                                2.verticalSpace,
                                Text(
                                  '${userProfile.height!.toStringAsFixed(0)} CM',
                                  style: TS.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: neutral90,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (userProfile.lastUpdated != null) ...[
                8.verticalSpace,
                Text(
                  'Diperbarui: ${_formatDate(userProfile.lastUpdated!)}',
                  style: TS.bodySmall.copyWith(
                    color: neutral50,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ] else ...[
              16.verticalSpace,

              // No Data State
              Container(
                width: double.infinity,
                padding: REdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: neutral10,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: neutral30),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.scale_outlined,
                      size: 32.w,
                      color: neutral50,
                    ),
                    8.verticalSpace,
                    Text(
                      'Belum ada data BMI',
                      style: TS.bodyMedium.copyWith(
                        color: neutral70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Filter',
          style: TS.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Semua'),
              onTap: () {
                Navigator.pop(context);
                _bmiBloc.add(BMILoadAllUsers());
              },
            ),
            ListTile(
              leading: const Icon(Icons.push_pin_outlined),
              title: const Text('Yang Disematkan'),
              onTap: () {
                Navigator.pop(context);
                _bmiBloc.add(BMILoadPinnedUsers());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Ada Data BMI'),
              onTap: () {
                Navigator.pop(context);
                // Filter users with BMI data
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Belum Ada Data BMI'),
              onTap: () {
                Navigator.pop(context);
                // Filter users without BMI data
              },
            ),
          ],
        ),
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
}
