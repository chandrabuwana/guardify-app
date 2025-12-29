import 'company_rule_category_model.dart';
import '../../domain/entities/document_entity.dart';

class CompanyRuleFileModel {
  final String filename;
  final String url;

  const CompanyRuleFileModel({
    required this.filename,
    required this.url,
  });

  factory CompanyRuleFileModel.fromJson(Map<String, dynamic> json) {
    return CompanyRuleFileModel(
      filename: json['Filename'] as String,
      url: json['Url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Filename': filename,
      'Url': url,
    };
  }
}

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
  final CompanyRuleFileModel? files;

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
    this.files,
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
      files: json['Files'] != null
          ? CompanyRuleFileModel.fromJson(
              json['Files'] as Map<String, dynamic>)
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
      'Files': files?.toJson(),
    };
  }

  // Convert to domain entity
  DocumentEntity toEntity() {
    // Prioritize Files.Url if available, otherwise use repository file ID
    String fileUrl = '';
    String? fileType;
    
    if (files != null && files!.url.isNotEmpty) {
      // Use Files.Url from API response
      fileUrl = files!.url;
      fileType = _getFileType(files!.filename);
    } else if (idRepositoryFile != null &&
        idRepositoryFile != '00000000-0000-0000-0000-000000000000' &&
        idRepositoryFile!.isNotEmpty) {
      // Fallback to repository file ID
      fileUrl = '/api/v1/RepositoryFile/download/$idRepositoryFile';
      fileType = _getFileType(fileName);
    }

    return DocumentEntity(
      id: id,
      title: name,
      category: companyRuleCategory?.name ?? 'Lainnya',
      date: createDate,
      fileUrl: fileUrl,
      description: description,
      fileType: fileType,
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
