import 'package:equatable/equatable.dart';
import '../../domain/entities/document_entity.dart';

/// Abstract base class untuk semua document events
abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

/// Event untuk load semua dokumen saat pertama kali masuk halaman
class LoadDocumentsEvent extends DocumentEvent {
  const LoadDocumentsEvent();
}

/// Event untuk reload/refresh dokumen
class RefreshDocumentsEvent extends DocumentEvent {
  const RefreshDocumentsEvent();
}

/// Event untuk mencari dokumen berdasarkan keyword
class SearchDocumentsEvent extends DocumentEvent {
  final String query;

  const SearchDocumentsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event untuk clear/reset pencarian
class ClearSearchEvent extends DocumentEvent {
  const ClearSearchEvent();
}

/// Event untuk filter dokumen berdasarkan kategori
class FilterDocumentsByCategoryEvent extends DocumentEvent {
  final String category;

  const FilterDocumentsByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event untuk filter dokumen berdasarkan rentang tanggal
class FilterDocumentsByDateEvent extends DocumentEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FilterDocumentsByDateEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event untuk clear/reset filter
class ClearFilterEvent extends DocumentEvent {
  const ClearFilterEvent();
}

/// Event untuk download dokumen
class DownloadDocumentEvent extends DocumentEvent {
  final DocumentEntity document;

  const DownloadDocumentEvent(this.document);

  @override
  List<Object?> get props => [document];
}

/// Event untuk load detail dokumen berdasarkan ID
class LoadDocumentDetailEvent extends DocumentEvent {
  final String documentId;

  const LoadDocumentDetailEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Event untuk load kategori dokumen
class LoadDocumentCategoriesEvent extends DocumentEvent {
  const LoadDocumentCategoriesEvent();
}

/// Event untuk mark dokumen sebagai sudah dibaca
class MarkDocumentAsReadEvent extends DocumentEvent {
  final String documentId;

  const MarkDocumentAsReadEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Event untuk load dokumen yang sudah didownload
class LoadDownloadedDocumentsEvent extends DocumentEvent {
  const LoadDownloadedDocumentsEvent();
}

/// Event untuk show snackbar message
class ShowSnackbarEvent extends DocumentEvent {
  final String message;
  final bool isError;

  const ShowSnackbarEvent({
    required this.message,
    this.isError = false,
  });

  @override
  List<Object?> get props => [message, isError];
}
