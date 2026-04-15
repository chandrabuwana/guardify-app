class CurrentLocationResponseModel {
  final int count;
  final int filtered;
  final List<EmployeeLocationModel> list;
  final int code;
  final bool succeeded;
  final String message;
  final String description;

  const CurrentLocationResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory CurrentLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return CurrentLocationResponseModel(
      count: json['Count'] as int? ?? 0,
      filtered: json['Filtered'] as int? ?? 0,
      list: (json['List'] as List<dynamic>?)
              ?.map((item) => EmployeeLocationModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      code: json['Code'] as int? ?? 0,
      succeeded: json['Succeeded'] as bool? ?? false,
      message: json['Message'] as String? ?? '',
      description: json['Description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Count': count,
      'Filtered': filtered,
      'List': list.map((item) => item.toJson()).toList(),
      'Code': code,
      'Succeeded': succeeded,
      'Message': message,
      'Description': description,
    };
  }
}

class EmployeeLocationModel {
  final String idAreas;
  final AreaModel? areas;
  final String idUser;
  final UserModel? user;
  final double latitude;
  final double longitude;
  final String createDate;
  final String updateDate;

  const EmployeeLocationModel({
    required this.idAreas,
    this.areas,
    required this.idUser,
    this.user,
    required this.latitude,
    required this.longitude,
    required this.createDate,
    required this.updateDate,
  });

  factory EmployeeLocationModel.fromJson(Map<String, dynamic> json) {
    return EmployeeLocationModel(
      idAreas: json['IdAreas'] as String? ?? '',
      areas: json['Areas'] != null
          ? AreaModel.fromJson(json['Areas'] as Map<String, dynamic>)
          : null,
      idUser: json['IdUser'] as String? ?? '',
      user: json['User'] != null
          ? UserModel.fromJson(json['User'] as Map<String, dynamic>)
          : null,
      latitude: (json['Latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['Longitude'] as num?)?.toDouble() ?? 0.0,
      createDate: json['CreateDate'] as String? ?? '',
      updateDate: json['UpdateDate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdAreas': idAreas,
      'Areas': areas?.toJson(),
      'IdUser': idUser,
      'User': user?.toJson(),
      'Latitude': latitude,
      'Longitude': longitude,
      'CreateDate': createDate,
      'UpdateDate': updateDate,
    };
  }
}

class AreaModel {
  final String id;
  final bool active;
  final String? createBy;
  final String createDate;
  final int idSite;
  final double latitude;
  final double longitude;
  final String name;
  final double radius;
  final String? typeArea;
  final String? updateBy;
  final String updateDate;

  const AreaModel({
    required this.id,
    required this.active,
    this.createBy,
    required this.createDate,
    required this.idSite,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.radius,
    this.typeArea,
    this.updateBy,
    required this.updateDate,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['Id'] as String? ?? '',
      active: json['Active'] as bool? ?? false,
      createBy: json['CreateBy'] as String?,
      createDate: json['CreateDate'] as String? ?? '',
      idSite: json['IdSite'] as int? ?? 0,
      latitude: (json['Latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['Longitude'] as num?)?.toDouble() ?? 0.0,
      name: json['Name'] as String? ?? '',
      radius: (json['Radius'] as num?)?.toDouble() ?? 0.0,
      typeArea: json['TypeArea'] as String?,
      updateBy: json['UpdateBy'] as String?,
      updateDate: json['UpdateDate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Active': active,
      'CreateBy': createBy,
      'CreateDate': createDate,
      'IdSite': idSite,
      'Latitude': latitude,
      'Longitude': longitude,
      'Name': name,
      'Radius': radius,
      'TypeArea': typeArea,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate,
    };
  }
}

class UserModel {
  final String fullname;
  final String noNrp;
  final String jabatan;

  const UserModel({
    required this.fullname,
    required this.noNrp,
    required this.jabatan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullname: json['Fullname'] as String? ?? '',
      noNrp: json['NoNrp'] as String? ?? '',
      jabatan: json['Jabatan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Fullname': fullname,
      'NoNrp': noNrp,
      'Jabatan': jabatan,
    };
  }
}

