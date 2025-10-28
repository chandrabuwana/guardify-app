import 'package:json_annotation/json_annotation.dart';
import 'test_result_model.dart';
import '../../domain/entities/test_result_entity.dart';

part 'assessment_detail_response_model.g.dart';

/// Response model untuk API AssessmentDetail/list
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

  @JsonKey(name: 'IdAssesment')
  final String idAssessment;

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

  const AssessmentDetailItemModel({
    required this.id,
    this.createBy,
    this.createDate,
    required this.grade,
    required this.idAssessment,
    this.assessment,
    required this.status,
    this.updateBy,
    this.updateDate,
    required this.userId,
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
    
    // Generate ID pendek dari full UUID (ambil 8 karakter pertama + huruf acak)
    String shortId = 'PNC${id.substring(0, 5).toUpperCase()}';

    return TestResultModel(
      id: shortId, // ID pendek untuk display
      userId: userId,
      namaTest: namaTest, // Nama dari Assessment.Name
      tanggalTest: tanggalTest,
      nilaiTest: grade, // Grade dari response
      nilaiKKM: assessment?.minValue ?? 80, // MinValue dari Assessment
      status: parseStatus,
      tipeTest: 'Ujian Tahunan', // Hardcode karena tidak ada di API
      keterangan: createBy,
    );
  }
}

/// Model untuk info assessment
@JsonSerializable()
class AssessmentInfoModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'AssesmentDate')
  final String? assessmentDate;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'IdAssesmentCategory')
  final int? idAssessmentCategory;

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
    this.assessmentDate,
    this.createBy,
    this.createDate,
    this.idAssessmentCategory,
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
