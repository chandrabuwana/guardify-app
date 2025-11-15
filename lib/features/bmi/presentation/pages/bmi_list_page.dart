import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/constants/enums.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
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
    // Hanya load data jika belum ada atau kosong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = _bmiBloc.state;
      if (state.searchResults.isEmpty && !state.isSearching) {
        _bmiBloc.add(BMILoadAllUsers());
      }
      if (state.pinnedUsers.isEmpty) {
        _bmiBloc.add(BMILoadPinnedUsers());
      }
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      _bmiBloc.add(BMILoadAllUsers());
    } else {
      _bmiBloc.add(BMISearchUsers(query));
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          'Body Mass Index',
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
          return Column(
            children: [
              // Search Section
              _buildSearchSection(),

              16.verticalSpace,

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
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFFB71C1C).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                  _performSearch(value);
                },
                style: TS.bodyMedium.copyWith(
                  color: neutral90,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: const Color(0xFFB71C1C).withOpacity(0.6),
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFFB71C1C),
                    size: 22.w,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.clear,
                            color: neutral50,
                            size: 20.w,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: REdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          12.horizontalSpace,
          Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFB71C1C),
                  const Color(0xFFD32F2F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB71C1C).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showFilterDialog,
                borderRadius: BorderRadius.circular(14.r),
                child: Center(
                  child: Icon(
                    Icons.filter_list,
                    color: white,
                    size: 24.w,
                  ),
                ),
              ),
            ),
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
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          final metrics = scrollInfo.metrics;
          final threshold = metrics.maxScrollExtent - 200;
          
          if (!state.isLoadingMore &&
              state.hasMoreData &&
              metrics.pixels >= threshold &&
              metrics.maxScrollExtent > 0) {
            print('📜 Scroll detected: pixels=${metrics.pixels}, maxScrollExtent=${metrics.maxScrollExtent}, threshold=$threshold');
            print('   isLoadingMore=${state.isLoadingMore}, hasMoreData=${state.hasMoreData}');
            _bmiBloc.add(BMILoadMoreUsers());
          }
          return false;
        },
        child: GridView.builder(
          key: const PageStorageKey('bmi_list_grid'),
          padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.68,
          ),
          itemCount: combinedList.length + (state.isLoadingMore ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= combinedList.length) {
              return _buildLoadingCard();
            }
            final userProfile = combinedList[index];
            // Use key to ensure unique widgets and proper rebuild
            return _buildUserProfileCard(
              userProfile, 
              key: ValueKey('user_${userProfile.id}_$index'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            white,
            const Color(0xFFFFF9F9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xFFB71C1C).withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB71C1C).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: const Color(0xFFB71C1C),
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(dynamic userProfile, {Key? key}) {
    final hasData = userProfile.currentBMI != null;
    final bmiStatus = userProfile.currentBMIStatus;

    return Container(
      key: key,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(userProfile),
          borderRadius: BorderRadius.circular(18.r),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: hasData
                  ? LinearGradient(
                      colors: [
                        white,
                        const Color(0xFFFFF9F9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: hasData ? null : white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: hasData
                    ? const Color(0xFFB71C1C).withOpacity(0.1)
                    : neutral20,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: hasData
                      ? const Color(0xFFB71C1C).withOpacity(0.1)
                      : neutral50.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: neutral50.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
        child: Stack(
          children: [
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Profile Photo
                  Center(
                    child: Container(
                    width: 75.w,
                    height: 75.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: neutral20,
                      border: Border.all(
                        color: hasData
                            ? const Color(0xFFB71C1C).withOpacity(0.2)
                            : neutral30,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: hasData
                              ? const Color(0xFFB71C1C).withOpacity(0.15)
                              : neutral50.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: userProfile.profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              userProfile.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 35.w,
                                  color: neutral50,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 35.w,
                            color: neutral50,
                          ),
                    ),
                  ),

                  10.verticalSpace,

                  // Name
                  Center(
                    child: Text(
                      userProfile.name,
                      style: TS.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: neutral90,
                        fontSize: 15.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (hasData) ...[
                    10.verticalSpace,

                    // BMI Value with Status Badge
                    Center(
                      child: Container(
                      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFB71C1C).withOpacity(0.1),
                            const Color(0xFFB71C1C).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFB71C1C).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${userProfile.currentBMI!.toStringAsFixed(1).replaceAll('.', ',')} Kg/m2',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB71C1C),
                              fontSize: 17.sp,
                            ),
                          ),
                          if (bmiStatus != null) ...[
                            4.verticalSpace,
                            Text(
                              bmiStatus.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2C5F7C),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                      ),
                    ),

                    12.verticalSpace,

                    // Weight and Height Info
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding:
                            REdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFF5F5),
                              const Color(0xFFFFF9F9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFB71C1C).withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Berat',
                                  style: TextStyle(
                                    color: const Color(0xFF2C5F7C),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                4.verticalSpace,
                                Text(
                                  '${userProfile.currentWeight!.toStringAsFixed(0)} KG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFB71C1C),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB71C1C).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tinggi',
                                  style: TextStyle(
                                    color: const Color(0xFF2C5F7C),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                4.verticalSpace,
                                Text(
                                  '${userProfile.height!.toStringAsFixed(0)} CM',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFB71C1C),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                  ] else ...[
                    10.verticalSpace,
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.scale_outlined,
                            size: 24.w,
                            color: neutral50,
                          ),
                          4.verticalSpace,
                          Text(
                            'Belum ada data',
                            style: TS.bodySmall.copyWith(
                              color: neutral50,
                              fontSize: 11.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                ],
              ),
            ),

            // Pin icon at top left
            if (userProfile.isPinned)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: REdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFB71C1C),
                        const Color(0xFFD32F2F),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB71C1C).withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.push_pin,
                    size: 16.w,
                    color: white,
                  ),
                ),
              ),
          ],
        ),
          ),
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
}
