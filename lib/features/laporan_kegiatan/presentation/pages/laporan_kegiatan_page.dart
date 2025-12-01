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
  late String _currentUserId;
  late UserRole _currentUserRole;
  late LaporanKegiatanBloc _laporanBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _currentUserId = widget.userId ?? 'user_1';
    _currentUserRole = widget.userRole ?? UserRole.anggota;

    _laporanBloc = getIt<LaporanKegiatanBloc>();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load initial data
    _loadData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    _laporanBloc.close();
    super.dispose();
  }

  void _loadData() {
    _laporanBloc.add(GetLaporanListEvent(
      status: LaporanStatus.menungguVerifikasi,
    ));
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        _laporanBloc.add(GetLaporanListEvent(
          status: LaporanStatus.menungguVerifikasi,
        ));
      } else {
        _laporanBloc.add(GetLaporanListEvent(
          status: LaporanStatus.terverifikasi,
        ));
      }
    }
  }

  Color _getStatusColor(LaporanStatus status) {
    switch (status) {
      case LaporanStatus.menungguVerifikasi:
        return Colors.grey;
      case LaporanStatus.revisi:
        return Colors.orange;
      case LaporanStatus.terverifikasi:
        return const Color(0xFF1E88E5); // Blue
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
                      onPressed: () {
                        // Show filter sheet
                      },
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
                  _buildLaporanList(LaporanStatus.menungguVerifikasi),
                  _buildLaporanList(LaporanStatus.terverifikasi),
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
        if (state is LaporanLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }

        if (state is LaporanError) {
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
          // Filter by status
          final filteredList = state.laporanList
              .where((laporan) => laporan.status == status)
              .toList();

          if (filteredList.isEmpty) {
            return EmptyStateWidget(
              message: 'Tidak ditemukan',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _laporanBloc.add(GetLaporanListEvent(status: status));
            },
            color: primaryColor,
            child: ListView.builder(
              padding: REdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final laporan = filteredList[index];
                return Padding(
                  padding: REdgeInsets.only(bottom: 12),
                  child: LaporanCard(
                    laporan: laporan,
                    statusColor: _getStatusColor(laporan.status),
                    onTap: () {
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
                      );
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
