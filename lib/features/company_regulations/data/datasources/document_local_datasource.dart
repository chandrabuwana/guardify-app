import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document_model.dart';

/// Abstract class untuk local data source dokumen
abstract class DocumentLocalDataSource {
  Future<List<DocumentModel>> getCachedDocuments();
  Future<void> cacheDocuments(List<DocumentModel> documents);
  Future<List<DocumentModel>> getDownloadedDocuments();
  Future<void> saveDownloadedDocument(DocumentModel document);
  Future<DocumentModel?> getCachedDocumentById(String documentId);
  Future<void> clearCache();
  Future<List<String>> getCachedCategories();
  Future<void> cacheCategories(List<String> categories);
  Future<void> createDummyData();
}

/// Implementasi local data source menggunakan SharedPreferences
@LazySingleton(as: DocumentLocalDataSource)
class DocumentLocalDataSourceImpl implements DocumentLocalDataSource {
  final SharedPreferences sharedPreferences;

  DocumentLocalDataSourceImpl({required this.sharedPreferences});

  static const String _documentsKey = 'cached_documents';
  static const String _downloadedDocumentsKey = 'downloaded_documents';
  static const String _categoriesKey = 'cached_categories';

  @override
  Future<List<DocumentModel>> getCachedDocuments() async {
    try {
      final jsonString = sharedPreferences.getString(_documentsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => DocumentModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get cached documents: $e');
    }
  }

  @override
  Future<void> cacheDocuments(List<DocumentModel> documents) async {
    try {
      final jsonList = documents.map((doc) => doc.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(_documentsKey, jsonString);
    } catch (e) {
      throw Exception('Failed to cache documents: $e');
    }
  }

  @override
  Future<List<DocumentModel>> getDownloadedDocuments() async {
    try {
      final jsonString = sharedPreferences.getString(_downloadedDocumentsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => DocumentModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get downloaded documents: $e');
    }
  }

  @override
  Future<void> saveDownloadedDocument(DocumentModel document) async {
    try {
      final downloadedDocs = await getDownloadedDocuments();

      // Cek apakah dokumen sudah ada dalam list
      final existingIndex =
          downloadedDocs.indexWhere((doc) => doc.id == document.id);

      if (existingIndex != -1) {
        // Update dokumen yang sudah ada
        downloadedDocs[existingIndex] = document;
      } else {
        // Tambah dokumen baru
        downloadedDocs.add(document);
      }

      final jsonList = downloadedDocs.map((doc) => doc.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(_downloadedDocumentsKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save downloaded document: $e');
    }
  }

  @override
  Future<DocumentModel?> getCachedDocumentById(String documentId) async {
    try {
      final cachedDocs = await getCachedDocuments();
      return cachedDocs.where((doc) => doc.id == documentId).firstOrNull;
    } catch (e) {
      throw Exception('Failed to get cached document by ID: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_documentsKey);
      await sharedPreferences.remove(_categoriesKey);
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  @override
  Future<List<String>> getCachedCategories() async {
    try {
      final jsonString = sharedPreferences.getString(_categoriesKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((category) => category.toString()).toList();
    } catch (e) {
      throw Exception('Failed to get cached categories: $e');
    }
  }

  @override
  Future<void> cacheCategories(List<String> categories) async {
    try {
      final jsonString = json.encode(categories);
      await sharedPreferences.setString(_categoriesKey, jsonString);
    } catch (e) {
      throw Exception('Failed to cache categories: $e');
    }
  }

  /// Helper method untuk membuat dummy data untuk development/testing
  @override
  Future<void> createDummyData() async {
    final dummyDocuments = [
      DocumentModel.dummy(
        id: '1',
        title: 'SOP Patroli',
        category: 'SOP',
        date: DateTime(2025, 10, 29),
      ),
      DocumentModel.dummy(
        id: '2',
        title: 'SOP Keamanan Gedung',
        category: 'SOP',
        date: DateTime(2025, 10, 28),
      ),
      DocumentModel.dummy(
        id: '3',
        title: 'Kebijakan Keselamatan Kerja',
        category: 'Kebijakan',
        date: DateTime(2025, 10, 27),
      ),
      DocumentModel.dummy(
        id: '4',
        title: 'Prosedur Darurat',
        category: 'Prosedur',
        date: DateTime(2025, 10, 26),
      ),
      DocumentModel.dummy(
        id: '5',
        title: 'SOP Laporan Harian',
        category: 'SOP',
        date: DateTime(2025, 10, 25),
      ),
    ];

    await cacheDocuments(dummyDocuments);
    await cacheCategories(['SOP', 'Kebijakan', 'Prosedur', 'Panduan']);
  }
}
