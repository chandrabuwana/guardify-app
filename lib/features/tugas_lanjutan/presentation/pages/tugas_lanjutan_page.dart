import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
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

  @override
  void initState() {
    super.initState();

    _currentUserId = widget.userId ?? 'user_1';
    _bloc = getIt<TugasLanjutanBloc>();

    _tabController = TabController(length: 2, vsync: this);

    // Load initial data
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _loadData() {
    _bloc.add(GetTugasLanjutanListEvent(
      filterByToday: _tabController.index == 0,
      userId: _currentUserId,
    ));
    _bloc.add(GetProgressSummaryEvent(userId: _currentUserId));
  }

  void _onTabChanged() {
    _bloc.add(GetTugasLanjutanListEvent(
      filterByToday: _tabController.index == 0,
      userId: _currentUserId,
    ));
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
            onTap: (_) => _onTabChanged(),
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Hari Ini'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        child: Column(
          children: [
            // Progress Indicator (only for Hari Ini tab)
            if (_tabController.index == 0)
              BlocBuilder<TugasLanjutanBloc, TugasLanjutanState>(
                builder: (context, state) {
                  if (state is TugasLanjutanProgressLoaded) {
                    return ProgressIndicatorWidget(summary: state.summary);
                  }
                  return const SizedBox.shrink();
                },
              ),

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
                  _buildTugasList(filterByToday: true),
                  _buildTugasList(filterByToday: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasList({required bool filterByToday}) {
    return BlocBuilder<TugasLanjutanBloc, TugasLanjutanState>(
      builder: (context, state) {
        if (state is TugasLanjutanLoading) {
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

        if (state is TugasLanjutanListLoaded) {
          // Filter by today if needed
          final filteredList = filterByToday
              ? state.tugasList.where((tugas) {
                  final today = DateTime.now();
                  return tugas.tanggal.year == today.year &&
                      tugas.tanggal.month == today.month &&
                      tugas.tanggal.day == today.day;
                }).toList()
              : state.tugasList;

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

        return const SizedBox();
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
  final _lokasiController = TextEditingController();
  final _catatanController = TextEditingController();
  String _buktiUrl = '';

  @override
  void initState() {
    super.initState();
    _lokasiController.text = widget.tugas.lokasi;
  }

  @override
  void dispose() {
    _lokasiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _handleSelesaikan() {
    if (_formKey.currentState!.validate()) {
      // In real implementation, upload file and get URL
      // For now, use placeholder
      if (_buktiUrl.isEmpty) {
        _buktiUrl = 'bukti.jpg';
      }

      widget.bloc.add(SelesaikanTugasEvent(
        id: widget.tugas.id,
        lokasi: _lokasiController.text,
        buktiUrl: _buktiUrl,
        catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
        userId: widget.userId,
        userName: 'Current User', // Should get from context
      ));

      // Listen to bloc state changes
      widget.bloc.stream.listen((state) {
        if (state is TugasLanjutanUpdated) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tugas berhasil diselesaikan'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is TugasLanjutanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
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
                      // Lokasi
                      Text(
                        'Lokasi*',
                        style: TS.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.verticalSpace,
                      TextFormField(
                        controller: _lokasiController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan lokasi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi wajib diisi';
                          }
                          return null;
                        },
                      ),

                      16.verticalSpace,

                      // Tugas - Status
                      Row(
                        children: [
                          Text(
                            'Tugas - ',
                            style: TS.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.tugas.status == TugasLanjutanStatus.belum
                                ? 'Belum'
                                : 'Selesai',
                            style: TS.labelMedium.copyWith(
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
                      Container(
                        constraints: BoxConstraints(maxHeight: 150.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: SingleChildScrollView(
                          padding: REdgeInsets.all(12),
                          child: Text(
                            widget.tugas.deskripsi,
                            style: TS.bodyMedium,
                          ),
                        ),
                      ),

                      16.verticalSpace,

                      // Bukti Penyelesaian
                      Text(
                        'Bukti Penyelesaian*',
                        style: TS.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Lokasi Kejadian ---',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.camera_alt),
                                      onPressed: () {
                                        // Handle camera
                                        _buktiUrl = 'bukti.jpg';
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.attach_file),
                                      onPressed: () {
                                        // Handle file attachment
                                        _buktiUrl = 'bukti.jpg';
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              validator: (value) {
                                if (_buktiUrl.isEmpty) {
                                  return 'Bukti wajib diisi';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      16.verticalSpace,

                      // Catatan
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
                          hintText: 'Lokasi Kejadian ---',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),

                      16.verticalSpace,

                      // Diselesaikan Oleh
                      Text(
                        'Diselesaikan Oleh',
                        style: TS.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.verticalSpace,
                      TextFormField(
                        initialValue: 'Current User',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        enabled: false,
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
                      onPressed: _handleSelesaikan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: REdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
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

