import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../../core/constants/enums.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/searchable_dropdown.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/incident_entity.dart';
import '../../data/datasources/incident_remote_datasource.dart';
import '../bloc/incident_bloc.dart';
import '../bloc/incident_event.dart';
import '../bloc/incident_state.dart';
import '../../../chat/presentation/bloc/chat_bloc.dart';
import '../../../chat/presentation/bloc/chat_event.dart';
import '../../../chat/presentation/pages/chat_conversation_page.dart';
import '../../../chat/domain/entities/chat.dart';

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
  String? _evidenceFromApi; // Store Evidence from API Data level

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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          try {
            final bloc = context.read<IncidentBloc>();
            bloc.add(GetIncidentDetailEvent(widget.incident.id));
            
            // Also load API model to get Evidence from Data level
            try {
              final datasource = getIt<IncidentRemoteDataSource>();
              final apiModel = await datasource.getIncidentDetailApiModel(widget.incident.id);
              if (mounted) {
                setState(() {
                  _evidenceFromApi = apiModel.evidence;
                });
              }
            } catch (e) {
              debugPrint('Failed to load API model for Evidence: $e');
            }
            
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

                  // Aksi Section
                  _buildAksiSection(incident),
                  20.verticalSpace,

                  // Tim Petugas (horizontal scrollable cards)
                  _buildTeamSection(incident),
                  20.verticalSpace,

                  // Tugas Penanganan (dari NotesAction atau HandlingTask di IncidentDetail)
                  _buildReadOnlyField(
                    label: 'Tugas Penanganan',
                    value: _getHandlingTask(incident),
                    maxLines: 3,
                  ),
                  20.verticalSpace,

                  // Note Penyelesaian
                  _buildReadOnlyField(
                    label: 'Note Penyelesaian',
                    value: _getActionTakenNote(incident) ?? incident.solvedAction ?? '-',
                    maxLines: 3,
                  ),
                  20.verticalSpace,

                  // Tanggal Penyelesaian
                  _buildReadOnlyField(
                    label: 'Tanggal Penyelesaian',
                    value: _getCompletionDate(incident),
                  ),
                  20.verticalSpace,

                  // Bukti Penyelesaian
                  _buildEvidenceField(incident),
                  20.verticalSpace,

                  // Diselesaikan Oleh
                  _buildReadOnlyField(
                    label: 'Diselesaikan Oleh',
                    value: _getCompletedBy(incident),
                  ),
                  20.verticalSpace,

                  // Diverifikasi Oleh
                  _buildReadOnlyField(
                    label: 'Diverifikasi Oleh',
                    value: _getVerifiedBy(incident),
                  ),
                  20.verticalSpace,

                  // Tanggal Verifikasi
                  _buildReadOnlyField(
                    label: 'Tanggal Verifikasi',
                    value: _getVerifiedDate(incident),
                  ),
                  20.verticalSpace,

                  // Completion Feedback
                  _buildReadOnlyField(
                    label: 'Completion Feedback',
                    value: _getSupervisorFeedback(incident),
                    maxLines: 3,
                  ),
                  20.verticalSpace,
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

  // Helper methods to extract data from IncidentDetail
  String? _getFirstIncidentDetailValue(IncidentEntity incident, String key) {
    if (incident.incidentDetail == null || incident.incidentDetail!.isEmpty) {
      return null;
    }
    final firstDetail = incident.incidentDetail!.first;
    final value = firstDetail[key];
    if (value != null && value.toString().isNotEmpty && value.toString() != '-') {
      return value.toString();
    }
    return null;
  }

  String _getReviewedBy(IncidentEntity incident) {
    final reviewedName = _getFirstIncidentDetailValue(incident, 'ReviewedName');
    if (reviewedName != null && reviewedName.isNotEmpty && reviewedName != '-') {
      return reviewedName;
    }
    return '-';
  }

  String? _getActionTakenNote(IncidentEntity incident) {
    return _getFirstIncidentDetailValue(incident, 'ActionTakenNote');
  }

  String _getHandlingTask(IncidentEntity incident) {
    final handlingTask = _getFirstIncidentDetailValue(incident, 'HandlingTask');
    if (handlingTask != null && handlingTask.isNotEmpty) {
      return handlingTask;
    }
    return incident.notesAction ?? '-';
  }

  String _getCompletionDate(IncidentEntity incident) {
    // Tanggal Penyelesaian = VerifiedDate
    final verifiedDate = _getFirstIncidentDetailValue(incident, 'VerifiedDate');
    if (verifiedDate != null && verifiedDate.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(verifiedDate);
        return DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dateTime);
      } catch (e) {
        return verifiedDate;
      }
    }
    return '-';
  }

  String _getCompletedBy(IncidentEntity incident) {
    final completedName = _getFirstIncidentDetailValue(incident, 'CompletedName');
    if (completedName != null && completedName.isNotEmpty && completedName != '-') {
      return completedName;
    }
    return '-';
  }

  String _getVerifiedBy(IncidentEntity incident) {
    final verifiedName = _getFirstIncidentDetailValue(incident, 'VerifiedName');
    if (verifiedName != null && verifiedName.isNotEmpty && verifiedName != '-') {
      return verifiedName;
    }
    return '-';
  }

  String _getVerifiedDate(IncidentEntity incident) {
    // Tanggal Verifikasi = SolvedDate
    if (incident.solvedDate != null) {
      return DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(incident.solvedDate!);
    }
    final solvedDate = _getFirstIncidentDetailValue(incident, 'SolvedDate');
    if (solvedDate != null && solvedDate.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(solvedDate);
        return DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dateTime);
      } catch (e) {
        return solvedDate;
      }
    }
    return '-';
  }

  String _getSupervisorFeedback(IncidentEntity incident) {
    final feedback = _getFirstIncidentDetailValue(incident, 'SupervisorFeedback');
    if (feedback != null && feedback.isNotEmpty && feedback != '-') {
      return feedback;
    }
    return '-';
  }

  Widget _buildEvidenceField(IncidentEntity incident) {
    // Evidence is at Data level, not in IncidentDetail
    // Try to get from API model first, then fallback to IncidentDetail
    String? evidence = _evidenceFromApi;
    if (evidence == null || evidence.isEmpty || evidence == '-') {
      evidence = _getFirstIncidentDetailValue(incident, 'Evidence');
    }
    
    if (evidence == null || evidence.isEmpty || evidence == '-') {
      return _buildReadOnlyField(
        label: 'Bukti Penyelesaian',
        value: '-',
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bukti Penyelesaian',
          style: TS.labelLarge,
        ),
        8.verticalSpace,
        GestureDetector(
          onTap: () {
            _showImagePreview(evidence!);
          },
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.grey.shade100,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                evidence,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: primaryColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 48.sp,
                          color: Colors.grey.shade400,
                        ),
                        8.verticalSpace,
                        Text(
                          'Gagal memuat gambar',
                          style: TS.bodySmall.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: REdgeInsets.all(16),
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 64.sp,
                              color: Colors.white,
                            ),
                            16.verticalSpace,
                            Text(
                              'Gagal memuat gambar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _navigateToChat(String userId, String userName) async {
    try {
      // Validate userId
      if (userId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ID pengguna tidak valid'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Get or create ChatBloc
      ChatBloc? chatBloc;
      try {
        chatBloc = context.read<ChatBloc>();
      } catch (e) {
        // If ChatBloc is not available in context, create new one
        chatBloc = getIt<ChatBloc>();
      }

      // Get current user ID to verify
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (currentUserId == null || currentUserId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mendapatkan ID pengguna saat ini'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Don't create conversation if trying to chat with self
      if (userId == currentUserId) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak dapat mengirim pesan ke diri sendiri'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Create conversation with the user
      chatBloc.add(ChatCreateConversation(memberUserIds: [userId]));
      
      // Wait for conversation to be created
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Navigate to conversation page
      if (mounted) {
        final currentState = chatBloc.state;
        if (currentState.selectedChatId != null) {
          // Find the chat that was just created
          final newChat = currentState.chats.firstWhere(
            (chat) => chat.id == currentState.selectedChatId,
            orElse: () => Chat(
              id: currentState.selectedChatId!,
              name: userName.isNotEmpty ? userName : 'Anggota Tim',
              type: ChatType.direct,
              participantIds: [userId],
              unreadCount: 0,
              isActive: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: chatBloc!,
                child: ChatConversationPage(chat: newChat),
              ),
            ),
          );
        } else {
          // If chat creation failed, show error
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal membuka chat'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error navigating to chat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka chat: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  Widget _buildAksiSection(IncidentEntity incident) {
    final reviewedName = _getReviewedBy(incident);
    final actionTakenNote = _getActionTakenNote(incident);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi',
          style: TS.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        8.verticalSpace,
        // Dikonfirmasi Oleh
        _buildReadOnlyField(
          label: 'Dikonfirmasi Oleh',
          value: reviewedName,
        ),
        20.verticalSpace,
        // Pembuatan Keputusan
        _buildReadOnlyField(
          label: 'Pembuatan Keputusan',
          value: actionTakenNote ?? '-',
        ),
        20.verticalSpace,
        // Penanggung Jawab
        _buildReadOnlyField(
          label: 'Penanggung Jawab',
          value: incident.pic ?? '-',
        ),
      ],
    );
  }

  Widget _buildTeamSection(IncidentEntity incident) {
    // Handle IncidentDetail and Teams
    // IncidentDetail contains detailed info (HandlingTask, ActionTakenNote, etc.)
    // Teams contains basic info (UserName, UserPhoto, etc.)
    
    final List<Map<String, dynamic>> teamMembers = [];
    
    if (incident.incidentDetail != null && incident.incidentDetail!.isNotEmpty) {
      for (var detail in incident.incidentDetail!) {
        final detailMap = Map<String, dynamic>.from(detail as Map);
        // Add all team members (from both IncidentDetail and Teams)
        teamMembers.add(detailMap);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tim Petugas',
          style: TS.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        8.verticalSpace,
        // Display team members in horizontal scrollable cards
        if (teamMembers.isNotEmpty)
          SizedBox(
            height: 200.h, // Increased height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                return _buildTeamMemberCardHorizontal(teamMembers[index]);
              },
            ),
          )
        else
          _buildReadOnlyField(
            label: 'Tim Petugas',
            value: '-',
          ),
      ],
    );
  }

  Widget _buildTeamMemberCardHorizontal(Map<String, dynamic> member) {
    final userName = member['UserName']?.toString() ?? '';
    final userPhoto = member['UserPhoto']?.toString();
    // Try to get userId from multiple possible fields
    final userId = member['UserId']?.toString() ?? 
                   member['userId']?.toString() ?? 
                   member['Id']?.toString() ?? 
                   '';
    
    // Check if userId is valid (not empty and not default UUID)
    final isValidUserId = userId.isNotEmpty && 
                          userId != '00000000-0000-0000-0000-000000000000';
    
    // Role bisa dari status atau field lain, default "Anggota Masuk"
    final role = 'Anggota Masuk';
    
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use min to prevent overflow
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Picture
          ClipRRect(
            borderRadius: BorderRadius.circular(40.r),
            child: userPhoto != null && userPhoto.isNotEmpty
                ? Image.network(
                    userPhoto,
                    width: 70.w, // Reduced from 80 to 70
                    height: 70.h, // Reduced from 80 to 70
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        child: Icon(Icons.person, size: 35.r, color: Colors.grey.shade600),
                      );
                    },
                  )
                : Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Icon(Icons.person, size: 35.r, color: Colors.grey.shade600),
                  ),
          ),
          6.verticalSpace, // Reduced from 8
          // Name
          Flexible(
            child: Text(
              userName.isNotEmpty ? userName : 'Anggota Tim',
              style: TS.bodySmall.copyWith( // Changed from bodyMedium to bodySmall
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          4.verticalSpace,
          // Role
          Text(
            role,
            style: TS.bodySmall.copyWith(
              color: Colors.red,
              fontSize: 10.sp, // Smaller font
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          6.verticalSpace, // Reduced from 8
          // Kirim Pesan Button
          SizedBox(
            width: double.infinity,
            height: 32.h, // Fixed height
            child: ElevatedButton(
              onPressed: isValidUserId && userName.isNotEmpty ? () async {
                _navigateToChat(userId, userName);
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValidUserId ? Colors.red : Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding: REdgeInsets.symmetric(vertical: 4), // Reduced padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade600,
              ),
              child: Text(
                'Kirim Pesan',
                style: TS.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp, // Smaller font
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
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
        
        // Tombol Tugaskan untuk status OPEN, ACKNOWLEDGE, atau ESCALATED
        if (apiStatus == 'OPEN' || apiStatus == 'ACKNOWLEDGE' || apiStatus == 'ESCALATED') {
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
    Map<String, String>? incidentApiData;

    // Load user list and incident detail
    try {
      final users = await datasource.getUserList();
      final apiModel = await datasource.getIncidentDetailApiModel(incident.id);
      
      // Sort user list by name (alphabetically)
      userList = users;
      userList.sort((a, b) {
        final nameA = (a['name'] ?? '').toLowerCase();
        final nameB = (b['name'] ?? '').toLowerCase();
        return nameA.compareTo(nameB);
      });

      incidentApiData = {
        'areasDescription': apiModel.areasDescription ?? apiModel.areas?.name ?? '',
        'areasId': apiModel.areasId ?? '',
        'idIncidentType': apiModel.idIncidentType?.toString() ?? '0',
        'incidentDate': apiModel.incidentDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'incidentTime': apiModel.incidentTime ?? '00:00:00',
        'incidentDescription': apiModel.incidentDescription ?? '',
        'reportId': apiModel.reportId ?? '',
      };
      
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
    final apiData = incidentApiData;

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
                          areasDescription: apiData['areasDescription']!,
                          areasId: apiData['areasId']!,
                          idIncidentType: int.parse(apiData['idIncidentType']!),
                          incidentDate: DateTime.parse(apiData['incidentDate']!),
                          incidentTime: apiData['incidentTime']!,
                          incidentDescription: apiData['incidentDescription']!,
                          reportId: apiData['reportId']!,
                          notesAction: tugasPenangananController.text.trim(),
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
    Map<String, String>? incidentApiData;

    // Load incident detail untuk mendapatkan data yang sudah ada
    try {
      final apiModel = await datasource.getIncidentDetailApiModel(incident.id);
      
      picId = apiModel.picId;
      // Team diambil dari Teams list
      if (apiModel.teams != null && apiModel.teams!.isNotEmpty) {
        team = apiModel.teams!
            .map((teamMember) {
              if (teamMember is Map<String, dynamic>) {
                return teamMember['UserId']?.toString() ?? '';
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }
      // HandlingTask diambil dari IncidentDetail jika ada, atau dari NotesAction
      handlingTask = '';
      if (apiModel.incidentDetail != null) {
        if (apiModel.incidentDetail is Map<String, dynamic>) {
          final detail = apiModel.incidentDetail as Map<String, dynamic>;
          handlingTask = detail['HandlingTask']?.toString() ?? apiModel.notesAction ?? '';
        } else if (apiModel.incidentDetail is List && (apiModel.incidentDetail as List).isNotEmpty) {
          final detailList = apiModel.incidentDetail as List;
          final firstDetail = detailList.first;
          if (firstDetail is Map<String, dynamic>) {
            handlingTask = firstDetail['HandlingTask']?.toString() ?? apiModel.notesAction ?? '';
          }
        }
      }
      if (handlingTask.isEmpty) {
        handlingTask = apiModel.notesAction ?? '';
      }

      incidentApiData = {
        'areasDescription': apiModel.areasDescription ?? apiModel.areas?.name ?? '',
        'areasId': apiModel.areasId ?? '',
        'idIncidentType': apiModel.idIncidentType?.toString() ?? '0',
        'incidentDate': apiModel.incidentDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'incidentTime': apiModel.incidentTime ?? '00:00:00',
        'incidentDescription': apiModel.incidentDescription ?? '',
        'reportId': apiModel.reportId ?? '',
      };
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
    final apiData = incidentApiData;

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
          areasDescription: apiData['areasDescription']!,
          areasId: apiData['areasId']!,
          idIncidentType: int.parse(apiData['idIncidentType']!),
          incidentDate: DateTime.parse(apiData['incidentDate']!),
          incidentTime: apiData['incidentTime']!,
          incidentDescription: apiData['incidentDescription']!,
          reportId: apiData['reportId']!,
          notesAction: handlingTask,
          picId: picId,
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
    final imagePicker = ImagePicker();
    String? picId;
    List<String> team = [];
    String handlingTask = '';
    Map<String, String>? incidentApiData;
    File? selectedImage;

    // Load incident detail untuk mendapatkan data yang sudah ada
    try {
      final apiModel = await datasource.getIncidentDetailApiModel(incident.id);
      
      picId = apiModel.picId;
      // Team diambil dari Teams list
      if (apiModel.teams != null && apiModel.teams!.isNotEmpty) {
        team = apiModel.teams!
            .map((teamMember) {
              if (teamMember is Map<String, dynamic>) {
                return teamMember['UserId']?.toString() ?? '';
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }
      // HandlingTask diambil dari IncidentDetail jika ada, atau dari NotesAction
      handlingTask = '';
      if (apiModel.incidentDetail != null) {
        if (apiModel.incidentDetail is Map<String, dynamic>) {
          final detail = apiModel.incidentDetail as Map<String, dynamic>;
          handlingTask = detail['HandlingTask']?.toString() ?? apiModel.notesAction ?? '';
        } else if (apiModel.incidentDetail is List && (apiModel.incidentDetail as List).isNotEmpty) {
          final detailList = apiModel.incidentDetail as List;
          final firstDetail = detailList.first;
          if (firstDetail is Map<String, dynamic>) {
            handlingTask = firstDetail['HandlingTask']?.toString() ?? apiModel.notesAction ?? '';
          }
        }
      }
      if (handlingTask.isEmpty) {
        handlingTask = apiModel.notesAction ?? '';
      }

      incidentApiData = {
        'areasDescription': apiModel.areasDescription ?? apiModel.areas?.name ?? '',
        'areasId': apiModel.areasId ?? '',
        'idIncidentType': apiModel.idIncidentType?.toString() ?? '0',
        'incidentDate': apiModel.incidentDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'incidentTime': apiModel.incidentTime ?? '00:00:00',
        'incidentDescription': apiModel.incidentDescription ?? '',
        'reportId': apiModel.reportId ?? '',
      };
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
    final apiData = incidentApiData;

    // Tampilkan dialog dengan form upload image
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tandai Sebagai Selesai'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Apakah Anda yakin ingin menandai insiden ini sebagai selesai?'),
                const SizedBox(height: 16),
                const Text(
                  'Upload Bukti Foto (Opsional)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (selectedImage == null)
                  ElevatedButton.icon(
                    onPressed: () async {
                      final source = await showDialog<ImageSource>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Pilih Sumber Foto'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                                title: const Text('Kamera'),
                                onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library, color: Colors.green),
                                title: const Text('Galeri'),
                                onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (source != null) {
                        try {
                          final XFile? image = await imagePicker.pickImage(
                            source: source,
                            imageQuality: 85,
                          );

                          if (image != null) {
                            setState(() {
                              selectedImage = File(image.path);
                            });
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal mengambil foto: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Pilih Foto'),
                  )
                else
                  Column(
                    children: [
                      Image.file(
                        selectedImage!,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedImage = null;
                          });
                        },
                        child: const Text('Hapus Foto'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
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
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Convert image to base64 if selected
    Map<String, dynamic>? incidentImage;
    if (selectedImage != null) {
      try {
        final bytes = await selectedImage!.readAsBytes();
        final base64Image = base64Encode(bytes);
        final fileName = path.basename(selectedImage!.path);
        final extension = path.extension(fileName).toLowerCase();
        
        String mimeType = 'image/jpeg';
        if (extension == '.png') {
          mimeType = 'image/png';
        } else if (extension == '.jpg' || extension == '.jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == '.gif') {
          mimeType = 'image/gif';
        }

        incidentImage = {
          'Filename': fileName,
          'MimeType': mimeType,
          'Base64': base64Image,
          'FileSize': bytes.length,
        };
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memproses gambar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    // Update status ke COMPLETED menggunakan updateAllIncident
    try {
      context.read<IncidentBloc>().add(
        UpdateAllIncidentEvent(
          incidentId: incident.id,
          areasDescription: apiData['areasDescription']!,
          areasId: apiData['areasId']!,
          idIncidentType: int.parse(apiData['idIncidentType']!),
          incidentDate: DateTime.parse(apiData['incidentDate']!),
          incidentTime: apiData['incidentTime']!,
          incidentDescription: apiData['incidentDescription']!,
          reportId: apiData['reportId']!,
          notesAction: handlingTask,
          picId: picId,
          team: team,
          handlingTask: handlingTask,
          solvedDate: DateTime.now(),
          status: 'COMPLETED',
          incidentImage: incidentImage,
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

