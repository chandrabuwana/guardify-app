import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'test_result_model.dart';
import '../../domain/entities/test_result_entity.dart';

part 'assessment_detail_response_model.g.dart';
// When Ujian Anggota pakai assesment/list .
//ketika card di click pakai AssesmentDetail/list 
// untuk UI yang atas
// {
//   "Filter": [
//     {
//       "Field": "IdAssesment",
//       "Search": "4e7c022e-1cca-4561-8fbb-093099a1e6aa"
//     }
//   ],
//   "Sort": {
//     "Field": "string",
//     "Type": 0
//   },
//   "Start": 0,
//   "Length": 0
// }
// untuk UI yang bawah
// {
//   "Filter": [
//     {
//       "Field": "IdSpv",
//       "Search": ""
//     }
//   ],
//   "Sort": {
//     "Field": "string",
//     "Type": 0
//   },
//   "Start": 0,
//   "Length": 0
// }
//trus di hitung 

@JsonSerializable()
class AssessmentDetailResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<AssessmentDetailItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  const AssessmentDetailResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory AssessmentDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentDetailResponseModelToJson(this);
}

/// Model untuk item detail assessment
@JsonSerializable()
class AssessmentDetailItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'Grade')
  final int grade;

  @JsonKey(name: 'RemedialGrade')
  final int? remedialGrade;

  @JsonKey(name: 'IdAssesment')
  final String idAssesment;

  @JsonKey(name: 'Assesment')
  final AssessmentInfoModel? assessment;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'UserId')
  final String userId;

  @JsonKey(name: 'UserFullname')
  final String? userFullname;

  @JsonKey(name: 'UserJabatan')
  final String? userJabatan;

  const AssessmentDetailItemModel({
    required this.id,
    this.createBy,
    this.createDate,
    required this.grade,
    this.remedialGrade,
    required this.idAssesment,
    this.assessment,
    required this.status,
    this.updateBy,
    this.updateDate,
    required this.userId,
    this.userFullname,
    this.userJabatan,
  });

  factory AssessmentDetailItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentDetailItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentDetailItemModelToJson(this);

  /// Convert ke TestResultModel
  TestResultModel toTestResultModel() {
    // Parse status dari API ke enum
    TestKelulusanStatus parseStatus;
    if (status.toLowerCase() == 'lulus') {
      parseStatus = TestKelulusanStatus.lulus;
    } else if (status.toLowerCase() == 'tidak lulus' || status.toLowerCase() == 'tidaklulus') {
      parseStatus = TestKelulusanStatus.tidakLulus;
    } else {
      parseStatus = TestKelulusanStatus.belumDinilai;
    }

    // Parse tanggal assessment - gunakan AssesmentDate dari nested object
    DateTime tanggalTest;
    if (assessment?.assessmentDate != null) {
      try {
        tanggalTest = DateTime.parse(assessment!.assessmentDate!);
      } catch (e) {
        tanggalTest = DateTime.now();
      }
    } else if (createDate != null) {
      try {
        tanggalTest = DateTime.parse(createDate!);
      } catch (e) {
        tanggalTest = DateTime.now();
      }
    } else {
      tanggalTest = DateTime.now();
    }

    // Ambil nama assessment dari nested object atau gunakan default
    String namaTest = assessment?.name ?? 'Assessment';
    
    // Gunakan Code dari Assessment, fallback ke ID pendek jika tidak ada
    // Prioritas: Assessment.Code > fallback
    String assessmentCode;
    if (assessment != null && assessment!.code != null && assessment!.code!.isNotEmpty) {
      assessmentCode = assessment!.code!;
    } else {
      assessmentCode = 'PNC${id.substring(0, 5).toUpperCase()}';
    }
    
    // Debug logging
    debugPrint('📋 [AssessmentDetailItemModel] Assessment Code Mapping:');
    debugPrint('  - id: $id');
    debugPrint('  - assessment is null: ${assessment == null}');
    if (assessment != null) {
      debugPrint('  - assessment.id: ${assessment!.id}');
      debugPrint('  - assessment.code: ${assessment!.code}');
      debugPrint('  - assessment.name: ${assessment!.name}');
    }
    debugPrint('  - Final assessmentCode: $assessmentCode');

    return TestResultModel(
      id: assessmentCode, // Code dari Assessment
      userId: userId,
      namaTest: namaTest, // Nama dari Assessment.Name
      tanggalTest: tanggalTest,
      nilaiTest: grade, // Grade dari response
      nilaiKKM: assessment?.minValue ?? 80, // MinValue dari Assessment
      remedialGrade: remedialGrade, // RemedialGrade dari response
      status: parseStatus,
      tipeTest: 'Ujian Tahunan', // Hardcode karena tidak ada di API
      keterangan: createBy,
      userFullname: userFullname,
      userJabatan: userJabatan,
    );
  }
}

/// Model untuk info assessment
@JsonSerializable()
class AssessmentInfoModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Code')
  final String? code;

  @JsonKey(name: 'AssesmentDate')
  final String? assessmentDate;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'IdAssesmentCategory')
  final int? idAssesmentCategory;

  @JsonKey(name: 'AssesmentCategory')
  final dynamic assessmentCategory;

  @JsonKey(name: 'IdPic')
  final String? idPic;

  @JsonKey(name: 'MinValue')
  final int minValue;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'Pic')
  final dynamic pic;

  @JsonKey(name: 'Name')
  final String? name;

  const AssessmentInfoModel({
    required this.id,
    this.code,
    this.assessmentDate,
    this.createBy,
    this.createDate,
    this.idAssesmentCategory,
    this.assessmentCategory,
    this.idPic,
    required this.minValue,
    this.status,
    this.updateBy,
    this.updateDate,
    this.pic,
    this.name,
  });

  factory AssessmentInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentInfoModelToJson(this);
}
