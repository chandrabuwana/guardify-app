import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../domain/entities/incident_entity.dart';
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

  @override
  Widget build(BuildContext context) {

    return BlocListener<IncidentBloc, IncidentState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
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

                  // Action Button (hanya untuk tab "Tugas Saya")
                  if (widget.isFromMyTasks) _buildActionButton(incident),
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

  Widget _buildActionButton(IncidentEntity incident) {
    // Tentukan status dari API
    // OPEN (menunggu) -> tombol "Proses" -> update ke PROGRESS
    // PROGRESS (proses) -> tombol "Tandai Sebagai Selesai" -> update ke COMPLETED
    
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
    if (apiStatus == 'OPEN') {
      buttonText = 'Proses';
      nextStatus = 'PROGRESS';
    } else {
      // apiStatus == 'PROGRESS'
      buttonText = 'Tandai Sebagai Selesai';
      nextStatus = 'COMPLETED';
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
                  context.read<IncidentBloc>().add(
                        UpdateIncidentStatusEvent(
                          incidentId: incident.id,
                          status: nextStatus,
                        ),
                      );
                },
        );
      },
    );
  }
}

