import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../bloc/tugas_lanjutan_bloc.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';
import '../widgets/tugas_lanjutan_card.dart';
import '../widgets/progress_indicator_widget.dart';

class TugasLanjutanPage extends StatefulWidget {
  final String? userId;

  const TugasLanjutanPage({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<TugasLanjutanPage> createState() => _TugasLanjutanPageState();
}

class _TugasLanjutanPageState extends State<TugasLanjutanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _currentUserId;
  late TugasLanjutanBloc _bloc;
  UserRole? _userRole;
  bool _isHighAccessRole = false; // danton, pjo, deputy
  bool _isPengawas = false; // pengawas
  bool _hasLoadedHariIni = false; // Flag to track if "Hari Ini" data has been loaded
  List<TugasLanjutanEntity>? _cachedHariIniList; // Cache for "Hari Ini" tab data
  Map<String, dynamic>? _cachedProgressSummary; // Cache for progress summary
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _currentUserId = widget.userId ?? 'user_1';
    _bloc = getIt<TugasLanjutanBloc>();

    _tabController = TabController(length: 2, vsync: this);
    
    // Add listener to reload data when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabChanged();
      }
    });

    // Load user role and determine tab structure
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final userRole = await UserRoleHelper.getUserRole();
    setState(() {
      _userRole = userRole;
      _isHighAccessRole = userRole == UserRole.danton ||
          userRole == UserRole.pjo ||
          userRole == UserRole.deputy;
      _isPengawas = userRole == UserRole.pengawas;
    });

    // Load initial data after role is loaded
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _loadData() {
    if (_userRole == null) return; // Wait for role to load

    if (_isPengawas) {
      // For pengawas: Tab 0 = "PJO/Deputy", Tab 1 = "Anggota"
      if (_tabController.index == 0) {
        // Tab "PJO/Deputy": Filter by Jabatan = "PJO"
        _bloc.add(GetTugasLanjutanListEvent(
          filterByToday: false,
          userId: _currentUserId,
          filterByJabatan: true,
          jabatan: 'PJO',
        ));
      } else {
        // Tab "Anggota": Filter by Jabatan = "Anggota"
        _bloc.add(GetTugasLanjutanListEvent(
          filterByToday: false,
          userId: _currentUserId,
          filterByJabatan: true,
          jabatan: 'Anggota',
        ));
      }
    } else if (_isHighAccessRole) {
      // For danton, pjo, deputy: Tab 0 = "Tugas Saya", Tab 1 = "Tugas Anggota"
      if (_tabController.index == 0) {
        // Tab "Tugas Saya": Filter by reportId (userId) and status
        _bloc.add(GetTugasLanjutanListEvent(
          filterByToday: false,
          userId: _currentUserId,
          filterByJabatan: false,
          status: 'closed', // Add status filter for Tugas Saya tab
        ));
      } else {
        // Tab "Tugas Anggota": Filter by Jabatan = "Anggota"
        _bloc.add(GetTugasLanjutanListEvent(
          filterByToday: false,
          userId: _currentUserId,
          filterByJabatan: true,
          jabatan: 'Anggota',
        ));
      }
    } else {
      // For anggota: Tab 0 = "Hari Ini", Tab 1 = "Riwayat"
      if (_tabController.index == 0) {
        // Tab "Hari Ini": Only load if not already loaded
        if (!_hasLoadedHariIni) {
          // Load from get_current_task API first
          _bloc.add(GetTugasLanjutanListEvent(
            filterByToday: true, // This triggers getCurrentTask API call
            userId: _currentUserId,
          ));
          // Progress summary will be loaded after list is loaded (handled in bloc)
          _hasLoadedHariIni = true; // Mark as loaded
        }
        // If already loaded, just use existing cached data (no reload needed)
        // The UI will use cached data from _cachedHariIniList
      } else {
        // Tab "Riwayat": Filter by SolverId
        _bloc.add(GetTugasLanjutanListEvent(
          filterByToday: false,
          userId: _currentUserId,
        ));
      }
    }
  }

  void _onTabChanged() {
    // Reset search when tab changes
    _searchController.clear();
    _bloc.add(SearchTugasLanjutanEvent(''));
    _loadData();
    // Rebuild to update search hint text
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TugasLanjutanBloc>.value(
      value: _bloc,
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
            'Tugas Lanjutan',
            style: TS.titleLarge.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: _isPengawas
                ? const [
                    Tab(text: 'PJO / Deputy'),
                    Tab(text: 'Anggota'),
                  ]
                : _isHighAccessRole
                    ? const [
                        Tab(text: 'Tugas Saya'),
                        Tab(text: 'Tugas Anggota'),
                      ]
                    : const [
                        Tab(text: 'Hari Ini'),
                        Tab(text: 'Riwayat'),
                      ],
          ),
        ),
        child: BlocListener<TugasLanjutanBloc, TugasLanjutanState>(
          listener: (context, state) {
            // When task is completed, refresh data for "Hari Ini" tab
            if (state is TugasLanjutanUpdated) {
              if (!_isHighAccessRole && !_isPengawas && _tabController.index == 0) {
                // Clear cache and reload
                setState(() {
                  _cachedHariIniList = null;
                  _cachedProgressSummary = null;
                  _hasLoadedHariIni = false;
                });
                _loadData();
              }
            }
          },
          child: Column(
            children: [
              // Progress Indicator (only for "Hari Ini" tab for anggota, and only if there's data)
              if (!_isHighAccessRole && !_isPengawas)
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    // Only show progress indicator for "Hari Ini" tab (index 0)
                    if (_tabController.index != 0) {
                      return const SizedBox.shrink();
                    }
                    
                    return BlocBuilder<TugasLanjutanBloc, TugasLanjutanState>(
                      builder: (context, state) {
                        // Check if there's data and progress summary
                        Map<String, dynamic>? summaryToShow;
                        
                        if (state is TugasLanjutanListAndProgressLoaded) {
                          summaryToShow = state.summary;
                          _cachedProgressSummary = state.summary; // Cache progress summary
                        } else if (state is TugasLanjutanProgressLoaded) {
                          summaryToShow = state.summary;
                          _cachedProgressSummary = state.summary; // Cache progress summary
                        } else if (_cachedProgressSummary != null) {
                          // Use cached progress summary if available
                          summaryToShow = _cachedProgressSummary;
                        }
                        
                        if (summaryToShow != null) {
                          final total = summaryToShow['total'] as int? ?? 0;
                          // Only show progress indicator if there's data (total > 0)
                          if (total > 0) {
                            return ProgressIndicatorWidget(summary: summaryToShow);
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),

              // Search Bar
              Container(
                padding: REdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, child) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              // Determine hint text based on current tab
                              String hintText = 'Cari tugas lanjutan...';
                              if (!_isPengawas && !_isHighAccessRole) {
                                // For anggota: Tab 0 = "Hari Ini", Tab 1 = "Riwayat"
                                hintText = _tabController.index == 0
                                    ? 'Cari tugas hari ini...'
                                    : 'Cari riwayat tugas...';
                              }
                              
                              return TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {}); // Rebuild to show/hide clear button
                                  _bloc.add(SearchTugasLanjutanEvent(value));
                                },
                                decoration: InputDecoration(
                                  hintText: hintText,
                                  prefixIcon:
                                      const Icon(Icons.search, color: Colors.grey),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, color: Colors.grey),
                                          onPressed: () {
                                            _searchController.clear();
                                            _bloc.add(SearchTugasLanjutanEvent(''));
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: REdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              );
                            },
                          );
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
                  children: _isPengawas
                      ? [
                          // Tab "PJO/Deputy" - filter by Jabatan = "PJO"
                          _buildTugasList(
                            filterByToday: false,
                            filterByJabatan: true,
                            jabatan: 'PJO',
                          ),
                          // Tab "Anggota" - filter by Jabatan = "Anggota"
                          _buildTugasList(
                            filterByToday: false,
                            filterByJabatan: true,
                            jabatan: 'Anggota',
                          ),
                        ]
                      : _isHighAccessRole
                          ? [
                              // Tab "Tugas Saya" - filter by reportId
                              _buildTugasList(
                                filterByToday: false,
                                filterByJabatan: false,
                              ),
                              // Tab "Tugas Anggota" - filter by Jabatan = "Anggota"
                              _buildTugasList(
                                filterByToday: false,
                                filterByJabatan: true,
                                jabatan: 'Anggota',
                              ),
                            ]
                          : [
                              // Tab "Hari Ini" - from get_current_task
                              _buildTugasList(filterByToday: true),
                              // Tab "Riwayat" - filter by reportId
                              _buildTugasList(filterByToday: false),
                            ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTugasList({
    required bool filterByToday,
    bool filterByJabatan = false,
    String? jabatan,
  }) {
    return BlocBuilder<TugasLanjutanBloc, TugasLanjutanState>(
      builder: (context, state) {
        // For "Hari Ini" tab, always prioritize cached data if available
        if (filterByToday && _cachedHariIniList != null && _cachedHariIniList!.isNotEmpty) {
          print('📋 _buildTugasList: Using cached data for "Hari Ini" tab: ${_cachedHariIniList!.length} tasks');
          return ListView.builder(
            padding: REdgeInsets.all(16),
            itemCount: _cachedHariIniList!.length,
            itemBuilder: (context, index) {
              final tugas = _cachedHariIniList![index];
              return TugasLanjutanCard(
                tugas: tugas,
                onTap: () {
                  _showSelesaikanDialog(context, tugas);
                },
              );
            },
          );
        }

        if (state is TugasLanjutanLoading) {
          // If we have cached data for "Hari Ini" tab, show it while loading
          if (filterByToday && _cachedHariIniList != null) {
            return ListView.builder(
              padding: REdgeInsets.all(16),
              itemCount: _cachedHariIniList!.length,
              itemBuilder: (context, index) {
                final tugas = _cachedHariIniList![index];
                return TugasLanjutanCard(
                  tugas: tugas,
                  onTap: () {
                    _showSelesaikanDialog(context, tugas);
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TugasLanjutanError) {
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

        // Check if both list and progress are loaded (combined state)
        if (state is TugasLanjutanListAndProgressLoaded) {
          final filteredList = state.filteredList;
          
          // Cache the original list and progress for "Hari Ini" tab (not filtered)
          if (filterByToday) {
            _cachedHariIniList = state.tugasList;
            _cachedProgressSummary = state.summary;
            print('📋 _buildTugasList: Cached ${state.tugasList.length} tasks and progress summary for "Hari Ini" tab');
          }
          
          // Debug: Print list length
          print('📋 _buildTugasList (ListAndProgress): filteredList.length = ${filteredList.length}, filterByToday = $filterByToday');
          print('📋 _buildTugasList: Progress summary = ${state.summary}');

          if (filteredList.isEmpty) {
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
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final tugas = filteredList[index];
              return TugasLanjutanCard(
                tugas: tugas,
                onTap: () {
                  _showSelesaikanDialog(context, tugas);
                },
              );
            },
          );
        }

        // Check if list is loaded
        if (state is TugasLanjutanListLoaded) {
          final filteredList = state.filteredList;
          
          // Cache the original list for "Hari Ini" tab (not filtered)
          if (filterByToday) {
            _cachedHariIniList = state.tugasList;
            print('📋 _buildTugasList: Cached ${state.tugasList.length} tasks for "Hari Ini" tab');
          }
          
          // Debug: Print list length
          print('📋 _buildTugasList (ListLoaded): filteredList.length = ${filteredList.length}, filterByToday = $filterByToday');
          print('📋 _buildTugasList: State type = ${state.runtimeType}');

          if (filteredList.isEmpty) {
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
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final tugas = filteredList[index];
              return TugasLanjutanCard(
                tugas: tugas,
                onTap: () {
                  _showSelesaikanDialog(context, tugas);
                },
              );
            },
          );
        }

        // If only progress is loaded but list is not, show cached data if available
        if (state is TugasLanjutanProgressLoaded) {
          if (filterByToday && _cachedHariIniList != null) {
            return ListView.builder(
              padding: REdgeInsets.all(16),
              itemCount: _cachedHariIniList!.length,
              itemBuilder: (context, index) {
                final tugas = _cachedHariIniList![index];
                return TugasLanjutanCard(
                  tugas: tugas,
                  onTap: () {
                    _showSelesaikanDialog(context, tugas);
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        }

        // Initial state or other states - show cached data if available for "Hari Ini"
        if (filterByToday && _cachedHariIniList != null) {
          print('📋 _buildTugasList: Using cached data, ${_cachedHariIniList!.length} tasks');
          return ListView.builder(
            padding: REdgeInsets.all(16),
            itemCount: _cachedHariIniList!.length,
            itemBuilder: (context, index) {
              final tugas = _cachedHariIniList![index];
              return TugasLanjutanCard(
                tugas: tugas,
                onTap: () {
                  _showSelesaikanDialog(context, tugas);
                },
              );
            },
          );
        }

        // Debug: Log current state
        print('📋 _buildTugasList: No data to display. State = ${state.runtimeType}, filterByToday = $filterByToday, cached = ${_cachedHariIniList != null}');
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showSelesaikanDialog(
    BuildContext context,
    TugasLanjutanEntity tugas,
  ) {
    if (tugas.status == TugasLanjutanStatus.selesai) {
      // Already completed, show read-only view
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _SelesaikanTugasDialog(
        tugas: tugas,
        userId: _currentUserId,
        bloc: _bloc,
      ),
    );
  }
}

class _SelesaikanTugasDialog extends StatefulWidget {
  final TugasLanjutanEntity tugas;
  final String userId;
  final TugasLanjutanBloc bloc;

  const _SelesaikanTugasDialog({
    required this.tugas,
    required this.userId,
    required this.bloc,
  });

  @override
  State<_SelesaikanTugasDialog> createState() => _SelesaikanTugasDialogState();
}

class _SelesaikanTugasDialogState extends State<_SelesaikanTugasDialog> {
  final _formKey = GlobalKey<FormState>();
  final _catatanController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      // Request camera permission
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akses kamera ditolak'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Initialize cameras if not already done
      if (_cameras == null) {
        _cameras = await availableCameras();
      }

      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kamera tidak tersedia'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Navigate to camera capture page
      final result = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
          builder: (_) => _CameraCapturePage(cameras: _cameras!),
        ),
      );

      if (result != null && mounted) {
        setState(() {
          _imageFile = File(result.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto berhasil diambil'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mengambil foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleSelesaikan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap ambil foto bukti penyelesaian terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // In real implementation, upload file and get URL
    // For now, use file path as placeholder
    final buktiUrl = _imageFile!.path;

    widget.bloc.add(SelesaikanTugasEvent(
      id: widget.tugas.id,
      lokasi: widget.tugas.lokasi, // Ambil dari data tugas lanjutan
      buktiUrl: buktiUrl,
      catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
      userId: widget.userId,
      userName: 'Current User', // Should get from context
    ));

    // Listen to bloc state changes
    widget.bloc.stream.listen((state) {
      if (state is TugasLanjutanUpdated) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil diselesaikan'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (state is TugasLanjutanError) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        color: Colors.white,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.tugas.title,
                      style: TS.titleLarge.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: REdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lokasi (Read-only dari data tugas lanjutan)
                      Text(
                        'Lokasi',
                        style: TS.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: REdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          widget.tugas.lokasi,
                          style: TS.bodyMedium.copyWith(
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      16.verticalSpace,

                      // Tugas - Status (Read-only dari data tugas lanjutan)
                      Text(
                        'Tugas',
                        style: TS.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: REdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Status: ',
                                  style: TS.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.tugas.status == TugasLanjutanStatus.belum
                                      ? 'Belum'
                                      : 'Selesai',
                                  style: TS.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: widget.tugas.status ==
                                            TugasLanjutanStatus.belum
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            8.verticalSpace,
                            Text(
                              'Deskripsi:',
                              style: TS.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              widget.tugas.deskripsi,
                              style: TS.bodyMedium.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      16.verticalSpace,

                      // Bukti Penyelesaian (dengan kamera)
                      Row(
                        children: [
                          Text(
                            'Bukti Penyelesaian',
                            style: TS.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: REdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _imageFile != null
                                    ? 'Foto telah diambil'
                                    : 'Belum ada foto',
                                style: TS.bodyMedium.copyWith(
                                  color: _imageFile != null
                                      ? Colors.green[700]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: primaryColor,
                              ),
                              onPressed: _isLoading ? null : _pickImage,
                              tooltip: 'Ambil Foto',
                            ),
                          ],
                        ),
                      ),
                      
                      // Photo Preview
                      if (_imageFile != null) ...[
                        8.verticalSpace,
                        Container(
                          width: double.infinity,
                          height: 200.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.file(
                                  _imageFile!,
                                  width: double.infinity,
                                  height: 200.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      16.verticalSpace,

                      // Catatan (bisa diisi user)
                      Text(
                        'Catatan',
                        style: TS.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.verticalSpace,
                      TextFormField(
                        controller: _catatanController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Masukkan catatan (opsional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),

                      16.verticalSpace,

                      // Diselesaikan Oleh (Read-only dari data tugas lanjutan)
                      Text(
                        'Diselesaikan Oleh',
                        style: TS.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: REdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Current User', // Should get from context
                          style: TS.bodyMedium.copyWith(
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor),
                        padding: REdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TS.labelLarge.copyWith(color: primaryColor),
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSelesaikan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: REdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Selesaikan',
                              style: TS.labelLarge.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Camera Capture Page
class _CameraCapturePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const _CameraCapturePage({
    required this.cameras,
  });

  @override
  State<_CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<_CameraCapturePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Foto Bukti Penyelesaian'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Kembali'),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: CameraPreview(_controller),
                ),
                Container(
                  height: 120,
                  color: Colors.black,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;
                          final image = await _controller.takePicture();
                          if (mounted) {
                            Navigator.of(context).pop(image);
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

