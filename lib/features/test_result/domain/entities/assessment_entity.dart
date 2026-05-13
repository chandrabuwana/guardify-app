import 'package:equatable/equatable.dart';

/// Entity untuk Assessment (dari /Assesment/list)
/// Tidak mengandung nilai ujian (Grade/KKM/Remedial)
class AssessmentEntity extends Equatable {
  final String id;
  final String? code;
  final String name;
  final DateTime? assessmentDate;
  final String? categoryName;
  final String? categoryCode;
  final int? minValue;
  final String? status;
  final String? idPic;
  final String? picName;
  final String? idSpv;

  const AssessmentEntity({
    required this.id,
    this.code,
    required this.name,
    this.assessmentDate,
    this.categoryName,
    this.categoryCode,
    this.minValue,
    this.status,
    this.idPic,
    this.picName,
    this.idSpv,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        assessmentDate,
        categoryName,
        categoryCode,
        minValue,
        status,
        idPic,
        picName,
        idSpv,
      ];
}
