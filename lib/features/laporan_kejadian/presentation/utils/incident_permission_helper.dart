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
  static Future<bool> canReviewIncident({
    required IncidentEntity incident,
    required UserRole currentUserRole,
    UserRole? reporterRole,
  }) async {
    // Hanya bisa review jika status menunggu
    if (incident.status != IncidentStatus.menunggu) {
      return false;
    }
    
    // Jika reporter role diketahui, check berdasarkan rules
    if (reporterRole != null) {
      if (reporterRole == UserRole.anggota) {
        // Pelapor = Anggota -> Danton dapat review
        return currentUserRole == UserRole.danton;
      } else if (reporterRole == UserRole.danton) {
        // Pelapor = Danton -> PJO/Deputy dapat review
        return currentUserRole == UserRole.pjo || currentUserRole == UserRole.deputy;
      }
      // Jika reporter role bukan anggota atau danton, tidak bisa review
      return false;
    }
    
    // Fallback: Jika reporter role tidak diketahui, check berdasarkan current user role
    // Danton dapat review jika status menunggu (asumsi pelapor adalah anggota)
    // Ini sesuai dengan business rule: Pelapor = Anggota -> Danton dapat review
    if (currentUserRole == UserRole.danton) {
      return true;
    }
    
    // PJO/Deputy dapat review jika status menunggu (asumsi pelapor adalah danton)
    // Ini sesuai dengan business rule: Pelapor = Danton -> PJO/Deputy dapat review
    if (currentUserRole == UserRole.pjo || currentUserRole == UserRole.deputy) {
      return true;
    }
    
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
  static bool canEscalateIncident({
    required IncidentEntity incident,
    required UserRole currentUserRole,
  }) {
    if (incident.status == IncidentStatus.diterima) {
      // Status = Diterima -> PJO/Deputy dapat escalate
      return currentUserRole == UserRole.pjo || currentUserRole == UserRole.deputy;
    }
    
    return false;
  }
  
  /// Check apakah user dapat verify incident
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
  
  /// Check apakah user dapat revise incident
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
