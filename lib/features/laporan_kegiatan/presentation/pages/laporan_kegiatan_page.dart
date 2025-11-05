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

  @override
  void initState() {
    super.initState();

    _currentUserId = widget.userId ?? 'user_1';
    _currentUserRole = widget.userRole ?? UserRole.anggota;

    _laporanBloc = getIt<LaporanKegiatanBloc>();

    _tabController = TabController(length: 2, vsync: this);

    // Load initial data
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _laporanBloc.close();
    super.dispose();
  }

  void _loadData() {
    _laporanBloc.add(GetLaporanListEvent(
      status: LaporanStatus.menungguVerifikasi,
    ));
  }

  void _onTabChanged() {
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

  Color _getStatusColor(LaporanStatus status) {
    switch (status) {
      case LaporanStatus.menungguVerifikasi:
        return Colors.grey;
      case LaporanStatus.revisi:
        return Colors.orange;
      case LaporanStatus.terverifikasi:
        return const Color(0xFF1E3A8A); // Dark blue
    }
  }

  String _formatJamKerja(String jamKerja) {
    return jamKerja;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaporanKegiatanBloc>.value(
      value: _laporanBloc,
      child: AppScaffold(
        backgroundColor: Colors.grey[50],
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
            style: TS.titleLarge.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            onTap: (_) => _onTabChanged(),
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Menunggu Verifikasi'),
              Tab(text: 'Terverifikasi'),
            ],
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: REdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: REdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
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
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LaporanError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                16.verticalSpace,
                UIButton(
                  text: 'Retry',
                  onPressed: () => _loadData(),
                ),
              ],
            ),
          );
        }

        if (state is LaporanListLoaded) {
          if (state.laporanList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 64.sp, color: Colors.grey),
                  16.verticalSpace,
                  Text(
                    'Tidak ditemukan',
                    style: TS.titleMedium.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: REdgeInsets.all(16),
            itemCount: state.laporanList.length,
            itemBuilder: (context, index) {
              final laporan = state.laporanList[index];
              return LaporanCard(
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
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
