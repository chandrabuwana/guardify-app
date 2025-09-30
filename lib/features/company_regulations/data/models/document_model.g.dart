// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DocumentModel',
      json,
      ($checkedConvert) {
        final val = DocumentModel(
          id: $checkedConvert('id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          category: $checkedConvert('category', (v) => v as String),
          date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
          fileUrl: $checkedConvert('file_url', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String?),
          fileSize: $checkedConvert('file_size', (v) => (v as num?)?.toInt()),
          fileType: $checkedConvert('file_type', (v) => v as String?),
          version: $checkedConvert('version', (v) => v as String?),
          author: $checkedConvert('author', (v) => v as String?),
          isDownloaded:
              $checkedConvert('is_downloaded', (v) => v as bool? ?? false),
          downloadPath: $checkedConvert('download_path', (v) => v as String?),
          tags: $checkedConvert(
              'tags',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const []),
        );
        return val;
      },
      fieldKeyMap: const {
        'fileUrl': 'file_url',
        'fileSize': 'file_size',
        'fileType': 'file_type',
        'isDownloaded': 'is_downloaded',
        'downloadPath': 'download_path'
      },
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'date': instance.date.toIso8601String(),
      'file_url': instance.fileUrl,
      'description': instance.description,
      'file_size': instance.fileSize,
      'file_type': instance.fileType,
      'version': instance.version,
      'author': instance.author,
      'is_downloaded': instance.isDownloaded,
      'download_path': instance.downloadPath,
      'tags': instance.tags,
    };
