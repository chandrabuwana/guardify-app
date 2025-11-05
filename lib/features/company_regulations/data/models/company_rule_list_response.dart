import 'company_rule_model.dart';

class CompanyRuleListResponse {
  final int count;
  final int filtered;
  final List<CompanyRuleModel> list;
  final int code;
  final bool succeeded;
  final String message;
  final String description;

  const CompanyRuleListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory CompanyRuleListResponse.fromJson(Map<String, dynamic> json) {
    return CompanyRuleListResponse(
      count: json['Count'] as int,
      filtered: json['Filtered'] as int,
      list: (json['List'] as List<dynamic>)
          .map(
              (item) => CompanyRuleModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      code: json['Code'] as int,
      succeeded: json['Succeeded'] as bool,
      message: json['Message'] as String,
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
