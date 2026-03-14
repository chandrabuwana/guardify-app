import 'company_rule_category_model.dart';

class CompanyRuleCategoryListResponse {
  final int count;
  final int filtered;
  final List<CompanyRuleCategoryModel> list;
  final int code;
  final bool succeeded;
  final String message;
  final String description;

  const CompanyRuleCategoryListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory CompanyRuleCategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CompanyRuleCategoryListResponse(
      count: (json['Count'] as num?)?.toInt() ?? 0,
      filtered: (json['Filtered'] as num?)?.toInt() ?? 0,
      list: (json['List'] as List<dynamic>? ?? const <dynamic>[])
          .map((item) =>
              CompanyRuleCategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      code: (json['Code'] as num?)?.toInt() ?? 0,
      succeeded: json['Succeeded'] == true,
      message: (json['Message'] ?? '').toString(),
      description: (json['Description'] ?? '').toString(),
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
