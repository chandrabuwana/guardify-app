import 'dart:async';
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
  BMIBloc? _bmiBloc;
  bool _hasInitialLoad = false; // Flag untuk mencegah multiple initial loads
  Timer? _searchDebounce; // Debounce timer untuk search
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Delay load data untuk memastikan widget sudah fully mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadData();
      }
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil bloc dari context sekali
    if (_bmiBloc == null) {
      _bmiBloc = context.read<BMIBloc>();
      print('🔄 BMIListPage: Bloc obtained from context');
    }
    // Jangan load data di sini - hanya di initState sekali
  }
  
  BMIBloc get bmiBloc {
    _bmiBloc ??= context.read<BMIBloc>();
    return _bmiBloc!;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    final state = bmiBloc.state;
    if (state.isLoadingMore || !state.hasMoreData) return;

    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;

    // Trigger before reaching the end
    const triggerOffset = 200.0;
    if (position.pixels >= (position.maxScrollExtent - triggerOffset)) {
      bmiBloc.add(BMILoadMoreUsers());
    }
  }

  void _loadData() {
    // Hanya load data sekali saat pertama kali buka halaman
    // JANGAN PERNAH reload otomatis
    if (_hasInitialLoad) {
      print('⏭️ BMI List: Skip _loadData - _hasInitialLoad=$_hasInitialLoad (ALREADY LOADED)');
      return; // Skip jika sudah pernah load - TIDAK ADA RELOAD
    }
    
    // Set flag SEBELUM apapun untuk mencegah multiple calls
    _hasInitialLoad = true;
    
    print('🔄 BMI List: _loadData called - checking state...');
    
    // Gunakan Future.microtask untuk memastikan state sudah stabil
    Future.microtask(() {
      if (!mounted) {
        print('⏭️ BMI List: Skip - widget not mounted');
        return;
      }
      
      final state = bmiBloc.state;
      print('📊 BMI List: Current state - isLoading=${state.isLoading}, isSearching=${state.isSearching}, hasLoadedEmpty=${state.hasLoadedEmpty}, hasInitialLoadAttempted=${state.hasInitialLoadAttempted}, searchResults.length=${state.searchResults.length}');
      
      // PRIORITAS 1: Jika sudah pernah attempt load, JANGAN HIT API LAGI (PENTING!)
      if (state.hasInitialLoadAttempted) {
        if (state.hasLoadedEmpty) {
          print('⏭️ BMI List: Skip API call - hasInitialLoadAttempted=true, hasLoadedEmpty=true (data already loaded and empty)');
        } else if (state.searchResults.isNotEmpty) {
          print('⏭️ BMI List: Skip API call - hasInitialLoadAttempted=true, already has data (${state.searchResults.length} items)');
        } else {
          print('⏭️ BMI List: Skip API call - hasInitialLoadAttempted=true (already attempted, no need to retry)');
        }
        return;
      }
      
      // PRIORITAS 2: Jika sudah ada data, skip API call
      if (state.searchResults.isNotEmpty) {
        print('⏭️ BMI List: Skip API call - searchResults is not empty (${state.searchResults.length} items)');
        return;
      }
      
      // PRIORITAS 3: Jika sedang loading atau searching, tunggu sampai selesai
      if (state.isLoading || state.isSearching) {
        print('⏭️ BMI List: Skip API call - already loading or searching');
        return;
      }
      
      // Hanya load jika belum pernah attempt load
      print('🔄 BMI List: Loading all users... (first time, hasInitialLoadAttempted=${state.hasInitialLoadAttempted})');
      bmiBloc.add(BMILoadAllUsers());
      
      // Load pinned users hanya jika belum ada dan tidak sedang loading
      // Dan tidak sedang dalam state empty
      if (state.pinnedUsers.isEmpty && 
          !state.isLoading && 
          !state.isSearching &&
          !state.hasLoadedEmpty) {
        print('🔄 BMI List: Loading pinned users...');
        bmiBloc.add(BMILoadPinnedUsers());
      }
    });
  }

  void _performSearch(String query) {
    // Cancel previous debounce timer
    _searchDebounce?.cancel();
    
    // If query is empty, jangan hit API - biarkan data yang sudah ada tetap ditampilkan
    if (query.trim().isEmpty) {
      // Jangan hit API jika query kosong, biarkan data yang sudah ada
      // Hanya clear search results jika user memang clear search
      return;
    }
    
    // Debounce search to avoid too many API calls
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        bmiBloc.add(BMISearchUsers(query));
      }
    });
  }

  void _navigateToDetail(dynamic userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: bmiBloc,
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
        buildWhen: (previous, current) {
          // Hanya rebuild jika state yang relevan berubah
          // Jangan rebuild jika hanya isLoading yang berubah dari false ke false (tidak ada perubahan)
          if (previous.isLoading == current.isLoading &&
              previous.isSearching == current.isSearching &&
              previous.searchResults.length == current.searchResults.length &&
              previous.pinnedUsers.length == current.pinnedUsers.length &&
              previous.hasError == current.hasError &&
              previous.error == current.error &&
              previous.hasLoadedEmpty == current.hasLoadedEmpty &&
              previous.hasInitialLoadAttempted == current.hasInitialLoadAttempted) {
            return false; // Tidak ada perubahan yang relevan
          }
          return true;
        },
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
                            setState(() {});
                            // Jangan hit API saat clear, biarkan data yang sudah ada
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
    // Show loading only if currently loading/searching AND no data yet
    // Don't show loading if we have error (error state will be shown instead)
    if ((state.isLoading || state.isSearching) && 
        state.searchResults.isEmpty &&
        !state.hasError) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    // Show error state only if we have error, no data, and not loading
    if (state.hasError && state.searchResults.isEmpty && !state.isLoading && !state.isSearching) {
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
              onPressed: () {
                // Reset flag untuk allow retry
                _hasInitialLoad = false;
                // Clear error dan retry load
                bmiBloc.add(BMIClearError());
                // Force reload dengan reset hasInitialLoadAttempted
                final currentState = bmiBloc.state;
                if (currentState.hasInitialLoadAttempted) {
                  // Reset state untuk allow retry
                  bmiBloc.add(BMIReset());
                }
                bmiBloc.add(BMILoadAllUsers());
              },
            ),
          ],
        ),
      );
    }

    final combinedList = state.combinedUserList;

    // Show empty state if not loading and not searching
    // Differentiate between search empty and initial empty
    if (combinedList.isEmpty && !state.isLoading && !state.isSearching) {
      // If search query is empty and hasLoadedEmpty, show initial empty state
      if (_searchController.text.trim().isEmpty && state.hasLoadedEmpty) {
        return _buildEmptyState();
      }
      
      // Otherwise show search empty state
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

    // Tidak ada RefreshIndicator - data hanya di-load sekali saat pertama kali buka
    return GridView.builder(
        key: const PageStorageKey('bmi_list_grid'),
        controller: _scrollController,
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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

                  6.verticalSpace,

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
                    8.verticalSpace,

                    // BMI Value with Status Badge
                    Center(
                      child: Container(
                      padding: REdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                              fontSize: 16.sp,
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

                    8.verticalSpace,

                    // Weight and Height Info
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding:
                            REdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
                            width: 1,
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
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                2.verticalSpace,
                                Text(
                                  '${userProfile.currentWeight!.toStringAsFixed(1).replaceAll('.', ',')} KG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFB71C1C),
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 24.h,
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
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                2.verticalSpace,
                                Text(
                                  '${userProfile.height!.toStringAsFixed(1).replaceAll('.', ',')} CM',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFB71C1C),
                                    fontSize: 11.sp,
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
                    8.verticalSpace,
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

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Empty illustration dengan gradient dan shadow
              Container(
                width: 180.w,
                height: 180.w,
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
                      color: const Color(0xFFB71C1C).withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: const Color(0xFFB71C1C).withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer circle decoration
                    Container(
                      width: 160.w,
                      height: 160.w,
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFB71C1C).withOpacity(0.15),
                          width: 2,
                        ),
                      ),
                    ),
                    // Icon
                    Icon(
                      Icons.people_outline,
                      size: 90.w,
                      color: const Color(0xFFB71C1C).withOpacity(0.7),
                    ),
                  ],
                ),
              ),
              
              40.verticalSpace,
              
              // Title dengan gradient text effect
              Text(
                'Belum Ada Data Body Mass Index',
                style: TS.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: neutral90,
                  fontSize: 24.sp,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              16.verticalSpace,
              
              // Description dengan card style
              Container(
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
                      color: const Color(0xFFB71C1C).withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
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
                          Icons.info_outline,
                          size: 20.w,
                          color: const Color(0xFFB71C1C).withOpacity(0.8),
                        ),
                        8.horizontalSpace,
                        Text(
                          'Informasi',
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
                      'Data Body Mass Index belum tersedia saat ini. Data akan muncul setelah pengguna melakukan perhitungan body mass index.',
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
              
              // Additional info card
              Container(
                padding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: neutral20,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: neutral50.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      size: 20.w,
                      color: const Color(0xFF2C5F7C).withOpacity(0.7),
                    ),
                    12.horizontalSpace,
                    Flexible(
                      child: Text(
                        'Body Mass Index membantu menilai status gizi dan kesehatan',
                        style: TS.bodySmall.copyWith(
                          color: neutral70,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                // Hanya load jika belum pernah attempt atau data kosong
                final state = bmiBloc.state;
                if (!state.hasInitialLoadAttempted || 
                    (state.hasInitialLoadAttempted && state.searchResults.isEmpty && !state.hasLoadedEmpty)) {
                  bmiBloc.add(BMILoadAllUsers());
                } else {
                  print('⏭️ Filter: Skip BMILoadAllUsers - already has data or already attempted');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.push_pin_outlined),
              title: const Text('Yang Disematkan'),
              onTap: () {
                Navigator.pop(context);
                bmiBloc.add(BMILoadPinnedUsers());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Ada Data Body Mass Index'),
              onTap: () {
                Navigator.pop(context);
                // Filter users with BMI data
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Belum Ada Data Body Mass Index'),
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
