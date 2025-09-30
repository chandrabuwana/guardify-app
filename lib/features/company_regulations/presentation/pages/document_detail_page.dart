import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';
import '../widgets/custom_app_bar.dart';
import '../../domain/entities/document_entity.dart';

/// Halaman detail dokumen dengan viewer scrollable
///
/// Halaman ini menampilkan:
/// - AppBar dengan judul dokumen dan tombol download
/// - Informasi detail dokumen (metadata)
/// - Viewer dokumen yang scrollable (PDF/gambar)
/// - Status download dan path file lokal
class DocumentDetailPage extends StatefulWidget {
  const DocumentDetailPage({
    Key? key,
    this.document,
    this.documentId,
  }) : super(key: key);

  /// Entity dokumen yang akan ditampilkan (jika sudah ada)
  final DocumentEntity? document;

  /// ID dokumen untuk load dari server (jika belum ada entity)
  final String? documentId;

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  final ScrollController _scrollController = ScrollController();
  late DocumentEntity _currentDocument;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();

    if (widget.document != null) {
      _currentDocument = widget.document!;
    } else if (widget.documentId != null) {
      // Load document detail dari server
      context
          .read<DocumentBloc>()
          .add(LoadDocumentDetailEvent(widget.documentId!));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: _buildAppBar(),
      child: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          // Handle side effects
          if (state is DocumentSnackbarShow) {
            _showSnackbar(state.message, isError: state.isError);
          }

          if (state is DocumentDownloadLoading) {
            if (state.documentId == _currentDocument.id) {
              setState(() {
                _isDownloading = true;
              });
            }
          }

          if (state is DocumentDownloadSuccess) {
            if (state.documentId == _currentDocument.id) {
              setState(() {
                _isDownloading = false;
                _currentDocument = _currentDocument.copyWith(
                  isDownloaded: true,
                  downloadPath: state.downloadPath,
                );
              });
              _showSnackbar('Dokumen berhasil diunduh');
            }
          }

          if (state is DocumentDownloadError) {
            if (state.documentId == _currentDocument.id) {
              setState(() {
                _isDownloading = false;
              });
              _showSnackbar(state.message, isError: true);
            }
          }

          if (state is DocumentDetailLoaded) {
            setState(() {
              _currentDocument = state.document;
            });
          }
        },
        builder: (context, state) {
          if (widget.document == null && state is DocumentDetailLoading) {
            return _buildLoadingContent();
          }

          if (widget.document == null && state is DocumentDetailError) {
            return _buildErrorContent(state.message);
          }

          return _buildDocumentContent();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: widget.document?.title ?? _currentDocument.title,
      actions: [
        IconButton(
          icon: _isDownloading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  _currentDocument.isDownloaded
                      ? Icons.download_done
                      : Icons.download,
                  color: _currentDocument.isDownloaded
                      ? Colors.white
                      : Colors.white,
                ),
          onPressed: _isDownloading ? null : _downloadDocument,
          tooltip: _currentDocument.isDownloaded ? 'Tersimpan' : 'Download',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareDocument,
          tooltip: 'Bagikan',
        ),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          16.verticalSpace,
          Text(
            'Memuat detail dokumen...',
            style: TS.bodyMedium.copyWith(color: neutral70),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String message) {
    return Center(
      child: Padding(
        padding: REdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: errorColor,
            ),
            16.verticalSpace,
            Text(
              'Gagal Memuat Detail',
              style: TS.titleMedium.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.verticalSpace,
            Text(
              message,
              style: TS.bodyMedium.copyWith(color: neutral70),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () {
                if (widget.documentId != null) {
                  context.read<DocumentBloc>().add(
                        LoadDocumentDetailEvent(widget.documentId!),
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: REdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document Info Card
          _buildDocumentInfoCard(),

          16.verticalSpace,

          // Document Viewer/Preview
          _buildDocumentViewer(),

          16.verticalSpace,

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDocumentInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              _currentDocument.title,
              style: TS.titleLarge.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
              ),
            ),

            8.verticalSpace,

            // Category and Date
            Row(
              children: [
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    _currentDocument.category,
                    style: TS.caption.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _currentDocument.formattedDate,
                  style: TS.bodySmall.copyWith(color: neutral50),
                ),
              ],
            ),

            if (_currentDocument.description != null) ...[
              16.verticalSpace,
              Text(
                'Deskripsi',
                style: TS.titleSmall.copyWith(
                  color: neutral90,
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.verticalSpace,
              Text(
                _currentDocument.description!,
                style: TS.bodyMedium.copyWith(color: neutral70),
              ),
            ],

            16.verticalSpace,

            // Metadata
            _buildMetadataRow('Versi', _currentDocument.version ?? '-'),
            if (_currentDocument.author != null)
              _buildMetadataRow('Penulis', _currentDocument.author!),
            if (_currentDocument.fileSize != null)
              _buildMetadataRow(
                  'Ukuran File', _currentDocument.formattedFileSize),
            if (_currentDocument.fileType != null)
              _buildMetadataRow('Tipe File', _currentDocument.fileType!),

            // Download Status
            if (_currentDocument.isDownloaded) ...[
              8.verticalSpace,
              Container(
                padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: successColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.download_done,
                      size: 16.w,
                      color: successColor,
                    ),
                    6.horizontalSpace,
                    Text(
                      'Dokumen tersimpan',
                      style: TS.caption.copyWith(
                        color: successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: REdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TS.bodySmall.copyWith(
                color: neutral50,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ': ',
            style: TS.bodySmall.copyWith(color: neutral50),
          ),
          Expanded(
            child: Text(
              value,
              style: TS.bodySmall.copyWith(color: neutral90),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentViewer() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        height: 400.h, // Fixed height untuk viewer
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getFileIcon(_currentDocument.fileType),
              size: 64.w,
              color: primaryColor,
            ),
            16.verticalSpace,
            Text(
              'Preview Dokumen',
              style: TS.titleMedium.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.verticalSpace,
            Text(
              _getViewerText(),
              style: TS.bodyMedium.copyWith(color: neutral70),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton.icon(
              onPressed: _openDocument,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Buka Dokumen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _markAsRead,
            icon: const Icon(Icons.visibility),
            label: const Text('Tandai Dibaca'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor),
            ),
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isDownloading ? null : _downloadDocument,
            icon: _isDownloading
                ? SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_currentDocument.isDownloaded
                    ? Icons.download_done
                    : Icons.download),
            label:
                Text(_currentDocument.isDownloaded ? 'Tersimpan' : 'Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon(String? fileType) {
    if (fileType == null) return Icons.description;

    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.description;
    }
  }

  String _getViewerText() {
    if (_currentDocument.isDownloaded) {
      return 'Dokumen tersimpan di perangkat Anda.\nKetuk "Buka Dokumen" untuk melihat.';
    }
    return 'Preview dokumen akan tersedia setelah diunduh.\nKetuk tombol download untuk menyimpan dokumen.';
  }

  void _downloadDocument() {
    context.read<DocumentBloc>().add(DownloadDocumentEvent(_currentDocument));
  }

  void _shareDocument() {
    // TODO: Implement share functionality
    _showSnackbar('Fitur berbagi akan segera tersedia');
  }

  void _openDocument() {
    if (_currentDocument.isDownloaded &&
        _currentDocument.downloadPath != null) {
      // TODO: Open document with system app
      _showSnackbar('Membuka dokumen: ${_currentDocument.downloadPath}');
    } else {
      _downloadDocument();
    }
  }

  void _markAsRead() {
    context
        .read<DocumentBloc>()
        .add(MarkDocumentAsReadEvent(_currentDocument.id));
    _showSnackbar('Dokumen telah ditandai sebagai dibaca');
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? errorColor : successColor,
        behavior: SnackBarBehavior.floating,
        margin: REdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
