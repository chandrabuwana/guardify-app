import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../domain/entities/panic_button_history_item.dart';
import '../bloc/panic_button_bloc.dart';
import '../bloc/panic_button_event.dart';
import '../bloc/panic_button_state.dart';

class PanicButtonDetailPage extends StatefulWidget {
  final String incidentId;

  const PanicButtonDetailPage({
    super.key,
    required this.incidentId,
  });

  @override
  State<PanicButtonDetailPage> createState() => _PanicButtonDetailPageState();
}

class _PanicButtonDetailPageState extends State<PanicButtonDetailPage> {
  final TextEditingController _tindakanPenyelesaianController = TextEditingController();
  final TextEditingController _buktiPenyelesaianController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _proofImage;
  UserRole? _currentUserRole;
  bool _isLoadingRole = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PanicButtonBloc>().add(
              LoadPanicButtonDetailEvent(widget.incidentId),
            );
      }
    });
  }

  Future<void> _loadUserRole() async {
    final role = await UserRoleHelper.getUserRole();
    setState(() {
      _currentUserRole = role;
      _isLoadingRole = false;
    });
  }

  @override
  void dispose() {
    _tindakanPenyelesaianController.dispose();
    _buktiPenyelesaianController.dispose();
    super.dispose();
  }

  bool get _canVerify {
    if (_currentUserRole == null) return false;
    return _currentUserRole == UserRole.pjo ||
        _currentUserRole == UserRole.deputy ||
        _currentUserRole == UserRole.pengawas;
  }

  bool get _canRevisi {
    return _currentUserRole == UserRole.pengawas;
  }

  bool get _isPengawas {
    return _currentUserRole == UserRole.pengawas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Panic Button',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocListener<PanicButtonBloc, PanicButtonState>(
        listener: (context, state) {
          if (state.detailItem != null) {
            // Pre-fill editable fields if they exist
            final item = state.detailItem!;
            if (item.resolveAction != null && _tindakanPenyelesaianController.text.isEmpty) {
              _tindakanPenyelesaianController.text = item.resolveAction!;
            }
          }

          // Handle verification submission
          if (state.submitVerificationSuccess) {
            // Navigate back to history page and reload
            Navigator.pop(context, true); // Pass true to indicate refresh needed
          }

          if (state.submitVerificationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.submitVerificationError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<PanicButtonBloc, PanicButtonState>(
          builder: (context, state) {
            if (state.isLoadingDetail || _isLoadingRole) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.detailErrorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.sp,
                      color: Colors.red,
                    ),
                    16.verticalSpace,
                    Text(
                      state.detailErrorMessage!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    16.verticalSpace,
                    ElevatedButton(
                      onPressed: () {
                        context.read<PanicButtonBloc>().add(
                              LoadPanicButtonDetailEvent(widget.incidentId),
                            );
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final historyItem = state.detailItem;
            if (historyItem == null) {
              return const Center(
                child: Text('Data tidak ditemukan'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section with Status
                        _buildHeaderSection(historyItem),
                        20.verticalSpace,

                        // Informasi Kejadian Section
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Informasi Kejadian', Icons.info_outline),
                              12.verticalSpace,
                              _buildInfoCard(
                                icon: Icons.category,
                                label: 'Jenis Keadaan Darurat',
                                value: historyItem.incidentTypeName ?? '-',
                              ),
                              12.verticalSpace,
                              _buildInfoCard(
                                icon: Icons.location_on,
                                label: 'Lokasi Kejadian',
                                value: historyItem.areaName ?? '-',
                              ),
                              12.verticalSpace,
                              _buildInfoCard(
                                icon: Icons.description,
                                label: 'Kejadian',
                                value: historyItem.description,
                                isMultiline: true,
                              ),
                              12.verticalSpace,
                              // Tindakan Yang Dibutuhkan
                              if (historyItem.feedback != null && historyItem.feedback!.isNotEmpty)
                                _buildInfoCard(
                                  icon: Icons.assignment,
                                  label: 'Tindakan Yang Dibutuhkan',
                                  value: historyItem.feedback!,
                                  isMultiline: true,
                                ),
                              if (historyItem.feedback != null && historyItem.feedback!.isNotEmpty)
                                12.verticalSpace,
                            ],
                          ),
                        ),

                        // Foto Kejadian Section
                        if (historyItem.files.isNotEmpty) ...[
                          20.verticalSpace,
                          Padding(
                            padding: REdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Foto Kejadian', Icons.photo_library),
                                12.verticalSpace,
                                _buildPhotoGrid(historyItem.files),
                              ],
                            ),
                          ),
                        ],

                        // Informasi Pelapor Section
                        20.verticalSpace,
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Informasi Pelapor', Icons.person),
                              12.verticalSpace,
                              _buildInfoCard(
                                icon: Icons.badge,
                                label: 'Pelapor',
                                value: _formatReporter(historyItem),
                              ),
                              12.verticalSpace,
                              _buildInfoCard(
                                icon: Icons.calendar_today,
                                label: 'Tanggal Kejadian',
                                value: _formatIncidentDate(historyItem),
                              ),
                            ],
                          ),
                        ),

                        // Tindakan Penyelesaian Section
                        if (_canVerify) ...[
                          20.verticalSpace,
                          Padding(
                            padding: REdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Tindakan Penyelesaian', Icons.task_alt),
                                12.verticalSpace,
                                // Bukti Penyelesaian hanya untuk PJO/Deputy, bukan untuk Pengawas
                                if (!_isPengawas) _buildBuktiPenyelesaianField(),
                                // Feedback field untuk Pengawas
                                if (_isPengawas) ...[
                                  _buildEditableField(
                                    'Feedback',
                                    _tindakanPenyelesaianController,
                                    maxLines: 4,
                                    hintText: 'Masukkan feedback...',
                                    icon: Icons.feedback,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],

                        // Informasi Penyelesaian Section
                        if (historyItem.solverName != null || historyItem.createDate != null) ...[
                          20.verticalSpace,
                          Padding(
                            padding: REdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Informasi Penyelesaian', Icons.check_circle_outline),
                                12.verticalSpace,
                                if (historyItem.solverName != null)
                                  _buildInfoCard(
                                    icon: Icons.person_outline,
                                    label: 'Diselesaikan Oleh',
                                    value: _formatSolver(historyItem),
                                  ),
                                if (historyItem.solverName != null) 12.verticalSpace,
                                if (historyItem.createDate != null)
                                  _buildInfoCard(
                                    icon: Icons.date_range,
                                    label: 'Tanggal Pelaporan',
                                    value: _formatCreateDate(historyItem),
                                  ),
                                if (historyItem.createDate != null) 12.verticalSpace,
                                _buildInfoCard(
                                  icon: Icons.feedback,
                                  label: 'Umpan Balik Pengawas',
                                  value: historyItem.feedback ?? '-',
                                  isMultiline: true,
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Bottom padding
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),

                // Bottom Button
                if (_canVerify || _canRevisi)
                  Container(
                    padding: REdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          if (_canRevisi) ...[
                            Expanded(
                              child: BlocBuilder<PanicButtonBloc, PanicButtonState>(
                                builder: (context, state) {
                                  final isSubmitting = state.isSubmittingVerification;
                                  return OutlinedButton(
                                    onPressed: (!isSubmitting)
                                        ? () => _showRevisiConfirmDialog(context, historyItem)
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      padding: REdgeInsets.symmetric(vertical: 16),
                                      side: BorderSide(color: Colors.orange[700]!, width: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    ),
                                    child: isSubmitting
                                        ? SizedBox(
                                            width: 20.w,
                                            height: 20.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[700]!),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.edit, size: 18.sp, color: Colors.orange[700]),
                                              8.horizontalSpace,
                                              Text(
                                                'Revisi',
                                                style: TextStyle(
                                                  color: Colors.orange[700],
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              ),
                            ),
                            12.horizontalSpace,
                          ],
                          Expanded(
                            flex: _canRevisi ? 1 : 1,
                            child: BlocBuilder<PanicButtonBloc, PanicButtonState>(
                              builder: (context, state) {
                                final isSubmitting = state.isSubmittingVerification;
                                return ElevatedButton(
                                  onPressed: (_canVerify && !isSubmitting)
                                      ? () => _showConfirmDialog(context, historyItem)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[700],
                                    padding: REdgeInsets.symmetric(vertical: 16),
                                    elevation: 4,
                                    shadowColor: Colors.red[700]!.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: isSubmitting
                                      ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_circle, size: 20.sp, color: Colors.white),
                                            8.horizontalSpace,
                                            Text(
                                              'Tandai Sebagai Selesai',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(PanicButtonHistoryItem item) {
    final statusColor = _getStatusColor(item.statusColor);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withOpacity(0.1),
            statusColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Padding(
        padding: REdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    item.formattedId,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Text(
              'Detail Laporan Panic Button',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            8.verticalSpace,
            Text(
              _formatIncidentDate(item),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: REdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: Colors.red[700],
          ),
        ),
        12.horizontalSpace,
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    IconData? icon,
    required String label,
    required String value,
    Color? statusColor,
    bool isMultiline = false,
  }) {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: REdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 18.sp,
                color: Colors.red[700],
              ),
            ),
            12.horizontalSpace,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.3,
                  ),
                ),
                8.verticalSpace,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: statusColor ?? Colors.black87,
                    fontWeight: statusColor != null ? FontWeight.w600 : FontWeight.w500,
                    height: isMultiline ? 1.5 : 1.3,
                  ),
                  maxLines: isMultiline ? null : 2,
                  overflow: isMultiline ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? hintText,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Row(
            children: [
              Container(
                padding: REdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: 18.sp,
                  color: Colors.blue[700],
                ),
              ),
              12.horizontalSpace,
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ] else
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        12.verticalSpace,
        Container(
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _canVerify ? Colors.white : Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _canVerify ? Colors.blue[300]! : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: _canVerify
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            enabled: _canVerify,
            decoration: InputDecoration(
              hintText: hintText ?? '....',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuktiPenyelesaianField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: REdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.attach_file,
                size: 18.sp,
                color: Colors.green[700],
              ),
            ),
            12.horizontalSpace,
            Text(
              'Bukti Penyelesaian',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Container(
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _canVerify ? Colors.white : Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _canVerify ? Colors.green[300]! : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: _canVerify
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _buktiPenyelesaianController,
                  enabled: _canVerify,
                  decoration: InputDecoration(
                    hintText: 'Masukkan bukti penyelesaian...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (_canVerify) ...[
                8.horizontalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.green[700], size: 22.sp),
                    onPressed: () => _showImagePickerDialog(),
                    tooltip: 'Ambil Foto',
                  ),
                ),
                4.horizontalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.green[700], size: 22.sp),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fitur attachment akan segera tersedia')),
                      );
                    },
                    tooltip: 'Lampirkan File',
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_proofImage != null) ...[
          8.verticalSpace,
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  _proofImage!,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
              if (_canVerify)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _proofImage = null;
                      });
                    },
                    child: Container(
                      padding: REdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoGrid(List<PanicButtonHistoryFile> files) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.0,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  file.url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]!),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.grey[400], size: 32.sp),
                        8.verticalSpace,
                        Text(
                          'Gagal memuat',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Gradient overlay for better visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Sumber'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _proofImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showConfirmDialog(BuildContext context, PanicButtonHistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: Colors.red[700],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            16.verticalSpace,
            Text(
              'Apakah Anda yakin menyelesaikan tindakan ini?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: REdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red[700]!),
                    ),
                    child: Text(
                      'Tidak',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _submitResolution(item);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: REdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Ya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitResolution(PanicButtonHistoryItem item) {
    // Determine status based on role
    String status;
    if (_currentUserRole == UserRole.pengawas) {
      status = 'COMPLETED';
    } else {
      // PJO or Deputy
      status = 'VERIFIED';
    }

    // Notes hanya untuk pengawas (dari field Feedback)
    String? notes;
    if (_isPengawas) {
      notes = _tindakanPenyelesaianController.text.trim();
      notes = notes.isNotEmpty ? notes : null;
    } else {
      // PJO/Deputy: tidak mengirim notes
      notes = null;
    }

    context.read<PanicButtonBloc>().add(
          SubmitPanicButtonVerificationEvent(
            id: item.id,
            status: status,
            notes: notes,
          ),
        );
  }

  void _submitRevisi(PanicButtonHistoryItem item) {
    // Pengawas: notes dari field Feedback
    final notes = _tindakanPenyelesaianController.text.trim();

    context.read<PanicButtonBloc>().add(
          SubmitPanicButtonVerificationEvent(
            id: item.id,
            status: 'OPEN',
            notes: notes.isNotEmpty ? notes : null,
          ),
        );
  }

  void _showRevisiConfirmDialog(BuildContext context, PanicButtonHistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: Colors.red[700],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            16.verticalSpace,
            Text(
              'Apakah Anda yakin mengirim revisi?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: REdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red[700]!),
                    ),
                    child: Text(
                      'Tidak',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _submitRevisi(item);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: REdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Ya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Color _getStatusColor(PanicButtonStatusColor statusColor) {
    switch (statusColor) {
      case PanicButtonStatusColor.red:
        return Colors.red;
      case PanicButtonStatusColor.orange:
        return Colors.orange;
      case PanicButtonStatusColor.blue:
        return Colors.blue[700]!;
      case PanicButtonStatusColor.grey:
        return Colors.grey;
    }
  }

  String _formatReporter(PanicButtonHistoryItem item) {
    final parts = <String>[];
    if (item.reporterNrp != null && item.reporterNrp!.isNotEmpty) {
      parts.add(item.reporterNrp!);
    }
    if (item.reporterName != null && item.reporterName!.isNotEmpty) {
      parts.add(item.reporterName!);
    }
    return parts.isEmpty ? '-' : parts.join(' - ');
  }

  String _formatSolver(PanicButtonHistoryItem item) {
    final parts = <String>[];
    if (item.solverNrp != null && item.solverNrp!.isNotEmpty) {
      parts.add(item.solverNrp!);
    }
    if (item.solverName != null && item.solverName!.isNotEmpty) {
      parts.add(item.solverName!);
    }
    return parts.isEmpty ? 'xxxx' : parts.join(' - ');
  }

  String _formatIncidentDate(PanicButtonHistoryItem item) {
    if (item.reporterDate == null) return '-';
    
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH.mm', 'id_ID');
    
    final dateStr = dateFormat.format(item.reporterDate!);
    final timeStr = timeFormat.format(item.reporterDate!);
    
    return '$dateStr - $timeStr WIB';
  }

  String _formatCreateDate(PanicButtonHistoryItem item) {
    if (item.createDate == null) return 'xxxx';
    
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    return dateFormat.format(item.createDate!);
  }
}
