import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';
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
  final String? userId;
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
  String? _resolvedUserId;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<TestResultBloc>();

    // Initialize tab controller berdasarkan role
    final tabLength = _getTabLength();
    _tabController = TabController(length: tabLength, vsync: this);

    // Load data - jika userId tidak diberikan, ambil dari secure storage
    _initAndFetch().then((_) {
      // Setup tab listener SETELAH _resolvedUserId ter-set
      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          print('🔄 Tab switching to index: ${_tabController.index}');
          print('🔄 Resolved userId: $_resolvedUserId');
          _bloc.add(SwitchTestTabEvent(_tabController.index, userId: _resolvedUserId));
        }
      });
    });
  }

  Future<void> _initAndFetch() async {
    print('');
    print('📱 ========================================');
    print('📱 TEST RESULT PAGE: INIT & FETCH');
    print('📱 ========================================');
    
    String? userId = widget.userId;
    print('📱 Initial userId from widget: $userId');
    
    if (userId == null || userId.isEmpty) {
      print('📱 UserId is null/empty, reading from secure storage...');
      userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      print('📱 UserId from secure storage: $userId');
    } else {
      print('📱 Using userId from parameter: $userId');
    }

    if (userId == null || userId.isEmpty) {
      print('❌ ERROR: UserId still null/empty after reading from storage!');
      print('📱 Available keys in secure storage:');
      // Try to debug what's in secure storage
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      print('📱 - Token exists: ${token != null && token.isNotEmpty}');
    }

    _resolvedUserId = userId;

    final idToSend = _resolvedUserId ?? '';
    print('📱 Final userId to send to API: "$idToSend"');
    print('📱 UserId length: ${idToSend.length}');
    print('📱 User role: ${widget.userRole.displayName}');
    print('📱 User role value: ${widget.userRole.value}');
    print('📱 Is Danton? ${widget.userRole == UserRole.danton}');
    print('📱 Is Pengawas? ${widget.userRole == UserRole.pengawas}');
    print('📱 Can view member results? ${_canViewMemberResults()}');
    print('📱 Tab length: ${_getTabLength()}');
    
    // Debug: Print all available secure storage keys
    try {
      final allKeys = [
        AppConstants.tokenKey,
        AppConstants.userIdKey,
        'roleId',
        'user_role',
      ];
      for (final key in allKeys) {
        final value = await SecurityManager.readSecurely(key);
        print('📱 Storage[$key]: ${value != null ? '"${value.substring(0, value.length > 20 ? 20 : value.length)}..."' : 'null'}');
      }
    } catch (e) {
      print('📱 Error reading storage keys: $e');
    }
    
    print('📱 ========================================');
    print('');
    
    // Fetch initial data (my test results)
    _bloc.add(FetchTestResultEvent(userId: idToSend, role: widget.userRole));
    
    // Note: Member tests akan di-fetch otomatis saat user switch ke tab "Test Anggota"
    // Lihat _tabController.addListener dan SwitchTestTabEvent handler di BLoC
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
        enableScrolling: false,
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

  /// Tab "Test Saya" - Untuk Anggota dengan Search & Filter
  Widget _buildMyResultsTab(TestResultLoaded state) {
    return Column(
      children: [
        // Search & Filter Bar untuk Anggota
        16.verticalSpace,
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: primaryColor, width: 1.5),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari',
                      hintStyle: TS.bodyMedium.copyWith(color: neutral50),
                      prefixIcon: const Icon(Icons.search, color: primaryColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: neutral50),
                              onPressed: () {
                                _searchController.clear();
                                _bloc.add(const SearchMyTestEvent(''));
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: REdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (query) {
                      _bloc.add(SearchMyTestEvent(query));
                    },
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
                  onPressed: () => _showMyTestFilterDialog(state),
                ),
              ),
            ],
          ),
        ),

        16.verticalSpace,

        // List Hasil Test Saya
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _bloc.add(RefreshTestResultEvent(
                userId: _resolvedUserId ?? '',
                role: widget.userRole,
              ));
            },
            child: state.filteredMyResults.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _buildEmptyState(
                        state.searchQuery != null || state.selectedMyTestFilter != null
                            ? 'Tidak ada data yang sesuai'
                            : 'Belum ada hasil Test',
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: REdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.filteredMyResults.length,
                    itemBuilder: (context, index) {
                      final result = state.filteredMyResults[index];
                      return TestResultCardWidget(result: result);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  /// Tab "Test Anggota"
  Widget _buildMemberResultsTab(TestResultLoaded state) {
    print('');
    print('📺 ========================================');
    print('📺 BUILD MEMBER RESULTS TAB');
    print('📺 ========================================');
    print('📺 User role: ${widget.userRole.displayName}');
    print('📺 Is Danton: ${widget.userRole == UserRole.danton}');
    print('📺 Member tests count: ${state.memberTests.length}');
    print('📺 Filtered member tests count: ${state.filteredMemberTests.length}');
    print('📺 Is loading member results: ${state.isLoadingMemberResults}');
    print('📺 Member tests error: ${state.memberTestsError}');
    print('📺 Member results count (table): ${state.filteredMemberResults.length}');
    print('📺 ========================================');
    print('');
    
    // For Danton role, show card-based view like "Test Saya"
    if (widget.userRole == UserRole.danton) {
      return _buildDantonMemberTestsView(state);
    }
    
    // For other roles (PJO, Deputy, Pengawas)
    // Prefer showing fetched member tests (IdPic) as cards when available; fallback to table view
    if (state.filteredMemberTests.isNotEmpty || state.isLoadingMemberResults || state.memberTestsError != null) {
      print('📺 Showing card view for member tests');
      
      return Column(
        children: [
          16.verticalSpace,
          Expanded(
            child: state.isLoadingMemberResults
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : state.memberTestsError != null
                    ? _buildErrorWidget(state.memberTestsError!)
                    : state.filteredMemberTests.isEmpty
                        ? _buildEmptyState('Belum ada hasil test anggota')
                        : RefreshIndicator(
                            onRefresh: () async {
                              if (_resolvedUserId != null) {
                                _bloc.add(FetchMemberTestsEvent(_resolvedUserId!));
                              }
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: REdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.filteredMemberTests.length,
                              itemBuilder: (context, index) {
                                final result = state.filteredMemberTests[index];
                                return TestResultCardWidget(result: result);
                              },
                            ),
                          ),
          ),
        ],
      );
    }

    print('📺 Showing table view fallback');
    
    // Fallback: show table view (uses TestMemberResultEntity)
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

  /// View khusus untuk Danton - menampilkan test anggota dalam bentuk card
  Widget _buildDantonMemberTestsView(TestResultLoaded state) {
    return Column(
      children: [
        16.verticalSpace,
        
        // Search bar
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: primaryColor, width: 1.5),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari',
                hintStyle: TS.bodyMedium.copyWith(color: neutral50),
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: neutral50),
                        onPressed: () {
                          _searchController.clear();
                          // TODO: Add search event for member tests
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: REdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (query) {
                // TODO: Add search event for member tests
              },
            ),
          ),
        ),

        16.verticalSpace,

        // List Hasil Test Anggota
        Expanded(
          child: state.isLoadingMemberResults
              ? const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
              : state.memberTestsError != null
                  ? _buildErrorWidget(state.memberTestsError!)
                  : state.filteredMemberTests.isEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            if (_resolvedUserId != null) {
                              _bloc.add(FetchMemberTestsEvent(_resolvedUserId!));
                            }
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: _buildEmptyState('Belum ada hasil test anggota'),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            if (_resolvedUserId != null) {
                              _bloc.add(FetchMemberTestsEvent(_resolvedUserId!));
                            }
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: REdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.filteredMemberTests.length,
                            itemBuilder: (context, index) {
                              final result = state.filteredMemberTests[index];
                              return TestResultCardWidget(result: result);
                            },
                          ),
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
                  userId: _resolvedUserId ?? '',
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

  void _showMyTestFilterDialog(TestResultLoaded state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Filter Berdasarkan',
          style: TS.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Semua'),
              leading: Radio<String?>(
                value: null,
                groupValue: state.selectedMyTestFilter,
                onChanged: (value) {
                  _bloc.add(FilterMyTestEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('Lulus'),
              leading: Radio<String?>(
                value: 'lulus',
                groupValue: state.selectedMyTestFilter,
                onChanged: (value) {
                  _bloc.add(FilterMyTestEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('Tidak Lulus'),
              leading: Radio<String?>(
                value: 'tidak_lulus',
                groupValue: state.selectedMyTestFilter,
                onChanged: (value) {
                  _bloc.add(FilterMyTestEvent(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('Belum Dinilai'),
              leading: Radio<String?>(
                value: 'belum_dinilai',
                groupValue: state.selectedMyTestFilter,
                onChanged: (value) {
                  _bloc.add(FilterMyTestEvent(value));
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

