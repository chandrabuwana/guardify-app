class NewsCategoryModel {
  final int id;
  final bool active;
  final String createBy;
  final DateTime createDate;
  final String description;
  final String name;
  final String? updateBy;
  final DateTime? updateDate;

  const NewsCategoryModel({
    required this.id,
    required this.active,
    required this.createBy,
    required this.createDate,
    required this.description,
    required this.name,
    this.updateBy,
    this.updateDate,
  });

  factory NewsCategoryModel.fromJson(Map<String, dynamic> json) {
    return NewsCategoryModel(
      id: json['Id'] as int,
      active: json['Active'] as bool,
      createBy: json['CreateBy'] as String,
      createDate: DateTime.parse(json['CreateDate'] as String),
      description: json['Description'] as String,
      name: json['Name'] as String,
      updateBy: json['UpdateBy'] as String?,
      updateDate: json['UpdateDate'] != null
          ? DateTime.parse(json['UpdateDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Active': active,
      'CreateBy': createBy,
      'CreateDate': createDate.toIso8601String(),
      'Description': description,
      'Name': name,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate?.toIso8601String(),
    };
  }
}
