import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/security/security_manager.dart';
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
  TabController? _tabController;
  String? _currentUserId;
  UserRole? _currentUserRole;
  late CutiBloc _cutiBloc;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize bloc
    _cutiBloc = getIt<CutiBloc>();

    // Load user data from secure storage
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    // Get userId from secure storage
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
    _currentUserId = widget.userId ?? userId ?? 'user_1';

    // Get user role from secure storage
    final roleId = await SecurityManager.readSecurely('user_role_id');
    _currentUserRole = widget.userRole ??
        (roleId != null ? UserRole.fromValue(roleId) : UserRole.anggota);

    print(
        '🔐 Initialized Cuti page with userId: $_currentUserId, role: $_currentUserRole');

    // Initialize tab controller based on user role
    _tabController = TabController(
      length: _getTabCount(),
      vsync: this,
    );

    // Load initial data
    _loadInitialData();

    // Refresh UI after loading user data
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _cutiBloc.close();
    super.dispose();
  }

  int _getTabCount() {
    final role = _currentUserRole ?? UserRole.anggota;
    switch (role) {
      case UserRole.anggota:
      case UserRole.danton:
        return 2; // Kuota Cuti, Ajuan Cuti
      case UserRole.pjo:
      case UserRole.deputy:
        return 3; // Ajuan Anggota, Kuota Cuti, Ajuan Saya
      case UserRole.pengawas:
      case UserRole.admin:
        return 2; // Ajuan Cuti, Rekap Ajuan Cuti
    }
  }

  List<Tab> _getTabs() {
    final role = _currentUserRole ?? UserRole.anggota;
    switch (role) {
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
      case UserRole.admin:
        return [
          Tab(text: 'Ajuan Cuti'),
          Tab(text: 'Rekap Ajuan Cuti'),
        ];
    }
  }

  void _loadInitialData() {
    final role = _currentUserRole ?? UserRole.anggota;
    final userId = _currentUserId ?? 'user_1';

    switch (role) {
      case UserRole.anggota:
      case UserRole.danton:
        _cutiBloc.add(GetCutiKuotaEvent(userId));
        break;
      case UserRole.pjo:
      case UserRole.deputy:
        _cutiBloc.add(const GetDaftarCutiAnggotaEvent());
        break;
      case UserRole.pengawas:
      case UserRole.admin:
        _cutiBloc.add(const GetDaftarCutiAnggotaEvent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while initializing
    if (!_isInitialized || _tabController == null) {
      return AppScaffold(
        appBar: AppBar(
          title: const Text('Pengajuan Cuti'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                controller: _tabController!,
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
                controller: _tabController!,
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
    final role = _currentUserRole ?? UserRole.anggota;
    switch (role) {
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
      case UserRole.admin:
        return [
          _buildAjuanCutiPengawasTab(),
          _buildRekapAjuanCutiTab(),
        ];
    }
  }

  void _onTabChanged(int index) {
    final role = _currentUserRole ?? UserRole.anggota;
    final userId = _currentUserId ?? 'user_1';

    switch (role) {
      case UserRole.anggota:
      case UserRole.danton:
        if (index == 0) {
          _cutiBloc.add(GetCutiKuotaEvent(userId));
        } else if (index == 1) {
          _cutiBloc.add(GetDaftarCutiSayaEvent(userId));
        }
        break;
      case UserRole.pjo:
      case UserRole.deputy:
        if (index == 0) {
          _cutiBloc.add(const GetDaftarCutiAnggotaEvent());
        } else if (index == 1) {
          _cutiBloc.add(GetCutiKuotaEvent(userId));
        } else if (index == 2) {
          _cutiBloc.add(GetDaftarCutiSayaEvent(userId));
        }
        break;
      case UserRole.pengawas:
      case UserRole.admin:
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
    final role = _currentUserRole ?? UserRole.anggota;
    final tabIndex = _tabController?.index ?? 0;

    return role == UserRole.anggota ||
        role == UserRole.danton ||
        (role == UserRole.pjo && tabIndex == 2) ||
        (role == UserRole.deputy && tabIndex == 2);
  }

  Widget _buildFab() {
    final userId = _currentUserId ?? 'user_1';

    return FloatingActionButton(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _cutiBloc,
              child: FormAjuanCutiPage(
                userId: userId,
                userName: 'Current User', // TODO: Get from auth
              ),
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
                  builder: (context) => BlocProvider.value(
                    value: _cutiBloc,
                    child: DetailCutiPage(
                      cutiId: cuti.id,
                      showActions: showActions,
                      currentUserRole: _currentUserRole ?? UserRole.anggota,
                    ),
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
