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
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFB71C1C),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _performSearch,
                style: TS.bodyMedium.copyWith(color: neutral90),
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: const Color(0xFFB71C1C),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFFB71C1C),
                    size: 24.w,
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
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          16.horizontalSpace,
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: _showFilterDialog,
              icon: Icon(
                Icons.filter_list,
                color: white,
                size: 24.w,
              ),
              padding: EdgeInsets.zero,
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
          if (!state.isLoadingMore &&
              state.hasMoreData &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
            _bmiBloc.add(BMILoadMoreUsers());
          }
          return false;
        },
        child: GridView.builder(
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
            return _buildUserProfileCard(userProfile);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: neutral50.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(dynamic userProfile) {
    final hasData = userProfile.currentBMI != null;

    return GestureDetector(
      onTap: () => _navigateToDetail(userProfile),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: neutral50.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: REdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  8.verticalSpace,

                  // Profile Photo
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: neutral20,
                      border: Border.all(color: neutral30, width: 2),
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

                  10.verticalSpace,

                  // Name
                  Flexible(
                    child: Text(
                      userProfile.name,
                      style: TS.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: neutral90,
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (hasData) ...[
                    8.verticalSpace,

                    // BMI Value
                    Text(
                      '${userProfile.currentBMI!.toStringAsFixed(1)} Kg/m2',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB71C1C),
                        fontSize: 16.sp,
                      ),
                    ),

                    10.verticalSpace,

                    // Weight and Height Info with striped background
                    Container(
                      padding:
                          REdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.yellow.withOpacity(0.3),
                        border: Border.all(color: Colors.black, width: 1),
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
                                    color: neutral90,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                2.verticalSpace,
                                Text(
                                  '${userProfile.currentWeight!.toStringAsFixed(0)} KG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: neutral90,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 25.h,
                            color: neutral30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tinggi',
                                  style: TextStyle(
                                    color: neutral90,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                2.verticalSpace,
                                Text(
                                  '${userProfile.height!.toStringAsFixed(0)} CM',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: neutral90,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    10.verticalSpace,
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
                ],
              ),
            ),

            // Pin icon at top left
            if (userProfile.isPinned)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: REdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB71C1C),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.push_pin,
                    size: 14.w,
                    color: white,
                  ),
                ),
              ),
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
}
