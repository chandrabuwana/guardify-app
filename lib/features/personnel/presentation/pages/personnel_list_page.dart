import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/di/injection.dart';
import '../bloc/personnel_bloc.dart';
import '../bloc/personnel_event.dart';
import '../bloc/personnel_state.dart';
import 'personnel_detail_page.dart';

class PersonnelListPage extends StatelessWidget {
  const PersonnelListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PersonnelBloc>()
        ..add(const LoadPersonnelByStatusEvent('Pending')),
      child: const _PersonnelListView(),
    );
  }
}

class _PersonnelListView extends StatefulWidget {
  const _PersonnelListView();

  @override
  State<_PersonnelListView> createState() => _PersonnelListViewState();
}

class _PersonnelListViewState extends State<_PersonnelListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentTab = 'Pending'; // Default tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1); // Start at Pending
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PersonnelBloc>().add(const LoadMorePersonnelEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Load when 90% scrolled
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    
    setState(() {
      switch (_tabController.index) {
        case 0:
          _currentTab = 'Active'; // API uses 'Active'
          break;
        case 1:
          _currentTab = 'Pending';
          break;
        case 2:
          _currentTab = 'Inactive'; // API uses 'Inactive'
          break;
      }
    });
    
    // Load personnel for selected tab
    context.read<PersonnelBloc>().add(LoadPersonnelByStatusEvent(_currentTab));
    _searchController.clear(); // Clear search when changing tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
// TODO
// LOGIN SEBAGAI PENGAWAS DAFTAR PERSONIL YANG STATUSNYA PENDING TRUS LIHAT DETAIL 
// Revisi g bisa ,menyetujui tidak bisa 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: neutral10,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: neutral90),
              onPressed: () => Navigator.pop(context),
            ),
          title: const Text(
            'Daftar Personil',
            style: TextStyle(
              color: neutral90,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: neutral30,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: neutral50,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: primaryColor,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Aktif'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Non Aktif'),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Search and Filter
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: neutral10,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: neutral30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          context.read<PersonnelBloc>().add(
                                SearchPersonnelEvent(query, _currentTab),
                              );
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari',
                          hintStyle: TextStyle(
                            color: neutral50,
                            fontSize: 14.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: neutral50,
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  // Filter button
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        // TODO: Implement filter
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Filter sedang dalam pengembangan'),
                            backgroundColor: primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Personnel List
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonnelList('Aktif'),
                  _buildPersonnelList('Pending'),
                  _buildPersonnelList('Non Aktif'),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildPersonnelList(String status) {
    return BlocBuilder<PersonnelBloc, PersonnelState>(
      builder: (context, state) {
        if (state is PersonnelLoading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state is PersonnelError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: neutral50,
                  ),
                  16.verticalSpace,
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: neutral70,
                    ),
                  ),
                  24.verticalSpace,
                  ElevatedButton(
                    onPressed: () {
                      context.read<PersonnelBloc>().add(
                            LoadPersonnelByStatusEvent(status),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PersonnelListLoaded) {
          if (state.personnelList.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64.sp,
                      color: neutral50,
                    ),
                    16.verticalSpace,
                    Text(
                      state.isSearching
                          ? 'Tidak ada hasil untuk "${state.searchQuery}"'
                          : 'Belum ada personil dengan status $status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: neutral70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: state.personnelList.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= state.personnelList.length) {
                // Show loading indicator at bottom
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(color: primaryColor),
                );
              }
              
              final personnel = state.personnelList[index];
              return _buildPersonnelCard(personnel);
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildPersonnelCard(personnel) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: babyBlueColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30.r,
              backgroundColor: neutral30,
              backgroundImage: personnel.photoUrl != null && personnel.photoUrl!.isNotEmpty
                  ? NetworkImage(personnel.photoUrl!)
                  : null,
              child: personnel.photoUrl == null || personnel.photoUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 30.sp,
                      color: neutral50,
                    )
                  : null,
            ),
            16.horizontalSpace,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personnel.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: neutral90,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    personnel.role,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Lihat Detail button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<PersonnelBloc>()
                        ..add(LoadPersonnelDetailEvent(personnel.id)),
                      child: PersonnelDetailPage(personnelId: personnel.id),
                    ),
                  ),
                ).then((_) {
                  // Refresh list after returning from detail page
                  context.read<PersonnelBloc>().add(
                        LoadPersonnelByStatusEvent(_currentTab),
                      );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Lihat Detail',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
