import '../../domain/entities/panic_button_history_item.dart';
import '../models/panic_button_item_model.dart';

class PanicButtonHistoryMapper {
  static List<PanicButtonHistoryItem> toHistoryItems(
    List<PanicButtonItemModel> models,
  ) {
    return models.map((model) => toHistoryItem(model)).toList();
  }

  static PanicButtonHistoryItem toHistoryItem(PanicButtonItemModel model) {
    return PanicButtonHistoryItem(
      id: model.id,
      action: model.action,
      areasId: model.areasId,
      areaName: model.areas?.name,
      createBy: model.createBy,
      createDate: model.createDate != null
          ? DateTime.tryParse(model.createDate!)
          : null,
      description: model.description,
      feedback: model.feedback,
      idIncidentType: model.idIncidentType,
      incidentTypeName: model.incidentType?.name,
      reporterDate: DateTime.tryParse(model.reporterDate),
      reporterId: model.reporterId,
      reporterName: model.reporter?.fullname,
      reporterNrp: model.reporter?.noNrp,
      resolveAction: model.resolveAction,
      solverDate: model.solverDate != null
          ? DateTime.tryParse(model.solverDate!)
          : null,
      solverId: model.solverId,
      solverName: _parseSolverName(model.solver),
      solverNrp: _parseSolverNrp(model.solver),
      status: model.status,
      files: model.files != null
          ? model.files!
              .map((file) => PanicButtonHistoryFile(
                    filename: file.filename,
                    url: file.url,
                  ))
              .toList()
          : [],
    );
  }

  static String? _parseSolverName(dynamic solver) {
    if (solver == null) return null;
    try {
      if (solver is Map<String, dynamic>) {
        return solver['Fullname'] as String?;
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }

  static String? _parseSolverNrp(dynamic solver) {
    if (solver == null) return null;
    try {
      if (solver is Map<String, dynamic>) {
        return solver['NoNrp'] as String?;
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }
}

