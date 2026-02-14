import 'package:injectable/injectable.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/entities/incident_location_entity.dart';
import '../../domain/entities/incident_type_entity.dart';
import '../../domain/repositories/incident_repository.dart';
import '../datasources/incident_remote_datasource.dart';

@LazySingleton(as: IncidentRepository)
class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource remoteDataSource;

  IncidentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<IncidentEntity>> getIncidentList({
    int start = 0,
    int length = 10,
    String? searchQuery,
    IncidentStatus? status,
  }) async {
    try {
      final models = await remoteDataSource.getIncidentList(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status != null ? _statusToString(status) : null,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get incident list: $e');
    }
  }

  @override
  Future<List<IncidentEntity>> getMyTasks({
    int start = 0,
    int length = 10,
    String? searchQuery,
    IncidentStatus? status,
  }) async {
    try {
      final models = await remoteDataSource.getMyTasks(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status != null ? _statusToString(status) : null,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get my tasks: $e');
    }
  }

  @override
  Future<IncidentEntity> getIncidentDetail(String incidentId) async {
    try {
      final model = await remoteDataSource.getIncidentDetail(incidentId);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get incident detail: $e');
    }
  }

  @override
  Future<IncidentEntity> createIncidentReport({
    required String reporterId,
    required DateTime tanggalInsiden,
    required DateTime jamInsiden,
    required String lokasiInsidenId,
    required String lokasiInsidenName,
    required String detailLokasiInsiden,
    required String tipeInsidenId,
    required String deskripsiInsiden,
    String? fotoInsiden,
    List<String>? fileUrls,
  }) async {
    try {
      final model = await remoteDataSource.createIncidentReport(
        reporterId: reporterId,
        tanggalInsiden: tanggalInsiden,
        jamInsiden: jamInsiden,
        lokasiInsidenId: lokasiInsidenId,
        lokasiInsidenName: lokasiInsidenName,
        detailLokasiInsiden: detailLokasiInsiden,
        tipeInsidenId: tipeInsidenId,
        deskripsiInsiden: deskripsiInsiden,
        fotoInsiden: fotoInsiden,
        fileUrls: fileUrls,
      );
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to create incident report: $e');
    }
  }

  @override
  Future<List<IncidentLocationEntity>> getIncidentLocations() async {
    try {
      final models = await remoteDataSource.getIncidentLocations();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get incident locations: $e');
    }
  }

  @override
  Future<List<IncidentTypeEntity>> getIncidentTypes() async {
    try {
      final models = await remoteDataSource.getIncidentTypes();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get incident types: $e');
    }
  }

  @override
  Future<bool> updateIncidentStatus({
    required String incidentId,
    required String status,
    String? notes,
    Map<String, dynamic>? file,
  }) async {
    try {
      return await remoteDataSource.updateIncidentStatus(
        incidentId: incidentId,
        status: status,
        notes: notes,
        file: file,
      );
    } catch (e) {
      throw Exception('Failed to update incident status: $e');
    }
  }

  @override
  Future<bool> editIncident({
    required String incidentId,
    required String areasDescription,
    required String areasId,
    required int idIncidentType,
    required DateTime incidentDate,
    required String incidentTime,
    required String incidentDescription,
    required String reportId,
    String? notesAction,
    String? picId,
    String? pjId,
    String? solvedAction,
    DateTime? solvedDate,
    required String status,
  }) async {
    try {
      return await remoteDataSource.editIncident(
        incidentId: incidentId,
        areasDescription: areasDescription,
        areasId: areasId,
        idIncidentType: idIncidentType,
        incidentDate: incidentDate,
        incidentTime: incidentTime,
        incidentDescription: incidentDescription,
        reportId: reportId,
        notesAction: notesAction,
        picId: picId,
        pjId: pjId,
        solvedAction: solvedAction,
        solvedDate: solvedDate,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to edit incident: $e');
    }
  }

  @override
  Future<List<Map<String, String>>> getUserList() async {
    try {
      return await remoteDataSource.getUserList();
    } catch (e) {
      throw Exception('Failed to get user list: $e');
    }
  }

  @override
  Future<bool> updateAllIncident({
    required String incidentId,
    required String areasDescription,
    required String areasId,
    required int idIncidentType,
    required DateTime incidentDate,
    required String incidentTime,
    required String incidentDescription,
    required String reportId,
    String? notesAction,
    String? picId,
    required List<String> team,
    String? handlingTask,
    String? solvedAction,
    DateTime? solvedDate,
    String? evidence,
    required String status,
    Map<String, dynamic>? incidentImage,
  }) async {
    try {
      return await remoteDataSource.updateAllIncident(
        incidentId: incidentId,
        areasDescription: areasDescription,
        areasId: areasId,
        idIncidentType: idIncidentType,
        incidentDate: incidentDate,
        incidentTime: incidentTime,
        incidentDescription: incidentDescription,
        reportId: reportId,
        notesAction: notesAction,
        picId: picId,
        team: team,
        handlingTask: handlingTask,
        solvedAction: solvedAction,
        solvedDate: solvedDate,
        evidence: evidence,
        status: status,
        incidentImage: incidentImage,
      );
    } catch (e) {
      throw Exception('Failed to update incident: $e');
    }
  }

  String _statusToString(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.menunggu:
        return 'menunggu';
      case IncidentStatus.diterima:
        return 'diterima';
      case IncidentStatus.ditugaskan:
        return 'ditugaskan';
      case IncidentStatus.proses:
        return 'proses';
      case IncidentStatus.eskalasi:
        return 'eskalasi';
      case IncidentStatus.selesai:
        return 'selesai';
      case IncidentStatus.terverifikasi:
        return 'terverifikasi';
      case IncidentStatus.tidakValid:
        return 'tidak valid';
    }
  }
}
