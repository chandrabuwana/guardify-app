import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_detail_item.dart';
import 'edit_name_screen.dart';

/// Layar detail profil yang menampilkan semua informasi profil lengkap
class ProfileDetailsScreen extends StatelessWidget {
  final String userId;

  const ProfileDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()..add(LoadProfileEvent(userId)),
      child: ProfileDetailsScreenView(userId: userId),
    );
  }
}

class ProfileDetailsScreenView extends StatefulWidget {
  final String userId;

  const ProfileDetailsScreenView({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileDetailsScreenView> createState() => _ProfileDetailsScreenViewState();
}

class _ProfileDetailsScreenViewState extends State<ProfileDetailsScreenView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profil Saya',
          style: TS.titleLarge.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Info Pribadi'),
            Tab(text: 'Dokumen'),
          ],
        ),
      ),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Handle profile update success
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Handle profile update failure
          if (state is ProfileUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Handle document upload success
          if (state is DocumentUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Dokumen ${state.documentType} berhasil diupload'),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Handle document upload failure
          if (state is DocumentUploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64.w,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Error: ${state.message}',
                    style: TS.bodyMedium.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  UIButton(
                    text: 'Coba Lagi',
                    onPressed: () {
                      context.read<ProfileBloc>().add(LoadProfileEvent(widget.userId));
                    },
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded || 
              state is ProfileUpdateInProgress ||
              state is DocumentUploadInProgress) {
            final profile = _getProfileFromState(state);
            final isLoading = state is ProfileUpdateInProgress || 
                             state is DocumentUploadInProgress;

            return Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab Info Pribadi
                    _buildInfoPribadiTab(profile),
                    
                    // Tab Dokumen
                    _buildDokumenTab(profile),
                  ],
                ),
                
                // Loading overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  /// Build tab info pribadi
  Widget _buildInfoPribadiTab(dynamic profile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Foto profil
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 2.w,
                    ),
                  ),
                  child: ClipOval(
                    child: profile.profileImageUrl != null
                        ? Image.network(
                            profile.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 50.w,
                                color: Colors.grey.shade400,
                              );
                            },
                          )
                        : Icon(
                            Icons.person,
                            size: 50.w,
                            color: Colors.grey.shade400,
                          ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'Foto Profile',
            style: TS.bodyMedium.copyWith(color: Colors.grey.shade600),
          ),
          
          SizedBox(height: 24.h),
          
          // Data profil
          ProfileDetailItem(
            label: 'Nama',
            value: profile.name,
            onTap: () => _navigateToEditName(profile),
          ),
          
          ProfileDetailItem(
            label: 'NRP',
            value: profile.nrp,
          ),
          
          ProfileDetailItem(
            label: 'No KTP',
            value: profile.noKtp,
          ),
          
          ProfileDetailItem(
            label: 'Tempat Lahir',
            value: profile.tempatLahir,
          ),
          
          ProfileDetailItem(
            label: 'Tanggal Lahir',
            value: DateFormat('dd MMMM yyyy', 'id_ID').format(profile.tanggalLahir),
          ),
          
          ProfileDetailItem(
            label: 'Jenis Kelamin',
            value: profile.jenisKelamin,
          ),
          
          ProfileDetailItem(
            label: 'Pendidikan',
            value: profile.pendidikan,
          ),
          
          ProfileDetailItem(
            label: 'Telepon Pribadi',
            value: profile.teleponPribadi,
          ),
          
          ProfileDetailItem(
            label: 'Telepon Darurat',
            value: profile.teleponDarurat,
          ),
          
          ProfileDetailItem(
            label: 'Site',
            value: profile.site,
          ),
          
          ProfileDetailItem(
            label: 'Jabatan',
            value: profile.jabatan,
          ),
          
          ProfileDetailItem(
            label: 'Atasan',
            value: profile.atasan,
          ),
          
          ProfileDetailItem(
            label: 'Tgl Penerimaan Karyawan',
            value: DateFormat('dd MMMM yyyy', 'id_ID').format(profile.tglPenerimaanKaryawan),
          ),
          
          ProfileDetailItem(
            label: 'Masa Berlaku Permit',
            value: DateFormat('dd MMMM yyyy', 'id_ID').format(profile.masaBerlakuPermit),
          ),
          
          ProfileDetailItem(
            label: 'Kompetensi Pekerjaan',
            value: profile.kompetensiPekerjaan,
          ),
          
          ProfileDetailItem(
            label: 'Warga Negara',
            value: profile.wargaNegara,
          ),
          
          ProfileDetailItem(
            label: 'Provinsi',
            value: profile.provinsi,
          ),
          
          ProfileDetailItem(
            label: 'Kota / Kabupaten',
            value: profile.kotaKabupaten,
          ),
          
          ProfileDetailItem(
            label: 'Kecamatan',
            value: profile.kecamatan,
          ),
          
          ProfileDetailItem(
            label: 'Kelurahan',
            value: profile.kelurahan,
          ),
          
          ProfileDetailItem(
            label: 'Alamat Domisili',
            value: profile.alamatDomisili,
            isLastItem: true,
          ),
        ],
      ),
    );
  }

  /// Build tab dokumen
  Widget _buildDokumenTab(dynamic profile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          _buildDocumentItem(
            'KTP',
            'KTP_${profile.name.replaceAll(' ', '_')}',
            () => _uploadDocument('KTP'),
          ),
          
          SizedBox(height: 16.h),
          
          _buildDocumentItem(
            'KTA',
            'KTA_${profile.name.replaceAll(' ', '_')}',
            () => _uploadDocument('KTA'),
          ),
          
          SizedBox(height: 16.h),
          
          _buildDocumentItem(
            'Foto',
            'Foto_${profile.name.replaceAll(' ', '_')}',
            () => _uploadDocument('Foto'),
          ),
          
          SizedBox(height: 16.h),
          
          _buildDocumentItem(
            'P3TD K3LH',
            'P3TD_K3LH_${profile.name.replaceAll(' ', '_')}',
            () => _uploadDocument('P3TD_K3LH'),
          ),
          
          SizedBox(height: 16.h),
          
          _buildDocumentItem(
            'P3TD Security',
            'P3TD_Sec_${profile.name.replaceAll(' ', '_')}',
            () => _uploadDocument('P3TD_Security'),
          ),
          
          SizedBox(height: 16.h),
          
          _buildDocumentItem(
            'Pernyataan Tidak Merokok',
            'Tidak_Merokok_${profile.name.replaceAll(' ', '_')}',
            () => _uploadDocument('Tidak_Merokok'),
          ),
        ],
      ),
    );
  }

  /// Build document item widget
  Widget _buildDocumentItem(String title, String filename, VoidCallback onUpload) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TS.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  filename,
                  style: TS.bodySmall.copyWith(
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade400,
            size: 16.w,
          ),
        ],
      ),
    );
  }

  /// Helper method untuk mendapatkan profile dari berbagai state
  dynamic _getProfileFromState(ProfileState state) {
    if (state is ProfileLoaded) return state.profile;
    if (state is ProfileUpdateInProgress) return state.currentProfile;
    if (state is DocumentUploadInProgress) return state.currentProfile;
    return null;
  }

  /// Navigate ke halaman edit nama
  void _navigateToEditName(dynamic profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditNameScreen(
          userId: widget.userId,
          currentName: profile.name,
        ),
      ),
    );
  }

  /// Upload dokumen
  void _uploadDocument(String documentType) {
    // TODO: Implement file picker dan upload
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur upload $documentType akan segera tersedia'),
      ),
    );
  }
}