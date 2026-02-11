import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../../core/constants/enums.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/searchable_dropdown.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/incident_entity.dart';
import '../../data/datasources/incident_remote_datasource.dart';
import '../bloc/incident_bloc.dart';
import '../bloc/incident_event.dart';
import '../bloc/incident_state.dart';

class IncidentDetailPage extends StatefulWidget {
  final IncidentEntity incident;
  final bool isFromMyTasks; // true jika dari tab "Tugas Saya", false jika dari "Daftar Insiden"

  const IncidentDetailPage({
    super.key,
    required this.incident,
    required this.isFromMyTasks,
  });

  @override
  State<IncidentDetailPage> createState() => _IncidentDetailPageState();
}

class _IncidentDetailPageState extends State<IncidentDetailPage> {
  bool _hasLoadedDetail = false;
  bool _statusUpdated = false;
  UserRole? _userRole;
  bool _isPJOOrDeputy = false;
  bool _isDanton = false;
  bool _isPengawas = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await UserRoleHelper.getUserRole();
    setState(() {
      _userRole = role;
      _isPJOOrDeputy = role == UserRole.pjo || role == UserRole.deputy;
      _isDanton = role == UserRole.danton;
      _isPengawas = role == UserRole.pengawas;
      _isAdmin = role == UserRole.admin;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load detail from API when dependencies are available
    if (!_hasLoadedDetail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            final bloc = context.read<IncidentBloc>();
            bloc.add(GetIncidentDetailEvent(widget.incident.id));
            _hasLoadedDetail = true;
          } catch (e) {
            // If bloc is not available, that's okay - we'll use widget.incident data
            debugPrint('IncidentBloc not available: $e');
            _hasLoadedDetail = true; // Set to true to prevent retry
          }
        }
      });
    }
  }

  /// Convert IncidentStatus to API status string
  String _getApiStatus(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.menunggu:
        return 'OPEN';
      case IncidentStatus.tidakValid:
        return 'INVALID';
      case IncidentStatus.diterima:
        return 'ACKNOWLEDGE';
      case IncidentStatus.eskalasi:
        return 'ESCALATED';
      case IncidentStatus.ditugaskan:
        return 'ASSIGNED';
      case IncidentStatus.proses:
        return 'PROGRESS';
      case IncidentStatus.selesai:
        return 'COMPLETED';
      case IncidentStatus.terverifikasi:
        return 'VERIFIED';
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<IncidentBloc, IncidentState>(
      listener: (context, state) {
        if (state.errorMessage != null && !_statusUpdated) {
          // Only show error if not in the middle of an update operation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        // Only show success message when status is updated (not loading and no error after update)
        if (_statusUpdated && !state.isLoading && state.errorMessage == null) {
          _statusUpdated = false; // Reset flag
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Status berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate update
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Lapor Insiden Kejadian',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<IncidentBloc, IncidentState>(
          builder: (context, state) {
            // Use detail from API if available, otherwise use widget.incident
            final incident = state.incidentDetail ?? widget.incident;
            
            // Show loading indicator when loading detail for the first time
            if (_hasLoadedDetail && state.isLoading && state.incidentDetail == null) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            return SingleChildScrollView(
              padding: REdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'Insiden Kejadian',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  24.verticalSpace,

                  // Status
                  _buildReadOnlyField(
                    label: 'Status',
                    value: incident.statusDisplayName,
                  ),
                  20.verticalSpace,

                  // ID Insiden
                  _buildReadOnlyField(
                    label: 'ID Insiden',
                    value: incident.formattedId,
                  ),
                  20.verticalSpace,

                  // Pelapor
                  _buildReadOnlyField(
                    label: 'Pelapor',
                    value: incident.pelapor ?? '-',
                  ),
                  20.verticalSpace,

                  // Nama Danton
                  _buildReadOnlyField(
                    label: 'Nama Danton',
                    value: incident.namaDanton ?? '-',
                  ),
                  20.verticalSpace,

                  // Tanggal Insiden
                  _buildReadOnlyField(
                    label: 'Tanggal Insiden*',
                    value: incident.tanggalInsiden != null
                        ? DateFormat('dd/MM/yyyy', 'id_ID').format(incident.tanggalInsiden!)
                        : '-',
                  ),
                  20.verticalSpace,

                  // Jam Insiden
                  _buildReadOnlyField(
                    label: 'Jam Insiden*',
                    value: incident.jamInsiden != null
                        ? DateFormat('HH:mm', 'id_ID').format(incident.jamInsiden!)
                        : '-',
                  ),
                  20.verticalSpace,

                  // Lokasi Insiden
                  _buildReadOnlyField(
                    label: 'Lokasi Insiden*',
                    value: incident.lokasiInsiden ?? '-',
                  ),
                  20.verticalSpace,

                  // Detail Lokasi Insiden
                  _buildReadOnlyField(
                    label: 'Detail Lokasi Insiden*',
                    value: incident.detailLokasiInsiden ?? '-',
                  ),
                  20.verticalSpace,

                  // Tipe Insiden
                  _buildReadOnlyField(
                    label: 'Tipe Insiden*',
                    value: incident.tipeInsidenDisplayName,
                  ),
                  20.verticalSpace,

                  // Deskripsi Insiden
                  _buildReadOnlyField(
                    label: 'Deskripsi Insiden*',
                    value: incident.deskripsiInsiden ?? '-',
                    maxLines: 5,
                  ),
                  20.verticalSpace,

                  // Foto Insiden
                  if (incident.fotoInsiden != null && incident.fotoInsiden!.isNotEmpty)
                    _buildPhotoField(incident.fotoInsiden!),
                  20.verticalSpace,

                  // Aksi
                  _buildReadOnlyField(
                    label: 'Aksi',
                    value: 'Pembuatan Keputusan',
                  ),
                  20.verticalSpace,

                  // Penanggung Jawab
                  _buildReadOnlyField(
                    label: 'Penanggung Jawab',
                    value: incident.pic ?? '-',
                  ),
                  20.verticalSpace,

                  // Tim Petugas
                  _buildReadOnlyField(
                    label: 'Tim Petugas',
                    value: incident.incidentDetail != null && incident.incidentDetail!.isNotEmpty
                        ? incident.incidentDetail!
                            .map((detail) => detail['Fullname']?.toString() ?? detail['fullname']?.toString() ?? '-')
                            .where((name) => name != '-')
                            .join(', ')
                        : '-',
                  ),
                  20.verticalSpace,

                  // Tugas Penanganan
                  _buildReadOnlyField(
                    label: 'Tugas Penanganan',
                    value: incident.notesAction ?? '-',
                    maxLines: 3,
                  ),
                  20.verticalSpace,

                  // Note Penyelesaian
                  _buildReadOnlyField(
                    label: 'Note Penyelesaian',
                    value: incident.solvedAction ?? '-',
                    maxLines: 3,
                  ),
                  20.verticalSpace,

                  // Tanggal Penyelesaian
                  _buildReadOnlyField(
                    label: 'Tanggal Penyelesaian',
                    value: incident.solvedDate != null
                        ? DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(incident.solvedDate!)
                        : '-',
                  ),
                  20.verticalSpace,

                  // Bukti Penyelesaian (dari IncidentDetail jika ada)
                  if (incident.incidentDetail != null && incident.incidentDetail!.isNotEmpty)
                    ...incident.incidentDetail!
                        .where((detail) => detail['File'] != null || detail['file'] != null)
                        .map((detail) {
                          final file = detail['File'] ?? detail['file'];
                          final fileUrl = file is Map 
                              ? (file['Url'] ?? file['url'] ?? file['FileUrl'] ?? file['fileUrl'])
                              : file?.toString();
                          if (fileUrl != null && fileUrl.toString().isNotEmpty) {
                            return Column(
                              children: [
                                _buildReadOnlyField(
                                  label: 'Bukti Penyelesaian',
                                  value: fileUrl.toString(),
                                ),
                                20.verticalSpace,
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        })
                        .toList(),
                  32.verticalSpace,

                  // Action Buttons
                  // Untuk PJO/Deputy di tab "Daftar Insiden": Tugaskan, Eskalasi, Verifikasi, Revisi
                  // Untuk danton di tab "Daftar Insiden": Konfirmasi dan Tandai Tidak Valid
                  // Untuk pengawas di tab "Daftar Insiden": Tugaskan, Verifikasi, Revisi
                  // Untuk admin di tab "Daftar Insiden": Verifikasi, Revisi (jika status COMPLETED)
                  // Untuk tab "Tugas Saya" (anggota): Proses dan Tandai Sebagai Selesai
                  if (!widget.isFromMyTasks) 
                    _isPengawas
                      ? _buildPengawasActionButtons(incident)
                      : _isPJOOrDeputy 
                        ? _buildPJOOrDeputyActionButtons(incident)
                        : _isDanton
                          ? _buildDantonActionButtons(incident)
                          : _isAdmin
                            ? _buildAdminActionButtons(incident)
                            : const SizedBox.shrink()
                  else 
                    _buildActionButton(incident),
                  16.verticalSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TS.labelLarge,
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: REdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.grey.shade100,
          ),
          child: Text(
            value,
            style: TS.bodyLarge.copyWith(
              color: Colors.black87,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoField(String photoUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Insiden',
          style: TS.labelLarge,
        ),
        8.verticalSpace,
        GestureDetector(
          onTap: () {
            // TODO: Show full image preview
          },
          child: Container(
            width: double.infinity,
            padding: REdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    photoUrl,
                    style: TS.bodyLarge.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.image,
                  color: primaryColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPengawasActionButtons(IncidentEntity incident) {
    // Untuk Pengawas: Tugaskan dan Verifikasi
    final apiStatus = _getApiStatus(incident.status);
    
    return BlocBuilder<IncidentBloc, IncidentState>(
      builder: (context, state) {
        final buttons = <Widget>[];
        
        // Tombol Tugaskan untuk status OPEN atau ACKNOWLEDGE
        if (apiStatus == 'OPEN' || apiStatus == 'ACKNOWLEDGE') {
          buttons.add(
            UIButton(
              text: 'Tugaskan',
              fullWidth: true,
              size: UIButtonSize.large,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _showAssignDialog(context, incident);
                    },
            ),
          );
        }
        
        // Tombol Verifikasi untuk status COMPLETED
        if (apiStatus == 'COMPLETED') {
          buttons.add(
            UIButton(
              text: 'Verifikasi',
              fullWidth: true,
              size: UIButtonSize.large,
              variant: UIButtonVariant.success,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _showVerifyDialog(context, incident);
                    },
            ),
          );
        }
        
        if (buttons.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Column(children: buttons);
      },
    );
  }

  Widget _buildAdminActionButtons(IncidentEntity incident) {
    // Untuk Admin: Verifikasi dan Revisi (hanya untuk status COMPLETED)
    final apiStatus = _getApiStatus(incident.status);
    
    return BlocBuilder<IncidentBloc, IncidentState>(
      builder: (context, state) {
        final buttons = <Widget>[];
        
        // Tombol Verifikasi dan Revisi untuk status COMPLETED
        if (apiStatus == 'COMPLETED') {
          buttons.addAll([
            // Tombol Verifikasi
            UIButton(
              text: 'Verifikasi',
              fullWidth: true,
              size: UIButtonSize.large,
              variant: UIButtonVariant.success,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _statusUpdated = true;
                      context.read<IncidentBloc>().add(
                            UpdateIncidentStatusEvent(
                              incidentId: incident.id,
                              status: 'VERIFIED',
                              notes: 'Diverifikasi oleh ${_userRole?.displayName ?? 'Admin'}',
                            ),
                          );
                    },
            ),
            16.verticalSpace,
            // Tombol Revisi
            UIButton(
              text: 'Revisi',
              fullWidth: true,
              size: UIButtonSize.large,
              buttonType: UIButtonType.outline,
              variant: UIButtonVariant.warning,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _statusUpdated = true;
                      context.read<IncidentBloc>().add(
                            UpdateIncidentStatusEvent(
                              incidentId: incident.id,
                              status: 'PROGRESS',
                              notes: 'Direvisi oleh ${_userRole?.displayName ?? 'Admin'}',
                            ),
                          );
                    },
            ),
          ]);
        }
        
        if (buttons.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Column(children: buttons);
      },
    );
  }

  Widget _buildPJOOrDeputyActionButtons(IncidentEntity incident) {
    // Untuk PJO/Deputy di tab "Daftar Insiden"
    final apiStatus = _getApiStatus(incident.status);
    
    return BlocBuilder<IncidentBloc, IncidentState>(
      builder: (context, state) {
        final buttons = <Widget>[];
        
        // Tombol Tugaskan dan Eskalasi untuk status OPEN atau ACKNOWLEDGE
        if (apiStatus == 'OPEN' || apiStatus == 'ACKNOWLEDGE') {
          buttons.addAll([
            // Tombol Tugaskan
            UIButton(
              text: 'Tugaskan',
              fullWidth: true,
              size: UIButtonSize.large,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _showAssignDialog(context, incident);
                    },
            ),
            16.verticalSpace,
            // Tombol Eskalasi
            UIButton(
              text: 'Eskalasi',
              fullWidth: true,
              size: UIButtonSize.large,
              buttonType: UIButtonType.outline,
              variant: UIButtonVariant.warning,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _statusUpdated = true;
                      context.read<IncidentBloc>().add(
                            UpdateIncidentStatusEvent(
                              incidentId: incident.id,
                              status: 'ESCALATED',
                              notes: 'Dieskalasi oleh ${_userRole?.displayName ?? 'PJO/Deputy'}',
                            ),
                          );
                    },
            ),
          ]);
        }
        
        // Tombol Verifikasi dan Revisi untuk status COMPLETED
        if (apiStatus == 'COMPLETED') {
          buttons.addAll([
            // Tombol Verifikasi
            UIButton(
              text: 'Verifikasi',
              fullWidth: true,
              size: UIButtonSize.large,
              variant: UIButtonVariant.success,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _statusUpdated = true;
                      context.read<IncidentBloc>().add(
                            UpdateIncidentStatusEvent(
                              incidentId: incident.id,
                              status: 'VERIFIED',
                              notes: 'Diverifikasi oleh ${_userRole?.displayName ?? 'PJO/Deputy'}',
                            ),
                          );
                    },
            ),
            16.verticalSpace,
            // Tombol Revisi
            UIButton(
              text: 'Revisi',
              fullWidth: true,
              size: UIButtonSize.large,
              buttonType: UIButtonType.outline,
              variant: UIButtonVariant.warning,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _statusUpdated = true;
                      context.read<IncidentBloc>().add(
                            UpdateIncidentStatusEvent(
                              incidentId: incident.id,
                              status: 'PROGRESS',
                              notes: 'Direvisi oleh ${_userRole?.displayName ?? 'PJO/Deputy'}',
                            ),
                          );
                    },
            ),
          ]);
        }
        
        if (buttons.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Column(children: buttons);
      },
    );
  }

  Widget _buildDantonActionButtons(IncidentEntity incident) {
    // Untuk danton di tab "Daftar Insiden"
    // Hanya tampilkan jika status masih "menunggu" (OPEN)
    if (incident.status != IncidentStatus.menunggu) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<IncidentBloc, IncidentState>(
      builder: (context, state) {
        return Column(
          children: [
            // Tombol Konfirmasi
            UIButton(
              text: 'Konfirmasi',
              fullWidth: true,
              size: UIButtonSize.large,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _statusUpdated = true;
                      context.read<IncidentBloc>().add(
                            UpdateIncidentStatusEvent(
                              incidentId: incident.id,
                              status: 'ACKNOWLEDGE',
                              notes: 'Dikonfirmasi oleh danton',
                            ),
                          );
                    },
            ),
            16.verticalSpace,
            // Tombol Tandai Tidak Valid
            UIButton(
              text: 'Tandai Tidak Valid',
              fullWidth: true,
              size: UIButtonSize.large,
              buttonType: UIButtonType.outline,
              variant: UIButtonVariant.error,
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _statusUpdated = true;
                      context.read<IncidentBloc>().add(
                            UpdateIncidentStatusEvent(
                              incidentId: incident.id,
                              status: 'INVALID',
                              notes: 'Ditandai tidak valid oleh danton',
                            ),
                          );
                    },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(IncidentEntity incident) {
    // Tentukan status dari API
    // OPEN (menunggu) -> tombol "Proses" -> update ke PROGRESS (menggunakan /Incident/update)
    // PROGRESS (proses) -> tombol "Tandai Sebagai Selesai" -> update ke COMPLETED (menggunakan /Incident/updateall)
    
    // Mapping status dari entity ke API status
    // Dari incident_api_model.dart:
    // OPEN -> IncidentStatus.menunggu
    // PROGRESS -> IncidentStatus.proses
    // COMPLETED -> IncidentStatus.selesai
    
    String? apiStatus;
    if (incident.status == IncidentStatus.menunggu) {
      // Status "menunggu" bisa berarti OPEN (dari API)
      apiStatus = 'OPEN';
    } else if (incident.status == IncidentStatus.proses) {
      // Status "proses" berarti PROGRESS (dari API)
      apiStatus = 'PROGRESS';
    }

    // Jika status bukan OPEN atau PROGRESS, tidak tampilkan tombol
    if (apiStatus == null) {
      return const SizedBox.shrink();
    }

    String buttonText;
    String nextStatus;
    bool useUpdateAll = false; // Flag untuk menentukan API yang digunakan
    
    if (apiStatus == 'OPEN') {
      buttonText = 'Proses';
      nextStatus = 'PROGRESS';
      useUpdateAll = false; // Gunakan /Incident/update
    } else {
      // apiStatus == 'PROGRESS'
      buttonText = 'Tandai Sebagai Selesai';
      nextStatus = 'COMPLETED';
      useUpdateAll = true; // Gunakan /Incident/updateall
    }

    return BlocBuilder<IncidentBloc, IncidentState>(
      builder: (context, state) {
        return UIButton(
          text: buttonText,
          fullWidth: true,
          size: UIButtonSize.large,
          isLoading: state.isLoading,
          onPressed: state.isLoading
              ? null
              : () {
                  _statusUpdated = true; // Set flag before update
                  
                  if (useUpdateAll) {
                    // Untuk "Tandai Sebagai Selesai", gunakan /Incident/updateall
                    _showCompleteDialog(context, incident);
                  } else {
                    // Untuk "Proses", gunakan /Incident/update
                    context.read<IncidentBloc>().add(
                          UpdateIncidentStatusEvent(
                            incidentId: incident.id,
                            status: nextStatus,
                          ),
                        );
                  }
                },
        );
      },
    );
  }

  Future<void> _showAssignDialog(BuildContext context, IncidentEntity incident) async {
    final datasource = getIt<IncidentRemoteDataSource>();
    String? selectedPjId; // PIC ID (Penanggung Jawab)
    List<String> selectedTeamIds = []; // Team IDs (Anggota - multiple selection)
    final tugasPenangananController = TextEditingController();
    bool isLoading = true;
    bool isSubmitting = false;
    List<Map<String, String>> userList = [];

    // Load user list
    try {
      final users = await datasource.getUserList();
      
      // Sort user list by name (alphabetically)
      userList = users;
      userList.sort((a, b) {
        final nameA = (a['name'] ?? '').toLowerCase();
        final nameB = (b['name'] ?? '').toLowerCase();
        return nameA.compareTo(nameB);
      });
      
      isLoading = false;
    } catch (e) {
      isLoading = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final incidentBloc = context.read<IncidentBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: incidentBloc,
        child: BlocListener<IncidentBloc, IncidentState>(
          listener: (context, state) {
            if (!state.isLoading && isSubmitting) {
              if (state.errorMessage == null) {
                // Success - close dialog
                Navigator.of(context).pop();
                _statusUpdated = true;
              } else {
                // Error - show error and reset submitting
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }
          },
          child: StatefulBuilder(
          builder: (context, setState) => Dialog(
            backgroundColor: Colors.white,
            insetPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: REdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tugaskan Insiden',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: REdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      // Penanggung Jawab
                      SearchableDropdown<String?>(
                        label: 'Penanggung Jawab',
                        hint: 'Pilih Penanggung Jawab',
                        value: selectedPjId,
                        items: userList.map((user) => DropdownItem<String?>(
                          value: user['id'],
                          text: user['name'] ?? '',
                        )).toList(),
                        isRequired: true,
                        onChanged: (value) {
                          setState(() {
                            selectedPjId = value;
                          });
                        },
                      ),
                      20.verticalSpace,
                      // Tim (Multiple Selection)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Tim',
                                style: TS.labelLarge,
                              ),
                              Text(
                                '*',
                                style: TS.bodyLarge.copyWith(color: Colors.red),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          InkWell(
                            onTap: () => _showTeamSelectionDialog(
                              context,
                              userList,
                              selectedTeamIds,
                              (selectedIds) {
                                setState(() {
                                  selectedTeamIds = selectedIds;
                                });
                              },
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: REdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                color: inputColor,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedTeamIds.isEmpty
                                          ? 'Pilih Tim'
                                          : selectedTeamIds.length == 1
                                              ? userList
                                                  .firstWhere(
                                                    (u) => u['id'] == selectedTeamIds.first,
                                                    orElse: () => {'name': ''},
                                                  )['name'] ?? 'Pilih Tim'
                                              : '${selectedTeamIds.length} anggota dipilih',
                                      style: TS.bodyLarge.copyWith(
                                        color: selectedTeamIds.isEmpty
                                            ? appHintColor
                                            : Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      // Tugas Penanganan
                      InputPrimary(
                        label: 'Tugas Penanganan',
                        controller: tugasPenangananController,
                        hint: 'Masukkan tugas penanganan',
                        isRequired: true,
                        maxLines: 3,
                        validation: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Tugas penanganan harus diisi';
                          }
                          return null;
                        },
                      ),
                            ],
                          ),
                        ),
                ),
                // Actions
                Container(
                  padding: REdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                      12.horizontalSpace,
                      ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                      if (selectedPjId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mohon pilih Penanggung Jawab'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (selectedTeamIds.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mohon pilih minimal 1 anggota Tim'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (tugasPenangananController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mohon isi Tugas Penanganan'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isSubmitting = true;
                      });
                      
                      // Dispatch event - BlocListener will handle the response
                      context.read<IncidentBloc>().add(
                        UpdateAllIncidentEvent(
                          incidentId: incident.id,
                          picId: selectedPjId!,
                          team: selectedTeamIds,
                          handlingTask: tugasPenangananController.text.trim(),
                          status: 'ASSIGNED',
                        ),
                      );
                    },
                        child: isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Tugaskan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: REdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        ),
      ),
    );
  }

  Future<void> _showVerifyDialog(BuildContext context, IncidentEntity incident) async {
    final datasource = getIt<IncidentRemoteDataSource>();
    String? picId;
    List<String> team = [];
    String handlingTask = '';

    // Load incident detail untuk mendapatkan data yang sudah ada
    try {
      final apiModel = await datasource.getIncidentDetailApiModel(incident.id);
      
      picId = apiModel.picId;
      // Team diambil dari incidentDetail jika ada
      if (apiModel.incidentDetail != null && apiModel.incidentDetail!.isNotEmpty) {
        team = apiModel.incidentDetail!
            .map((detail) {
              if (detail is Map<String, dynamic>) {
                return detail['UserId']?.toString() ?? '';
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }
      handlingTask = apiModel.notesAction ?? '';
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    // Tampilkan dialog konfirmasi
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Verifikasi Insiden'),
        content: const Text('Apakah Anda yakin ingin memverifikasi insiden ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Verifikasi'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Verifikasi menggunakan updateAllIncident
    try {
      context.read<IncidentBloc>().add(
        UpdateAllIncidentEvent(
          incidentId: incident.id,
          picId: picId ?? '',
          team: team,
          handlingTask: handlingTask,
          status: 'VERIFIED',
        ),
      );

      if (context.mounted) {
        _statusUpdated = true;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memverifikasi: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _showCompleteDialog(BuildContext context, IncidentEntity incident) async {
    final datasource = getIt<IncidentRemoteDataSource>();
    String? picId;
    List<String> team = [];
    String handlingTask = '';

    // Load incident detail untuk mendapatkan data yang sudah ada
    try {
      final apiModel = await datasource.getIncidentDetailApiModel(incident.id);
      
      picId = apiModel.picId;
      // Team diambil dari incidentDetail jika ada
      if (apiModel.incidentDetail != null && apiModel.incidentDetail!.isNotEmpty) {
        team = apiModel.incidentDetail!
            .map((detail) {
              if (detail is Map<String, dynamic>) {
                return detail['UserId']?.toString() ?? '';
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }
      handlingTask = apiModel.notesAction ?? '';
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    // Tampilkan dialog konfirmasi
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tandai Sebagai Selesai'),
        content: const Text('Apakah Anda yakin ingin menandai insiden ini sebagai selesai?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Update status ke COMPLETED menggunakan updateAllIncident
    try {
      context.read<IncidentBloc>().add(
        UpdateAllIncidentEvent(
          incidentId: incident.id,
          picId: picId ?? '',
          team: team,
          handlingTask: handlingTask,
          status: 'COMPLETED',
        ),
      );

      if (context.mounted) {
        _statusUpdated = true;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menandai sebagai selesai: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showTeamSelectionDialog(
    BuildContext context,
    List<Map<String, String>> userList,
    List<String> selectedIds,
    Function(List<String>) onSelected,
  ) {
    List<String> tempSelectedIds = List.from(selectedIds);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.white,
          insetPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: REdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pilih Tim',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: REdgeInsets.all(16),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      final userId = user['id'] ?? '';
                      final userName = user['name'] ?? '';
                      final isSelected = tempSelectedIds.contains(userId);

                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              if (!tempSelectedIds.contains(userId)) {
                                tempSelectedIds.add(userId);
                              }
                            } else {
                              tempSelectedIds.remove(userId);
                            }
                          });
                        },
                        title: Text(
                          userName,
                          style: TS.bodyLarge,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
                ),
                // Actions
                Container(
                  padding: REdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                      12.horizontalSpace,
                      ElevatedButton(
                        onPressed: () {
                          onSelected(tempSelectedIds);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Pilih'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: REdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

