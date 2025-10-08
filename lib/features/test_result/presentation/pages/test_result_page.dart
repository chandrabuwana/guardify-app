import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/test_result_bloc.dart';
import '../widgets/test_result_header_widget.dart';
import '../widgets/test_result_card_widget.dart';
import '../widgets/test_result_table_widget.dart';

/// Halaman utama untuk menampilkan Hasil Test
/// Menampilkan view berbeda berdasarkan role pengguna:
/// - PJO/Deputy/Pengawas: Tab bar dengan "Test Saya" & "Test Anggota"
/// - Danton: Tab bar dengan "Test Saya" & "Test Anggota"
/// - Anggota: Hanya Tab "Test Saya"
class TestResultPage extends StatefulWidget {
  final String userId;
  final UserRole userRole;

  const TestResultPage({
    Key? key,
    required this.userId,
    required this.userRole,
  }) : super(key: key);

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TestResultBloc _bloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = getIt<TestResultBloc>();
    
    // Initialize tab controller berdasarkan role
    final tabLength = _getTabLength();
    _tabController = TabController(length: tabLength, vsync: this);
    
    // Load data
    _bloc.add(FetchTestResultEvent(
      userId: widget.userId,
      role: widget.userRole,
    ));

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _bloc.add(SwitchTestTabEvent(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  int _getTabLength() {
    // Semua role punya tab kecuali Anggota yang nggak perlu tab
    return _canViewMemberResults() ? 2 : 1;
  }

  bool _canViewMemberResults() {
    return widget.userRole == UserRole.pjo ||
        widget.userRole == UserRole.deputy ||
        widget.userRole == UserRole.pengawas ||
        widget.userRole == UserRole.danton;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestResultBloc>(
      create: (context) => _bloc,
      child: AppScaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Hasil Test',
            style: TS.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: _canViewMemberResults()
              ? TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3.h,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: TS.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TS.titleSmall,
                  tabs: const [
                    Tab(text: 'Test Saya'),
                    Tab(text: 'Test Anggota'),
                  ],
                )
              : null,
        ),
        child: BlocBuilder<TestResultBloc, TestResultState>(
          builder: (context, state) {
            if (state is TestResultLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            if (state is TestResultError) {
              return _buildErrorWidget(state.message);
            }

            if (state is TestResultLoaded) {
              if (_canViewMemberResults()) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMyResultsTab(state),
                    _buildMemberResultsTab(state),
                  ],
                );
              } else {
                // Untuk anggota, langsung tampilkan my results tanpa tab
                return _buildMyResultsTab(state);
              }
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Tab "Test Saya"
  Widget _buildMyResultsTab(TestResultLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        _bloc.add(RefreshTestResultEvent(
          userId: widget.userId,
          role: widget.userRole,
        ));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Header (dengan atau tanpa Jml Lulus/Tidak Lulus)
            if (state.summary != null)
              TestResultHeaderWidget(
                summary: state.summary!,
                userRole: widget.userRole,
              ),

            16.verticalSpace,

            // List Hasil Test Saya
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Hasil Test',
                    style: TS.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: neutral90,
                    ),
                  ),
                  12.verticalSpace,
                  if (state.myResults.isEmpty)
                    _buildEmptyState('Belum ada hasil Test')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.myResults.length,
                      itemBuilder: (context, index) {
                        final result = state.myResults[index];
                        return TestResultCardWidget(result: result);
                      },
                    ),
                ],
              ),
            ),

            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  /// Tab "Test Anggota"
  Widget _buildMemberResultsTab(TestResultLoaded state) {
    return Column(
      children: [
        // Summary Header
        if (state.summary != null)
          TestResultHeaderWidget(
            summary: state.summary!,
            userRole: widget.userRole,
            showPassFailCount: true,
          ),

        16.verticalSpace,

        // Search & Filter
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    prefixIcon: const Icon(Icons.search, color: neutral50),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: neutral50),
                            onPressed: () {
                              _searchController.clear();
                              _bloc.add(const SearchTestEvent(''));
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: neutral30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: neutral30),
                    ),
                    contentPadding: REdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (query) {
                    _bloc.add(SearchTestEvent(query));
                  },
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
                  onPressed: () => _showFilterDialog(state),
                ),
              ),
            ],
          ),
        ),

        16.verticalSpace,

        // Table Hasil Test Anggota
        Expanded(
          child: state.filteredMemberResults.isEmpty
              ? _buildEmptyState('Tidak ada data yang sesuai')
              : TestResultTableWidget(
                  results: state.filteredMemberResults,
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: REdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64.w,
              color: neutral50,
            ),
            16.verticalSpace,
            Text(
              message,
              style: TS.bodyLarge.copyWith(
                color: neutral70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: REdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: errorColor,
            ),
            16.verticalSpace,
            Text(
              message,
              style: TS.bodyLarge.copyWith(
                color: neutral70,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () {
                _bloc.add(RefreshTestResultEvent(
                  userId: widget.userId,
                  role: widget.userRole,
                ));
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

  void _showFilterDialog(TestResultLoaded state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Filter Berdasarkan Jabatan',
          style: TS.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Semua'),
              leading: Radio<String?>(
                value: null,
                groupValue: state.selectedJabatan,
                onChanged: (value) {
                  _bloc.add(FilterTestByJabatanEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('Anggota'),
              leading: Radio<String?>(
                value: 'Anggota',
                groupValue: state.selectedJabatan,
                onChanged: (value) {
                  _bloc.add(FilterTestByJabatanEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('Danton'),
              leading: Radio<String?>(
                value: 'Danton',
                groupValue: state.selectedJabatan,
                onChanged: (value) {
                  _bloc.add(FilterTestByJabatanEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('Deputy'),
              leading: Radio<String?>(
                value: 'Deputy',
                groupValue: state.selectedJabatan,
                onChanged: (value) {
                  _bloc.add(FilterTestByJabatanEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('PJO'),
              leading: Radio<String?>(
                value: 'PJO',
                groupValue: state.selectedJabatan,
                onChanged: (value) {
                  _bloc.add(FilterTestByJabatanEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

