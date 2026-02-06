import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../bloc/laporan_kegiatan_bloc.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import '../widgets/laporan_card.dart';
import '../widgets/empty_state_widget.dart';
import 'laporan_kegiatan_detail_page.dart';

class LaporanKegiatanPage extends StatefulWidget {
  final String? userId;
  final UserRole? userRole;

  const LaporanKegiatanPage({
    Key? key,
    this.userId,
    this.userRole,
  }) : super(key: key);

  @override
  State<LaporanKegiatanPage> createState() => _LaporanKegiatanPageState();
}

class _LaporanKegiatanPageState extends State<LaporanKegiatanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UserRole _currentUserRole;
  late LaporanKegiatanBloc _laporanBloc;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedKehadiranFilter;

  @override
  void initState() {
    super.initState();

    _currentUserRole = widget.userRole ?? UserRole.anggota;

    _laporanBloc = getIt<LaporanKegiatanBloc>();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Add scroll listener for lazy loading
    _scrollController.addListener(_onScroll);

    // Load initial data
    _loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      _loadMoreData();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _laporanBloc.close();
    super.dispose();
  }

  bool _isNoDataErrorMessage(String message) {
    final m = message.toLowerCase();
    return m.contains('tidak ditemukan') ||
        m.contains('data tidak tersedia') ||
        m.contains('data tidak ditemukan') ||
        m.contains('not found') ||
        m.contains('no data');
  }

  void _loadData({String? search, bool resetPagination = true}) {
    // Tab 0: Menunggu Verifikasi -> hanya status waiting (filter dari API)
    // Tab 1: Terverifikasi -> status verified
    final currentStatus = _tabController.index == 0
        ? LaporanStatus.waiting
        : LaporanStatus.verified;
    
    // Get current state to determine next page
    final currentState = _laporanBloc.state;
    int start = 1;
    
    if (!resetPagination && currentState is LaporanListLoaded) {
      start = currentState.currentPage + 1;
    }
    
    _laporanBloc.add(GetLaporanListEvent(
      status: currentStatus,
      search: search,
      userId: widget.userId,
      start: start,
      length: 10,
      isLoadMore: !resetPagination,
    ));
  }

  void _loadMoreData() {
    final currentState = _laporanBloc.state;
    if (currentState is LaporanListLoaded) {
      if (currentState.hasMore && !currentState.isLoadingMore) {
        final search = _searchController.text.trim();
        _loadData(
          search: search.isEmpty ? null : search,
          resetPagination: false,
        );
      }
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final search = _searchController.text.trim();
      if (_tabController.index == 0) {
        // Tab "Menunggu Verifikasi" -> hanya status waiting (filter dari API)
        _laporanBloc.add(GetLaporanListEvent(
          status: LaporanStatus.waiting,
          search: search.isEmpty ? null : search,
          userId: widget.userId,
          start: 1,
          length: 10,
        ));
      } else {
        // Tab "Terverifikasi" -> status verified
        _laporanBloc.add(GetLaporanListEvent(
          status: LaporanStatus.verified,
          search: search.isEmpty ? null : search,
          userId: widget.userId,
          start: 1,
          length: 10,
        ));
      }
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: REdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter',
              style: TS.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            24.verticalSpace,
            Text(
              'Status Kehadiran',
              style: TS.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            12.verticalSpace,
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip(
                  'Semua',
                  _selectedKehadiranFilter == null,
                  () {
                    setState(() {
                      _selectedKehadiranFilter = null;
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                ),
                _buildFilterChip(
                  'Masuk',
                  _selectedKehadiranFilter == 'Masuk',
                  () {
                    setState(() {
                      _selectedKehadiranFilter = 'Masuk';
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                ),
                _buildFilterChip(
                  'Tidak Masuk',
                  _selectedKehadiranFilter == 'Tidak Masuk',
                  () {
                    setState(() {
                      _selectedKehadiranFilter = 'Tidak Masuk';
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                ),
                _buildFilterChip(
                  'Cuti',
                  _selectedKehadiranFilter == 'Cuti',
                  () {
                    setState(() {
                      _selectedKehadiranFilter = 'Cuti';
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                ),
              ],
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: UIButton(
                    text: 'Reset',
                    onPressed: () {
                      setState(() {
                        _selectedKehadiranFilter = null;
                      });
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    buttonType: UIButtonType.outline,
                    color: Colors.grey,
                    textColor: Colors.black87,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: UIButton(
                    text: 'Terapkan',
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: primaryColor.withOpacity(0.2),
      checkmarkColor: primaryColor,
      labelStyle: TS.bodyMedium.copyWith(
        color: isSelected ? primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _applyFilters() {
    // Reset to first page when applying filters
    final search = _searchController.text.trim();
    _loadData(search: search.isEmpty ? null : search);
  }

  Color _getStatusColor(LaporanStatus status) {
    switch (status) {
      case LaporanStatus.checkIn:
        return Colors.blue;
      case LaporanStatus.waiting:
        return Colors.blue;
      case LaporanStatus.verified:
        return Colors.lightBlue;
      case LaporanStatus.revision:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaporanKegiatanBloc>.value(
      value: _laporanBloc,
      child: AppScaffold(
        backgroundColor: Colors.white,
        enableScrolling: false,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Laporan Kegiatan',
            style: TS.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Container(
              color: primaryColor,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TS.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TS.titleSmall,
                tabs: const [
                  Tab(text: 'Menunggu Verifikasi'),
                  Tab(text: 'Terverifikasi'),
                ],
              ),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Search and Filter Section
            Container(
              padding: REdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: primaryColor, width: 1),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari',
                          hintStyle: TS.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: REdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TS.bodyMedium,
                        onChanged: (value) {
                          // Debounce search - reload after user stops typing
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (_searchController.text == value) {
                              _loadData(search: value.trim().isEmpty ? null : value.trim());
                            }
                          });
                        },
                        onSubmitted: (value) {
                          _loadData(search: value.trim().isEmpty ? null : value.trim());
                        },
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onPressed: _showFilterSheet,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLaporanList(LaporanStatus.waiting),
                  _buildLaporanList(LaporanStatus.verified),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaporanList(LaporanStatus status) {
    return BlocBuilder<LaporanKegiatanBloc, LaporanKegiatanState>(
      builder: (context, state) {
        if (state is LaporanLoading && !state.isLoadMore) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }

        if (state is LaporanError) {
          if (_isNoDataErrorMessage(state.message)) {
            return EmptyStateWidget(
              message: 'Data Tidak Tersedia',
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: errorColor,
                ),
                16.verticalSpace,
                Text(
                  'Terjadi Kesalahan',
                  style: TS.titleMedium.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.verticalSpace,
                Text(
                  state.message,
                  style: TS.bodyMedium.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                UIButton(
                  text: 'Coba Lagi',
                  onPressed: () => _loadData(),
                ),
              ],
            ),
          );
        }

        if (state is LaporanListLoaded) {
          // Filter by status (as fallback, API should already filter)
          // and kehadiran filter
          var filteredList = state.laporanList
              .where((laporan) => laporan.status == status)
              .toList();

          // Apply kehadiran filter if selected
          if (_selectedKehadiranFilter != null) {
            filteredList = filteredList
                .where((laporan) => laporan.kehadiran == _selectedKehadiranFilter)
                .toList();
          }

          if (filteredList.isEmpty && !state.isLoadingMore) {
            return EmptyStateWidget(
              message: 'Data Tidak Tersedia',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final search = _searchController.text.trim();
              _laporanBloc.add(GetLaporanListEvent(
                status: status,
                search: search.isEmpty ? null : search,
                userId: widget.userId,
                start: 1,
                length: 10,
              ));
            },
            color: primaryColor,
            child: ListView.builder(
              controller: _scrollController,
              padding: REdgeInsets.all(16),
              itemCount: filteredList.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the bottom
                if (index == filteredList.length) {
                  return Padding(
                    padding: REdgeInsets.all(16),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  );
                }

                final laporan = filteredList[index];
                return Padding(
                  padding: REdgeInsets.only(bottom: 12),
                  child: LaporanCard(
                    laporan: laporan,
                    statusColor: _getStatusColor(laporan.status),
                    onTap: () {
                      // Check if idAttendance, checkIn, and checkOut are not null
                      if (laporan.idAttendance == null || 
                          laporan.checkIn == null || 
                          laporan.checkOut == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data absensi belum lengkap. Detail tidak dapat dibuka.'),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 3),
                          ),
                        );
                        return;
                      }
                      
                      // Ensure id is not empty before navigating
                      if (laporan.id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ID laporan tidak valid'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: _laporanBloc,
                            child: LaporanKegiatanDetailPage(
                              laporanId: laporan.id,
                              userRole: _currentUserRole,
                            ),
                          ),
                        ),
                      ).then((result) {
                        // Refresh list after returning from detail page
                        if (mounted) {
                          final search = _searchController.text.trim();
                          _laporanBloc.add(GetLaporanListEvent(
                            status: status,
                            search: search.isEmpty ? null : search,
                            userId: widget.userId,
                            start: 1,
                            length: 10,
                          ));
                        }
                      });
                    },
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
