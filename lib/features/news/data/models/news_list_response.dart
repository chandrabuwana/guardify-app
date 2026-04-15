import 'news_model.dart';

class NewsListResponse {
  final int count;
  final int filtered;
  final List<NewsModel> list;
  final int code;
  final bool succeeded;
  final String message;
  final String description;

  const NewsListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory NewsListResponse.fromJson(Map<String, dynamic> json) {
    return NewsListResponse(
      count: json['Count'] as int,
      filtered: json['Filtered'] as int,
      list: (json['List'] as List<dynamic>)
          .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
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
