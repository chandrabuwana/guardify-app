import 'package:json_annotation/json_annotation.dart';
import '../../../../core/constants/enums.dart';

part 'bmi_api_response_model.g.dart';

/// Response model untuk BMI List API
@JsonSerializable()
class BmiListResponseModel {
  @JsonKey(name: 'Count', defaultValue: 0)
  final int count;

  @JsonKey(name: 'Filtered', defaultValue: 0)
  final int filtered;

  @JsonKey(name: 'List', defaultValue: <BmiDataModel>[]) 
  final List<BmiDataModel> list;

  @JsonKey(name: 'Code', defaultValue: 0)
  final int code;

  @JsonKey(name: 'Succeeded', defaultValue: false)
  final bool succeeded;

  @JsonKey(name: 'Message', defaultValue: '')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  BmiListResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory BmiListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BmiListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BmiListResponseModelToJson(this);
}

/// Model untuk data BMI dari API
@JsonSerializable()
class BmiDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Category')
  final String? category;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final DateTime? createDate;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  @JsonKey(name: 'Height')
  final double height;

  @JsonKey(name: 'Nip')
  final String? nip;

  @JsonKey(name: 'Recommendation')
  final String? recommendation;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final DateTime? updateDate;

  @JsonKey(name: 'UserId')
  final String userId;

  @JsonKey(name: 'User')
  final UserDataModel? user;

  @JsonKey(name: 'Weight')
  final double weight;

  @JsonKey(name: 'BmiValue')
  final double? bmiValue;

  BmiDataModel({
    required this.id,
    this.category,
    this.createBy,
    this.createDate,
    this.fullname,
    required this.height,
    this.nip,
    this.recommendation,
    this.updateBy,
    this.updateDate,
    required this.userId,
    this.user,
    required this.weight,
    this.bmiValue,
  });

  factory BmiDataModel.fromJson(Map<String, dynamic> json) =>
      _$BmiDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$BmiDataModelToJson(this);

  /// Calculate BMI - use BmiValue from API if available, otherwise calculate
  double get bmi => bmiValue ?? (weight / ((height / 100) * (height / 100)));

  /// Get BMI Status - use Category from API if available, otherwise calculate from BMI
  BMIStatus get bmiStatus {
    // Try to map Category from API first
    if (category != null && category!.isNotEmpty) {
      final categoryLower = category!.toLowerCase();
      if (categoryLower.contains('kurus') || categoryLower.contains('berat badan kurang')) {
        return BMIStatus.underweight;
      } else if (categoryLower.contains('normal') || categoryLower.contains('ideal')) {
        return BMIStatus.normal;
      } else if (categoryLower.contains('kelebihan') || categoryLower.contains('berlebih') || categoryLower.contains('gemuk')) {
        return BMIStatus.overweight;
      } else if (categoryLower.contains('obesitas')) {
        return BMIStatus.obese;
      }
    }
    
    // Fallback to calculation from BMI value
    final calculatedBmi = bmi;
    if (calculatedBmi < 18.5) return BMIStatus.underweight;
    if (calculatedBmi < 25) return BMIStatus.normal;
    if (calculatedBmi < 30) return BMIStatus.overweight;
    return BMIStatus.obese;
  }
}

/// Model untuk data User dari API
@JsonSerializable()
class UserDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Mail')
  final String? mail;

  @JsonKey(name: 'Nrk')
  final String? nrk;

  @JsonKey(name: 'PhoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'PersonnelNo')
  final String? personnelNo;

  @JsonKey(name: 'LastSynchronize')
  final DateTime? lastSynchronize;

  @JsonKey(name: 'Status')
  final String? status;

  UserDataModel({
    required this.id,
    this.username,
    required this.fullname,
    this.mail,
    this.nrk,
    this.phoneNumber,
    this.personnelNo,
    this.lastSynchronize,
    this.status,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}

/// Request model untuk BMI List API
@JsonSerializable()
class BmiListRequestModel {
  @JsonKey(name: 'Filter')
  final List<FilterModel> filter;

  @JsonKey(name: 'Sort')
  final SortModel sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  BmiListRequestModel({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory BmiListRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BmiListRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BmiListRequestModelToJson(this);
}

@JsonSerializable()
class FilterModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Search')
  final String search;

  FilterModel({
    required this.field,
    required this.search,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) =>
      _$FilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterModelToJson(this);
}

@JsonSerializable()
class SortModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Type')
  final int type;

  SortModel({
    required this.field,
    required this.type,
  });

  factory SortModel.fromJson(Map<String, dynamic> json) =>
      _$SortModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortModelToJson(this);
}

/// Response model untuk User List API
@JsonSerializable()
class UserListResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<UserListItemModel> list;

  @JsonKey(name: 'Code')
  final int? code;

  @JsonKey(name: 'Succeeded')
  final bool? succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  UserListResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    this.code,
    this.succeeded,
    this.message,
    this.description,
  });

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListResponseModelToJson(this);
}

/// Model untuk item dalam User List API
@JsonSerializable()
class UserListItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Email')
  final String? email;

  @JsonKey(name: 'PhoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'NoNrp')
  final String? noNrp;

  @JsonKey(name: 'NoKtp')
  final String? noKtp;

  @JsonKey(name: 'TempatLahir')
  final String? tempatLahir;

  @JsonKey(name: 'TanggalLahir')
  final String? tanggalLahir;

  @JsonKey(name: 'JenisKelamin')
  final String? jenisKelamin;

  @JsonKey(name: 'Pendidikan')
  final String? pendidikan;

  @JsonKey(name: 'TeleponPribadi')
  final String? teleponPribadi;

  @JsonKey(name: 'TeleponDarurat')
  final String? teleponDarurat;

  @JsonKey(name: 'Site')
  final String? site;

  @JsonKey(name: 'Jabatan')
  final String? jabatan;

  @JsonKey(name: 'IdAtasan')
  final String? idAtasan;

  @JsonKey(name: 'TanggalPenerimaan')
  final String? tanggalPenerimaan;

  @JsonKey(name: 'MasaBerlakuPermit')
  final String? masaBerlakuPermit;

  @JsonKey(name: 'KompetensiPekerjaan')
  final String? kompetensiPekerjaan;

  @JsonKey(name: 'UrlKtp')
  final String? urlKtp;

  @JsonKey(name: 'UrlKta')
  final String? urlKta;

  @JsonKey(name: 'UrlFoto')
  final String? urlFoto;

  @JsonKey(name: 'P3tdK3lh')
  final String? p3tdK3lh;

  @JsonKey(name: 'P3tdSecurity')
  final String? p3tdSecurity;

  @JsonKey(name: 'UrlPernyataanTidakMerokok')
  final String? urlPernyataanTidakMerokok;

  @JsonKey(name: 'WargaNegara')
  final String? wargaNegara;

  @JsonKey(name: 'Provinsi')
  final String? provinsi;

  @JsonKey(name: 'KotaKabupaten')
  final String? kotaKabupaten;

  @JsonKey(name: 'Kecamatan')
  final String? kecamatan;

  @JsonKey(name: 'Kelurahan')
  final String? kelurahan;

  @JsonKey(name: 'AlamatDomisili')
  final String? alamatDomisili;

  @JsonKey(name: 'Feedback')
  final String? feedback;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'Token')
  final String? token;

  @JsonKey(name: 'IsLockout')
  final bool? isLockout;

  @JsonKey(name: 'AccessFailedCount')
  final int? accessFailedCount;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'Nrk')
  final String? nrk;

  @JsonKey(name: 'PersonnelNo')
  final String? personnelNo;

  UserListItemModel({
    required this.id,
    this.username,
    required this.fullname,
    this.email,
    this.phoneNumber,
    this.noNrp,
    this.noKtp,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.pendidikan,
    this.teleponPribadi,
    this.teleponDarurat,
    this.site,
    this.jabatan,
    this.idAtasan,
    this.tanggalPenerimaan,
    this.masaBerlakuPermit,
    this.kompetensiPekerjaan,
    this.urlKtp,
    this.urlKta,
    this.urlFoto,
    this.p3tdK3lh,
    this.p3tdSecurity,
    this.urlPernyataanTidakMerokok,
    this.wargaNegara,
    this.provinsi,
    this.kotaKabupaten,
    this.kecamatan,
    this.kelurahan,
    this.alamatDomisili,
    this.feedback,
    this.status,
    this.token,
    this.isLockout,
    this.accessFailedCount,
    this.active,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
    this.nrk,
    this.personnelNo,
  });

  factory UserListItemModel.fromJson(Map<String, dynamic> json) =>
      _$UserListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListItemModelToJson(this);
}

/// Request model untuk User List API (reuse existing FilterModel and SortModel)
@JsonSerializable()
class UserListRequestModel {
  @JsonKey(name: 'Filter')
  final List<FilterModel> filter;

  @JsonKey(name: 'Sort')
  final SortModel sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  UserListRequestModel({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory UserListRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UserListRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListRequestModelToJson(this);
}
