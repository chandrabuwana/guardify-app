import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/upload_photo_field.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../domain/entities/attendance_request.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

class CheckOutPage extends StatefulWidget {
  final String userId;
  final String attendanceId;

  const CheckOutPage({
    Key? key,
    required this.userId,
    required this.attendanceId,
  }) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  // Controllers
  final _lokasiPenugasanAkhirController = TextEditingController();
  final _laporanPengamananController = TextEditingController();

  // Form data
  String _statusTugas = '';
  String _pakaianPersonil = '';
  List<String> _fotoPengamanan = [];
  List<String> _buktiLaporan = [];

  @override
  void initState() {
    super.initState();
    _lokasiPenugasanAkhirController.text =
        'Pos Satpam Gedung A'; // Default value
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AttendanceBloc>()..add(const CheckOutStartedEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text('Akhiri Bekerja'),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceCheckedOut) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            } else if (state is AttendanceFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: REdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputPrimary(
                          label: 'Lokasi Penugasan Akhir',
                          controller: _lokasiPenugasanAkhirController,
                          hint: 'Masukkan lokasi penugasan akhir',
                          margin: REdgeInsets.only(bottom: 16),
                          isRequired: true,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () {
                              // TODO: Get current location
                            },
                          ),
                        ),

                        CustomDropdown<String>(
                          label: 'Status Tugas',
                          hint: 'Pilih Status Tugas',
                          value: _statusTugas.isEmpty ? null : _statusTugas,
                          items: [
                            DropdownItem(value: 'selesai', text: 'Selesai'),
                            DropdownItem(
                                value: 'tidak_selesai', text: 'Tidak Selesai'),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _statusTugas = value ?? '';
                            });
                          },
                          isRequired: true,
                          margin: REdgeInsets.only(bottom: 16),
                          errorText: _statusTugas == 'tidak_selesai'
                              ? 'Tugas belum selesai. Pastikan semua tugas telah diselesaikan.'
                              : null,
                        ),

                        CustomDropdown<String>(
                          label: 'Pakaian Personil',
                          hint: 'Pilih Pakaian Personil',
                          value: _pakaianPersonil.isEmpty
                              ? null
                              : _pakaianPersonil,
                          items: [
                            DropdownItem(
                                value: 'seragam_harian',
                                text: 'Seragam Harian'),
                            DropdownItem(
                                value: 'seragam_lapangan',
                                text: 'Seragam Lapangan'),
                            DropdownItem(
                                value: 'pakaian_dinas', text: 'Pakaian Dinas'),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _pakaianPersonil = value ?? '';
                            });
                          },
                          isRequired: true,
                          margin: REdgeInsets.only(bottom: 16),
                        ),

                        InputPrimary(
                          label: 'Laporan Pengamanan',
                          controller: _laporanPengamananController,
                          hint: 'Masukkan laporan pengamanan akhir...',
                          maxLines: 4,
                          margin: REdgeInsets.only(bottom: 16),
                          isRequired: true,
                        ),

                        UploadPhotoField(
                          label: 'Foto Pengamanan',
                          photos: _fotoPengamanan,
                          onPhotosChanged: (photos) {
                            setState(() {
                              _fotoPengamanan = photos;
                            });
                          },
                          isRequired: true,
                          margin: REdgeInsets.only(bottom: 16),
                        ),

                        UploadPhotoField(
                          label: 'Bukti Laporan',
                          photos: _buktiLaporan,
                          onPhotosChanged: (photos) {
                            setState(() {
                              _buktiLaporan = photos;
                            });
                          },
                          isRequired: false,
                          margin: REdgeInsets.only(bottom: 16),
                        ),

                        // Warning for incomplete tasks
                        if (_statusTugas == 'tidak_selesai') ...[
                          Container(
                            width: double.infinity,
                            padding: REdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  color: Colors.red.shade600,
                                  size: 24.sp,
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Peringatan',
                                        style: TS.labelMedium.copyWith(
                                          color: Colors.red.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        'Terdapat tugas yang belum selesai. Pastikan untuk menyelesaikan semua tugas atau memberikan keterangan yang jelas dalam laporan.',
                                        style: TS.bodySmall.copyWith(
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          16.verticalSpace,
                        ],

                        // Summary Section
                        Container(
                          width: double.infinity,
                          padding: REdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            border: Border.all(color: Colors.blue.shade200),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue.shade600,
                                    size: 20.sp,
                                  ),
                                  8.horizontalSpace,
                                  Text(
                                    'Ringkasan Check Out',
                                    style: TS.labelMedium.copyWith(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              8.verticalSpace,
                              Text(
                                'Pastikan semua data yang Anda masukkan sudah benar sebelum mengakhiri tugas.',
                                style: TS.bodySmall.copyWith(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation
                Container(
                  padding: REdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: UIButton(
                          text: 'Batal',
                          buttonType: UIButtonType.outline,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: UIButton(
                          text: 'Akhiri Bekerja',
                          onPressed:
                              _canSubmitCheckOut() ? _submitCheckOut : null,
                          variant: _statusTugas == 'tidak_selesai'
                              ? UIButtonVariant.warning
                              : UIButtonVariant.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _canSubmitCheckOut() {
    return _lokasiPenugasanAkhirController.text.isNotEmpty &&
        _statusTugas.isNotEmpty &&
        _pakaianPersonil.isNotEmpty &&
        _laporanPengamananController.text.isNotEmpty &&
        _fotoPengamanan.isNotEmpty;
  }

  void _submitCheckOut() async {
    String confirmMessage = 'Apakah Anda yakin selesai bekerja?';
    String confirmTitle = 'Konfirmasi Check Out';

    if (_statusTugas == 'tidak_selesai') {
      confirmTitle = 'Konfirmasi Check Out - Tugas Belum Selesai';
      confirmMessage =
          'Terdapat tugas yang belum selesai. Apakah Anda yakin ingin mengakhiri tugas sekarang?';
    }

    final confirmed = await ConfirmDialog.show(
      context: context,
      title: confirmTitle,
      message: confirmMessage,
      icon: Icons.exit_to_app,
      iconColor: _statusTugas == 'tidak_selesai' ? Colors.orange : Colors.blue,
      isDestructive: _statusTugas == 'tidak_selesai',
    );

    if (confirmed == true && mounted) {
      final request = CheckOutRequest(
        userId: widget.userId,
        attendanceId: widget.attendanceId,
        lokasiPenugasanAkhir: _lokasiPenugasanAkhirController.text,
        statusTugas: _statusTugas,
        pakaianPersonil: _pakaianPersonil,
        laporanPengamanan: _laporanPengamananController.text,
        fotoPengamanan: _fotoPengamanan,
        buktiLaporan: _buktiLaporan,
      );

      context.read<AttendanceBloc>().add(CheckOutSubmittedEvent(request));
    }
  }

  @override
  void dispose() {
    _lokasiPenugasanAkhirController.dispose();
    _laporanPengamananController.dispose();
    super.dispose();
  }
}
