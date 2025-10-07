import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../bloc/cuti_bloc.dart';
import '../bloc/cuti_event.dart';
import '../bloc/cuti_state.dart';
import '../widgets/cuti_card.dart';
import '../widgets/kuota_cuti_card.dart';
import '../widgets/filter_cuti_widget.dart';
import 'form_ajuan_cuti_page.dart';
import 'detail_cuti_page.dart';
import '../../domain/entities/cuti_entity.dart';

class CutiPage extends StatefulWidget {
  final String? userId;
  final UserRole? userRole;

  const CutiPage({
    Key? key,
    this.userId,
    this.userRole,
  }) : super(key: key);

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _currentUserId;
  late UserRole _currentUserRole;
  late CutiBloc _cutiBloc;

  @override
  void initState() {
    super.initState();

    // Use passed parameters or defaults
    _currentUserId = widget.userId ?? 'user_1';
    _currentUserRole = widget.userRole ?? UserRole.anggota;

    // Initialize bloc
    _cutiBloc = getIt<CutiBloc>();

    // Initialize tab controller based on user role
    _tabController = TabController(
      length: _getTabCount(),
      vsync: this,
    );

    // Load initial data
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cutiBloc.close();
    super.dispose();
  }

  int _getTabCount() {
    switch (_currentUserRole) {
      case UserRole.anggota:
      case UserRole.danton:
        return 2; // Kuota Cuti, Ajuan Cuti
      case UserRole.pjo:
      case UserRole.deputy:
        return 3; // Ajuan Anggota, Kuota Cuti, Ajuan Saya
      case UserRole.pengawas:
        return 2; // Ajuan Cuti, Rekap Ajuan Cuti
    }
  }

  List<Tab> _getTabs() {
    switch (_currentUserRole) {
      case UserRole.anggota:
      case UserRole.danton:
        return [
          Tab(text: 'Kuota Cuti'),
          Tab(text: 'Ajuan Cuti'),
        ];
      case UserRole.pjo:
      case UserRole.deputy:
        return [
          Tab(text: 'Ajuan Anggota'),
          Tab(text: 'Kuota Cuti'),
          Tab(text: 'Ajuan Saya'),
        ];
      case UserRole.pengawas:
        return [
          Tab(text: 'Ajuan Cuti'),
          Tab(text: 'Rekap Ajuan Cuti'),
        ];
    }
  }

  void _loadInitialData() {
    switch (_currentUserRole) {
      case UserRole.anggota:
      case UserRole.danton:
        _cutiBloc.add(GetCutiKuotaEvent(_currentUserId));
        break;
      case UserRole.pjo:
      case UserRole.deputy:
        _cutiBloc.add(const GetDaftarCutiAnggotaEvent());
        break;
      case UserRole.pengawas:
        _cutiBloc.add(const GetDaftarCutiAnggotaEvent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cutiBloc,
      child: AppScaffold(
        appBar: AppBar(
          title: const Text('Pengajuan Cuti'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        enableScrolling: false,
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                indicatorWeight: 3.0,
                labelStyle: TS.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TS.titleSmall.copyWith(
                  fontWeight: FontWeight.normal,
                ),
                tabs: _getTabs(),
                onTap: (index) {
                  _onTabChanged(index);
                },
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _getTabViews(),
              ),
            ),
          ],
        ),
        floatingActionButton: _shouldShowFab() ? _buildFab() : null,
      ),
    );
  }

  List<Widget> _getTabViews() {
    switch (_currentUserRole) {
      case UserRole.anggota:
      case UserRole.danton:
        return [
          _buildKuotaCutiTab(),
          _buildAjuanCutiTab(),
        ];
      case UserRole.pjo:
      case UserRole.deputy:
        return [
          _buildAjuanAnggotaTab(),
          _buildKuotaCutiTab(),
          _buildAjuanSayaTab(),
        ];
      case UserRole.pengawas:
        return [
          _buildAjuanCutiPengawasTab(),
          _buildRekapAjuanCutiTab(),
        ];
    }
  }

  void _onTabChanged(int index) {
    switch (_currentUserRole) {
      case UserRole.anggota:
      case UserRole.danton:
        if (index == 0) {
          _cutiBloc.add(GetCutiKuotaEvent(_currentUserId));
        } else if (index == 1) {
          _cutiBloc.add(GetDaftarCutiSayaEvent(_currentUserId));
        }
        break;
      case UserRole.pjo:
      case UserRole.deputy:
        if (index == 0) {
          _cutiBloc.add(const GetDaftarCutiAnggotaEvent());
        } else if (index == 1) {
          _cutiBloc.add(GetCutiKuotaEvent(_currentUserId));
        } else if (index == 2) {
          _cutiBloc.add(GetDaftarCutiSayaEvent(_currentUserId));
        }
        break;
      case UserRole.pengawas:
        if (index == 0) {
          _cutiBloc.add(const GetDaftarCutiAnggotaEvent());
        } else if (index == 1) {
          _cutiBloc.add(const GetRekapCutiEvent());
        }
        break;
    }
  }

  bool _shouldShowFab() {
    // Show FAB for anggota/danton and PJO/Deputy (for their personal leave)
    return _currentUserRole == UserRole.anggota ||
        _currentUserRole == UserRole.danton ||
        (_currentUserRole == UserRole.pjo && _tabController.index == 2) ||
        (_currentUserRole == UserRole.deputy && _tabController.index == 2);
  }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormAjuanCutiPage(
              userId: _currentUserId,
              userName: 'Current User', // TODO: Get from auth
            ),
          ),
        );
      },
      child: Icon(Icons.add, size: 24.sp),
    );
  }

  // Tab view builders
  Widget _buildKuotaCutiTab() {
    return BlocBuilder<CutiBloc, CutiState>(
      builder: (context, state) {
        if (state is CutiLoading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state is CutiError) {
          return _buildErrorWidget(state.message);
        }

        if (state is CutiKuotaLoaded) {
          return SingleChildScrollView(
            padding: REdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KuotaCutiCard(kuota: state.kuota),
                24.verticalSpace,
                Text(
                  'Informasi Kuota Cuti',
                  style: TS.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                16.verticalSpace,
                _buildInfoCard(
                  'Total kuota cuti per tahun adalah 12 hari kerja. '
                  'Kuota akan direset setiap awal tahun. '
                  'Pastikan untuk menggunakan cuti dengan bijak.',
                ),
              ],
            ),
          );
        }

        return _buildEmptyState('Belum ada data kuota cuti');
      },
    );
  }

  Widget _buildAjuanCutiTab() {
    return BlocBuilder<CutiBloc, CutiState>(
      builder: (context, state) {
        if (state is CutiLoading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state is CutiError) {
          return _buildErrorWidget(state.message);
        }

        if (state is DaftarCutiSayaLoaded) {
          if (state.daftarCuti.isEmpty) {
            return _buildEmptyState('Belum ada ajuan cuti');
          }

          return _buildCutiList(state.daftarCuti, false);
        }

        return _buildEmptyState('Belum ada ajuan cuti');
      },
    );
  }

  Widget _buildAjuanSayaTab() {
    return BlocBuilder<CutiBloc, CutiState>(
      builder: (context, state) {
        if (state is CutiLoading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state is CutiError) {
          return _buildErrorWidget(state.message);
        }

        if (state is DaftarCutiSayaLoaded) {
          if (state.daftarCuti.isEmpty) {
            return _buildEmptyState('Belum ada ajuan cuti pribadi');
          }

          return _buildCutiList(state.daftarCuti, false);
        }

        return _buildEmptyState('Belum ada ajuan cuti pribadi');
      },
    );
  }

  Widget _buildAjuanAnggotaTab() {
    return BlocBuilder<CutiBloc, CutiState>(
      builder: (context, state) {
        if (state is CutiLoading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state is CutiError) {
          return _buildErrorWidget(state.message);
        }

        if (state is DaftarCutiAnggotaLoaded) {
          return Column(
            children: [
              FilterCutiWidget(
                onFilterApplied:
                    (status, tipeCuti, tanggalMulai, tanggalSelesai) {
                  _cutiBloc.add(
                    GetDaftarCutiAnggotaEvent(
                      status: status,
                      tipeCuti: tipeCuti,
                      tanggalMulai: tanggalMulai,
                      tanggalSelesai: tanggalSelesai,
                    ),
                  );
                },
              ),
              Expanded(
                child: state.daftarCuti.isEmpty
                    ? _buildEmptyState('Belum ada ajuan cuti anggota')
                    : _buildCutiList(state.daftarCuti, true),
              ),
            ],
          );
        }

        return _buildEmptyState('Belum ada ajuan cuti anggota');
      },
    );
  }

  Widget _buildAjuanCutiPengawasTab() {
    return _buildAjuanAnggotaTab(); // Same as ajuan anggota for pengawas
  }

  Widget _buildRekapAjuanCutiTab() {
    return BlocBuilder<CutiBloc, CutiState>(
      builder: (context, state) {
        if (state is CutiLoading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state is CutiError) {
          return _buildErrorWidget(state.message);
        }

        if (state is RekapCutiLoaded) {
          return Column(
            children: [
              FilterCutiWidget(
                onFilterApplied:
                    (status, tipeCuti, tanggalMulai, tanggalSelesai) {
                  _cutiBloc.add(
                    GetRekapCutiEvent(
                      status: status,
                      tanggalMulai: tanggalMulai,
                      tanggalSelesai: tanggalSelesai,
                    ),
                  );
                },
              ),
              Expanded(
                child: state.rekapCuti.isEmpty
                    ? _buildEmptyState('Belum ada data rekap cuti')
                    : _buildCutiList(state.rekapCuti, true),
              ),
            ],
          );
        }

        return _buildEmptyState('Belum ada data rekap cuti');
      },
    );
  }

  Widget _buildCutiList(List<CutiEntity> cutiList, bool showActions) {
    return ListView.builder(
      padding: REdgeInsets.all(16),
      itemCount: cutiList.length,
      itemBuilder: (context, index) {
        final cuti = cutiList[index];
        return Padding(
          padding: REdgeInsets.only(bottom: 12),
          child: CutiCard(
            cuti: cuti,
            showActions: showActions,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailCutiPage(
                    cutiId: cuti.id,
                    showActions: showActions,
                    currentUserRole: _currentUserRole,
                  ),
                ),
              );
            },
            onApprove: showActions ? () => _showApprovalDialog(cuti) : null,
            onReject: showActions ? () => _showRejectionDialog(cuti) : null,
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.r,
            color: Colors.red,
          ),
          16.verticalSpace,
          Text(
            'Terjadi Kesalahan',
            style: TS.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          8.verticalSpace,
          Text(
            message,
            style: TS.bodyMedium.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          UIButton(
            text: 'Coba Lagi',
            onPressed: () {
              _loadInitialData();
            },
            size: UIButtonSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64.r,
            color: Colors.grey.shade400,
          ),
          16.verticalSpace,
          Text(
            message,
            style: TS.titleMedium.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TS.bodyMedium.copyWith(
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  void _showApprovalDialog(CutiEntity cuti) {
    // TODO: Implement approval dialog
  }

  void _showRejectionDialog(CutiEntity cuti) {
    // TODO: Implement rejection dialog
  }
}
