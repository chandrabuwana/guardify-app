import 'package:injectable/injectable.dart';
import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';

@injectable
class CreateIncidentReport {
  final IncidentRepository repository;

  CreateIncidentReport(this.repository);

  Future<IncidentEntity> call({
    required String reporterId,
    required DateTime tanggalInsiden,
    required DateTime jamInsiden,
    required String lokasiInsidenId,
    required String detailLokasiInsiden,
    required String tipeInsidenId,
    required String deskripsiInsiden,
    String? fotoInsiden,
    List<String>? fileUrls,
  }) {
    return repository.createIncidentReport(
      reporterId: reporterId,
      tanggalInsiden: tanggalInsiden,
      jamInsiden: jamInsiden,
      lokasiInsidenId: lokasiInsidenId,
      detailLokasiInsiden: detailLokasiInsiden,
      tipeInsidenId: tipeInsidenId,
      deskripsiInsiden: deskripsiInsiden,
      fotoInsiden: fotoInsiden,
      fileUrls: fileUrls,
    );
  }
}

