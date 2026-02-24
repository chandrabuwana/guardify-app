import '../../domain/entities/incident_entity.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/utils/user_role_helper.dart';

/// Helper class untuk permission checks pada incident module
/// Sesuai dengan business rules di .cursor/rules/incident-module-rules.mdc
class IncidentPermissionHelper {
  /// Check apakah user dapat review incident berdasarkan role pelapor
  /// 
  /// Rules:
  /// - Pelapor = Anggota -> Danton dapat review
  /// - Pelapor = Danton -> PJO/Deputy dapat review
  /// - User tidak dapat review laporan sendiri
  /// - Danton tidak dapat review laporan dari Danton lain
  static Future<bool> canReviewIncident({
    required IncidentEntity incident,
    required UserRole currentUserRole,
    UserRole? reporterRole,
    String? currentUserId,
    String? reporterId,
  }) async {
    // Hanya bisa review jika status menunggu
    if (incident.status != IncidentStatus.menunggu) {
      return false;
    }
    
    // Check: User tidak dapat review laporan sendiri
    if (currentUserId != null && reporterId != null && 
        currentUserId.isNotEmpty && reporterId.isNotEmpty &&
        currentUserId == reporterId) {
      return false;
    }
    
    // Get reporter role from incident if not provided
    UserRole? actualReporterRole = reporterRole;
    if (actualReporterRole == null && incident.reporterRole != null && incident.reporterRole!.isNotEmpty) {
      actualReporterRole = UserRole.fromValue(incident.reporterRole!);
    }
    
    // Jika reporter role diketahui, check berdasarkan rules
    if (actualReporterRole != null) {
      if (actualReporterRole == UserRole.anggota) {
        // Pelapor = Anggota -> Danton dapat review
        // Tapi pastikan current user bukan pelapor sendiri
        return currentUserRole == UserRole.danton;
      } else if (actualReporterRole == UserRole.danton) {
        // Pelapor = Danton -> PJO/Deputy dapat review
        // Danton tidak dapat review laporan dari Danton lain
        if (currentUserRole == UserRole.danton) {
          return false; // Danton tidak dapat review laporan dari Danton
        }
        return currentUserRole == UserRole.pjo || currentUserRole == UserRole.deputy;
      } else if (actualReporterRole == UserRole.pjo || 
                 actualReporterRole == UserRole.deputy || 
                 actualReporterRole == UserRole.pengawas) {
        // Pelapor = PJO/Deputy/Pengawas -> Status langsung Diterima (tidak menunggu)
        // Tidak perlu review, jadi tidak ada yang bisa review
        return false;
      }
      // Jika reporter role tidak dikenal, tidak bisa review
      return false;
    }
    
    // Fallback: Jika reporter role tidak diketahui, kita tidak bisa menentukan permission dengan pasti
    // Untuk safety, kita reject review jika tidak tahu role pelapor
    // Ini mencegah Danton review laporan dari Danton lain jika role tidak tersedia
    // 
    // PERHATIAN: Fallback ini lebih ketat untuk mencegah security issue
    // Sebaiknya selalu pass reporterRole jika memungkinkan
    
    // Jika reporter role tidak diketahui, reject untuk safety
    // Ini mencegah:
    // - Danton review laporan dari Danton lain
    // - PJO/Deputy review laporan yang bukan dari Danton
    return false;
  }
  
  /// Check apakah user dapat assign incident
  /// 
  /// Rules:
  /// - Status = Escalated -> Hanya Pengawas yang dapat assign
  /// - Status = Diterima -> PJO/Deputy/Pengawas dapat assign
  static bool canAssignIncident({
    required IncidentEntity incident,
    required UserRole currentUserRole,
  }) {
    if (incident.status == IncidentStatus.eskalasi) {
      // Status = Escalated -> Hanya Pengawas yang dapat assign
      return currentUserRole == UserRole.pengawas;
    }
    
    if (incident.status == IncidentStatus.diterima) {
      // Status = Diterima -> PJO/Deputy/Pengawas dapat assign
      return currentUserRole == UserRole.pjo || 
             currentUserRole == UserRole.deputy || 
             currentUserRole == UserRole.pengawas;
    }
    
    return false;
  }
  
  /// Check apakah user dapat escalate incident
  /// 
  /// Rules:
  /// - Status = Diterima -> PJO/Deputy dapat escalate
  /// - Pengawas TIDAK dapat escalate (hanya dapat assign)
  static bool canEscalateIncident({
    required IncidentEntity incident,
    required UserRole currentUserRole,
  }) {
    if (incident.status == IncidentStatus.diterima) {
      // Status = Diterima -> PJO/Deputy dapat escalate
      // Pengawas TIDAK dapat escalate (hanya dapat assign)
      return currentUserRole == UserRole.pjo || currentUserRole == UserRole.deputy;
    }
    
    return false;
  }
  
  /// Check apakah incident sebelumnya pernah di-escalate
  /// 
  /// Detection methods:
  /// 1. Jika PIC adalah PJO/Deputy -> kemungkinan besar di-assign oleh pengawas setelah escalated
  /// 2. Jika status saat ini adalah selesai dan pernah ada status escalated
  /// 3. Check dari incident detail untuk melihat siapa yang assign (decision maker = pengawas)
  static Future<bool> wasPreviouslyEscalated({
    required IncidentEntity incident,
    dynamic apiModel, // Optional: API model untuk akses data lengkap
  }) async {
    // Method 1: Check jika PIC adalah PJO/Deputy
    // Jika PIC adalah PJO/Deputy, kemungkinan besar ini di-assign oleh pengawas setelah escalated
    // Karena normalnya PJO/Deputy tidak akan menjadi PIC kecuali di-assign oleh pengawas setelah escalated
    if (incident.picId != null && incident.picId!.isNotEmpty) {
      // Kita perlu check role dari PIC
      // Untuk sekarang, kita bisa check dari nama PIC atau dari API model
      // Jika PIC name mengandung "PJO" atau "Deputy", kemungkinan besar ini escalated
      final picName = incident.pic?.toUpperCase() ?? '';
      if (picName.contains('PJO') || picName.contains('DEPUTY')) {
        return true;
      }
    }
    
    // Method 2: Check dari API model jika tersedia
    if (apiModel != null) {
      // Check jika ada indikasi bahwa ini di-assign oleh pengawas
      // Bisa dilihat dari incident detail atau status history
      // Untuk sekarang, kita check jika PIC adalah PJO/Deputy dari API model
      try {
        // Access pic from API model
        final pic = apiModel.pic;
        if (pic != null) {
          // Check if pic is UserModel (from incident_api_model.dart)
          if (pic is Map) {
            final picJabatan = pic['Jabatan']?.toString().toUpperCase() ?? '';
            if (picJabatan.contains('PJO') || picJabatan.contains('DEPUTY')) {
              return true;
            }
          } else if (pic is String) {
            final picUpper = pic.toUpperCase();
            if (picUpper.contains('PJO') || picUpper.contains('DEPUTY')) {
              return true;
            }
          } else {
            // Check if pic has jabatan property (UserModel object)
            try {
              final picJabatan = pic.jabatan?.toString().toUpperCase() ?? '';
              if (picJabatan.contains('PJO') || picJabatan.contains('DEPUTY')) {
                return true;
              }
            } catch (e) {
              // Ignore if jabatan property doesn't exist
            }
          }
        }
      } catch (e) {
        // Ignore error, continue with other checks
      }
    }
    
    // Method 3: Check dari incident detail untuk melihat siapa yang assign
    // Jika ada reviewedBy atau assignedBy yang adalah pengawas, kemungkinan besar ini escalated
    // Tapi ini memerlukan data tambahan yang mungkin tidak tersedia
    
    return false;
  }
  
  /// Check apakah user dapat verify incident (sync version)
  /// 
  /// Rules:
  /// - Status = Selesai -> PJO/Deputy/Pengawas dapat verify
  /// - Jika sebelumnya status = escalated -> Hanya Pengawas yang dapat verify
  static bool canVerifyIncident({
    required IncidentEntity incident,
    required UserRole currentUserRole,
    bool wasPreviouslyEscalated = false,
  }) {
    if (incident.status != IncidentStatus.selesai) {
      return false;
    }
    
    // Jika sebelumnya escalated, hanya Pengawas yang dapat verify
    if (wasPreviouslyEscalated) {
      return currentUserRole == UserRole.pengawas;
    }
    
    // Jika tidak escalated, PJO/Deputy/Pengawas dapat verify
    return currentUserRole == UserRole.pjo || 
           currentUserRole == UserRole.deputy || 
           currentUserRole == UserRole.pengawas;
  }
  
  /// Check apakah user dapat revise incident (sync version)
  /// 
  /// Rules:
  /// - Status = Selesai -> PJO/Deputy/Pengawas dapat revise
  /// - Jika sebelumnya status = escalated -> Hanya Pengawas yang dapat revise
  static bool canReviseIncident({
    required IncidentEntity incident,
    required UserRole currentUserRole,
    bool wasPreviouslyEscalated = false,
  }) {
    if (incident.status != IncidentStatus.selesai) {
      return false;
    }
    
    // Jika sebelumnya escalated, hanya Pengawas yang dapat revise
    if (wasPreviouslyEscalated) {
      return currentUserRole == UserRole.pengawas;
    }
    
    // Jika tidak escalated, PJO/Deputy/Pengawas dapat revise
    return currentUserRole == UserRole.pjo || 
           currentUserRole == UserRole.deputy || 
           currentUserRole == UserRole.pengawas;
  }
  
  /// Check apakah user adalah PIC atau Team Member dari incident
  static Future<bool> isPICOrTeamMember({
    required IncidentEntity incident,
  }) async {
    final currentUserId = await UserRoleHelper.getUserId();
    if (currentUserId == null || currentUserId.isEmpty) {
      return false;
    }
    
    // Check jika user adalah PIC
    if (incident.picId == currentUserId) {
      return true;
    }
    
    // Check jika user adalah Team Member
    if (incident.incidentDetail != null && incident.incidentDetail!.isNotEmpty) {
      for (var detail in incident.incidentDetail!) {
        final teamUserId = detail['UserId']?.toString() ?? '';
        if (teamUserId == currentUserId) {
          return true;
        }
      }
    }
    
    return false;
  }
  
  /// Check apakah incident muncul di "Tugas Saya" tab
  /// 
  /// Rules:
  /// - Status = Ditugaskan atau Proses
  /// - User adalah PIC atau Team Member
  static Future<bool> shouldShowInMyTasks({
    required IncidentEntity incident,
  }) async {
    // Check status
    if (incident.status != IncidentStatus.ditugaskan && 
        incident.status != IncidentStatus.proses) {
      return false;
    }
    
    // Check jika user adalah PIC atau Team Member
    return await isPICOrTeamMember(incident: incident);
  }
  
  /// Check apakah user dapat memproses incident (button "Proses")
  /// 
  /// Rules:
  /// - Status = Ditugaskan
  /// - User adalah PIC atau Team Member
  /// - Aksi: Mengubah status dari Ditugaskan ke Proses (PROGRESS)
  static Future<bool> canProcessIncident({
    required IncidentEntity incident,
  }) async {
    if (incident.status != IncidentStatus.ditugaskan) {
      return false;
    }
    
    return await isPICOrTeamMember(incident: incident);
  }
  
  /// Check apakah user dapat menandai incident sebagai selesai
  /// 
  /// Rules:
  /// - Status = Proses
  /// - User adalah PIC atau Team Member
  /// - Aksi: Mengubah status dari Proses ke Selesai (COMPLETED)
  static Future<bool> canMarkAsCompleted({
    required IncidentEntity incident,
  }) async {
    if (incident.status != IncidentStatus.proses) {
      // Note: Revisi status tidak ada di enum, jadi kita check proses saja
      // Jika ada status revisi di masa depan, tambahkan di sini
      return false;
    }
    
    return await isPICOrTeamMember(incident: incident);
  }
  
  /// Check apakah field solvedAction dan evidence harus di-enable
  /// 
  /// Rules:
  /// - Status = Revisi -> Enable field Note penyelesaian dan Bukti Penyelesaian
  /// - User adalah PIC atau Team Member yang sedang menyelesaikan task
  static Future<bool> shouldEnableCompletionFields({
    required IncidentEntity incident,
  }) async {
    // Note: Revisi status tidak ada di enum saat ini
    // Jika status revisi ditambahkan, check di sini
    // if (incident.status == IncidentStatus.revisi) {
    //   return await isPICOrTeamMember(incident: incident);
    // }
    
    // Enable jika user adalah PIC/Team Member dan status adalah proses
    if (incident.status == IncidentStatus.proses) {
      return await isPICOrTeamMember(incident: incident);
    }
    
    return false;
  }
}
