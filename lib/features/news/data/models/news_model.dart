import '../../domain/entities/news.dart';
import 'news_category_model.dart';

class NewsModel {
  final String id;
  final String code;
  final String content;
  final String createBy;
  final DateTime createDate;
  final int idCategory;
  final NewsCategoryModel? category;
  final String source;
  final String title;
  final String? updateBy;
  final DateTime? updateDate;
  final NewsFileModel? files;

  const NewsModel({
    required this.id,
    required this.code,
    required this.content,
    required this.createBy,
    required this.createDate,
    required this.idCategory,
    this.category,
    required this.source,
    required this.title,
    this.updateBy,
    this.updateDate,
    this.files,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['Id'] as String,
      code: json['Code'] as String,
      content: json['Content'] as String,
      createBy: json['CreateBy'] as String,
      createDate: DateTime.parse(json['CreateDate'] as String),
      idCategory: json['IdCategory'] as int,
      category: json['Category'] != null
          ? NewsCategoryModel.fromJson(json['Category'] as Map<String, dynamic>)
          : null,
      source: json['Source'] as String,
      title: json['Title'] as String,
      updateBy: json['UpdateBy'] as String?,
      updateDate: json['UpdateDate'] != null
          ? DateTime.parse(json['UpdateDate'] as String)
          : null,
      files: json['Files'] != null
          ? NewsFileModel.fromJson(json['Files'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Code': code,
      'Content': content,
      'CreateBy': createBy,
      'CreateDate': createDate.toIso8601String(),
      'IdCategory': idCategory,
      'Category': category?.toJson(),
      'Source': source,
      'Title': title,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate?.toIso8601String(),
      'Files': files?.toJson(),
    };
  }

  // Convert to domain entity
  News toEntity() {
    return News(
      id: id,
      title: title,
      content: content,
      category: category?.name ?? 'Lainnya',
      source: source,
      imageUrl: files?.url,
      publishedAt: createDate,
      createdAt: createDate,
      updatedAt: updateDate ?? createDate,
    );
  }

  // Create from domain entity
  factory NewsModel.fromEntity(News news) {
    return NewsModel(
      id: news.id,
      code: news.id,
      content: news.content,
      createBy: 'User',
      createDate: news.createdAt,
      idCategory: 1, // Default category
      source: news.source,
      title: news.title,
      updateBy: null,
      updateDate: news.updatedAt,
      files: null,
    );
  }
}

class NewsFileModel {
  final String filename;
  final String url;

  const NewsFileModel({
    required this.filename,
    required this.url,
  });

  factory NewsFileModel.fromJson(Map<String, dynamic> json) {
    return NewsFileModel(
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
