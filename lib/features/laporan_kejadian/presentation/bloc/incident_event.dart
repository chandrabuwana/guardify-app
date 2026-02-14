import 'package:equatable/equatable.dart';
import '../../domain/entities/incident_entity.dart';

abstract class IncidentEvent extends Equatable {
  const IncidentEvent();

  @override
  List<Object?> get props => [];
}

// Load incident list
class LoadIncidentListEvent extends IncidentEvent {
  final int start;
  final int length;
  final String? searchQuery;
  final IncidentStatus? status;

  const LoadIncidentListEvent({
    this.start = 0,
    this.length = 50, // Increased from 10 to 50
    this.searchQuery,
    this.status,
  });

  @override
  List<Object?> get props => [start, length, searchQuery, status];
}

// Load more incidents (pagination)
class LoadMoreIncidentListEvent extends IncidentEvent {
  const LoadMoreIncidentListEvent();
}

// Refresh incident list
class RefreshIncidentListEvent extends IncidentEvent {
  const RefreshIncidentListEvent();
}

// Search incidents
class SearchIncidentListEvent extends IncidentEvent {
  final String query;

  const SearchIncidentListEvent(this.query);

  @override
  List<Object> get props => [query];
}

// Load my tasks
class LoadMyTasksEvent extends IncidentEvent {
  final int start;
  final int length;
  final String? searchQuery;
  final IncidentStatus? status;

  const LoadMyTasksEvent({
    this.start = 0,
    this.length = 10,
    this.searchQuery,
    this.status,
  });

  @override
  List<Object?> get props => [start, length, searchQuery, status];
}

// Load more my tasks (pagination)
class LoadMoreMyTasksEvent extends IncidentEvent {
  const LoadMoreMyTasksEvent();
}

// Refresh my tasks
class RefreshMyTasksEvent extends IncidentEvent {
  const RefreshMyTasksEvent();
}

// Search my tasks
class SearchMyTasksEvent extends IncidentEvent {
  final String query;

  const SearchMyTasksEvent(this.query);

  @override
  List<Object> get props => [query];
}

// Get incident detail
class GetIncidentDetailEvent extends IncidentEvent {
  final String incidentId;

  const GetIncidentDetailEvent(this.incidentId);

  @override
  List<Object> get props => [incidentId];
}

// Create incident report
class CreateIncidentReportEvent extends IncidentEvent {
  final String reporterId;
  final DateTime tanggalInsiden;
  final DateTime jamInsiden;
  final String lokasiInsidenId;
  final String lokasiInsidenName;
  final String detailLokasiInsiden;
  final String tipeInsidenId;
  final String deskripsiInsiden;
  final String? fotoInsiden;
  final List<String>? fileUrls;

  const CreateIncidentReportEvent({
    required this.reporterId,
    required this.tanggalInsiden,
    required this.jamInsiden,
    required this.lokasiInsidenId,
    required this.lokasiInsidenName,
    required this.detailLokasiInsiden,
    required this.tipeInsidenId,
    required this.deskripsiInsiden,
    this.fotoInsiden,
    this.fileUrls,
  });

  @override
  List<Object?> get props => [
        reporterId,
        tanggalInsiden,
        jamInsiden,
        lokasiInsidenId,
        lokasiInsidenName,
        detailLokasiInsiden,
        tipeInsidenId,
        deskripsiInsiden,
        fotoInsiden,
        fileUrls,
      ];
}

// Load incident locations
class LoadIncidentLocationsEvent extends IncidentEvent {
  const LoadIncidentLocationsEvent();
}

// Load incident types
class LoadIncidentTypesEvent extends IncidentEvent {
  const LoadIncidentTypesEvent();
}

// Update incident status
class UpdateIncidentStatusEvent extends IncidentEvent {
  final String incidentId;
  final String status; // "PROGRESS" or "COMPLETED"
  final String? notes;
  final Map<String, dynamic>? file;

  const UpdateIncidentStatusEvent({
    required this.incidentId,
    required this.status,
    this.notes,
    this.file,
  });

  @override
  List<Object?> get props => [incidentId, status, notes, file];
}

// Edit incident (for PJO/Deputy to assign)
class EditIncidentEvent extends IncidentEvent {
  final String incidentId;
  final String areasDescription;
  final String areasId;
  final int idIncidentType;
  final DateTime incidentDate;
  final String incidentTime;
  final String incidentDescription;
  final String reportId;
  final String? notesAction;
  final String? picId;
  final String? pjId;
  final String? solvedAction;
  final DateTime? solvedDate;
  final String status;

  const EditIncidentEvent({
    required this.incidentId,
    required this.areasDescription,
    required this.areasId,
    required this.idIncidentType,
    required this.incidentDate,
    required this.incidentTime,
    required this.incidentDescription,
    required this.reportId,
    this.notesAction,
    this.picId,
    this.pjId,
    this.solvedAction,
    this.solvedDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
        incidentId,
        areasDescription,
        areasId,
        idIncidentType,
        incidentDate,
        incidentTime,
        incidentDescription,
        reportId,
        notesAction,
        picId,
        pjId,
        solvedAction,
        solvedDate,
        status,
      ];
}

// Update all incident (for PJO/Deputy to assign PIC and Team)
class UpdateAllIncidentEvent extends IncidentEvent {
  final String incidentId;
  final String areasDescription;
  final String areasId;
  final int idIncidentType;
  final DateTime incidentDate;
  final String incidentTime;
  final String incidentDescription;
  final String reportId;
  final String? notesAction;
  final String? picId;
  final List<String> team;
  final String? handlingTask;
  final String? solvedAction;
  final DateTime? solvedDate;
  final String? evidence;
  final String status;
  final Map<String, dynamic>? incidentImage;

  const UpdateAllIncidentEvent({
    required this.incidentId,
    required this.areasDescription,
    required this.areasId,
    required this.idIncidentType,
    required this.incidentDate,
    required this.incidentTime,
    required this.incidentDescription,
    required this.reportId,
    this.notesAction,
    this.picId,
    required this.team,
    this.handlingTask,
    this.solvedAction,
    this.solvedDate,
    this.evidence,
    required this.status,
    this.incidentImage,
  });

  @override
  List<Object?> get props => [
        incidentId,
        areasDescription,
        areasId,
        idIncidentType,
        incidentDate,
        incidentTime,
        incidentDescription,
        reportId,
        notesAction,
        picId,
        team,
        handlingTask,
        solvedAction,
        solvedDate,
        evidence,
        status,
        incidentImage,
      ];
}

// Clear error
class ClearIncidentErrorEvent extends IncidentEvent {
  const ClearIncidentErrorEvent();
}

