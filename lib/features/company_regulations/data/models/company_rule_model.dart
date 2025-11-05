import 'company_rule_category_model.dart';
import '../../domain/entities/document_entity.dart';

class CompanyRuleModel {
  final String id;
  final bool active;
  final String code;
  final String createBy;
  final DateTime createDate;
  final String description;
  final String? fileName;
  final int idCompanyRuleCategory;
  final CompanyRuleCategoryModel? companyRuleCategory;
  final String? idRepositoryFile;
  final String name;
  final String? updateBy;
  final DateTime? updateDate;

  const CompanyRuleModel({
    required this.id,
    required this.active,
    required this.code,
    required this.createBy,
    required this.createDate,
    required this.description,
    this.fileName,
    required this.idCompanyRuleCategory,
    this.companyRuleCategory,
    this.idRepositoryFile,
    required this.name,
    this.updateBy,
    this.updateDate,
  });

  factory CompanyRuleModel.fromJson(Map<String, dynamic> json) {
    return CompanyRuleModel(
      id: json['Id'] as String,
      active: json['Active'] as bool,
      code: json['Code'] as String,
      createBy: json['CreateBy'] as String,
      createDate: DateTime.parse(json['CreateDate'] as String),
      description: json['Description'] as String,
      fileName: json['FileName'] as String?,
      idCompanyRuleCategory: json['IdCompanyRuleCategory'] as int,
      companyRuleCategory: json['CompanyRuleCategory'] != null
          ? CompanyRuleCategoryModel.fromJson(
              json['CompanyRuleCategory'] as Map<String, dynamic>)
          : null,
      idRepositoryFile: json['IdRepositoryFile'] as String?,
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
      'Code': code,
      'CreateBy': createBy,
      'CreateDate': createDate.toIso8601String(),
      'Description': description,
      'FileName': fileName,
      'IdCompanyRuleCategory': idCompanyRuleCategory,
      'CompanyRuleCategory': companyRuleCategory?.toJson(),
      'IdRepositoryFile': idRepositoryFile,
      'Name': name,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate?.toIso8601String(),
    };
  }

  // Convert to domain entity
  DocumentEntity toEntity() {
    // Build file URL if repository file ID exists
    String fileUrl = '';
    if (idRepositoryFile != null &&
        idRepositoryFile != '00000000-0000-0000-0000-000000000000' &&
        idRepositoryFile!.isNotEmpty) {
      fileUrl = '/api/v1/RepositoryFile/download/$idRepositoryFile';
    }

    return DocumentEntity(
      id: id,
      title: name,
      category: companyRuleCategory?.name ?? 'Lainnya',
      date: createDate,
      fileUrl: fileUrl,
      description: description,
      fileType: _getFileType(fileName),
      version: code,
      author: createBy,
      tags: [companyRuleCategory?.name ?? 'Lainnya'],
    );
  }

  String? _getFileType(String? fileName) {
    if (fileName == null || fileName.isEmpty) return null;
    final parts = fileName.split('.');
    if (parts.length > 1) {
      return parts.last.toUpperCase();
    }
    return null;
  }
}
