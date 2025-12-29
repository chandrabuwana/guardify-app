import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/custom_filter_button.dart';
import '../widgets/custom_document_card.dart';
import '../../domain/entities/document_entity.dart';
import 'document_preview_page.dart';

/// Halaman utama untuk menampilkan daftar peraturan perusahaan
///
/// Halaman ini menampilkan:
/// - AppBar dengan judul dan tombol download
/// - Search bar untuk pencarian dokumen
/// - Filter button untuk memfilter dokumen
/// - List dokumen yang dapat di-scroll
/// - Loading state dan error handling
class CompanyRegulationsPage extends StatefulWidget {
  const CompanyRegulationsPage({Key? key}) : super(key: key);

  @override
  State<CompanyRegulationsPage> createState() => _CompanyRegulationsPageState();
}

class _CompanyRegulationsPageState extends State<CompanyRegulationsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load documents saat pertama kali membuka halaman
    context.read<DocumentBloc>().add(const LoadDocumentsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Peraturan Perusahaan',
        actions: [
          // Tombol download (bisa untuk download semua atau navigasi ke downloaded)
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download all atau navigasi ke downloaded documents
              _showDownloadDialog();
            },
            tooltip: 'Download',
          ),
        ],
      ),
      body: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          // Handle side effects seperti snackbar, navigation, dll
          if (state is DocumentSnackbarShow) {
            _showSnackbar(state.message, isError: state.isError);
          }

          if (state is DocumentDownloadSuccess) {
            _showSnackbar('Dokumen berhasil diunduh: ${state.downloadPath}');
          }

          if (state is DocumentDownloadError) {
            _showSnackbar(state.message, isError: true);
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DocumentBloc>().add(const RefreshDocumentsEvent());
            },
            color: primaryColor,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Search Bar Section
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.grey[50],
                    child: Column(
                      children: [
                        // Search Bar
                        CustomSearchBar(
                          placeholder: 'Cari',
                          controller: _searchController,
                          onChanged: (query) {
                            if (query.trim().isEmpty) {
                              context
                                  .read<DocumentBloc>()
                                  .add(const ClearSearchEvent());
                            } else {
                              context
                                  .read<DocumentBloc>()
                                  .add(SearchDocumentsEvent(query));
                            }
                          },
                          enabled: state is! DocumentLoading,
                        ),

                        SizedBox(height: 12),

                        // Filter Button Row
                        Row(
                          children: [
                            CustomFilterButton(
                              onPressed: state is! DocumentLoading
                                  ? _showFilterDialog
                                  : null,
                              text: 'Filter',
                              icon: Icons.tune,
                              isActive:
                                  state is DocumentLoaded && state.isFilterMode,
                              activeCount: _getActiveFilterCount(state),
                            ),
                            const Spacer(),
                            // Sort button (opsional)
                            if (state is DocumentLoaded &&
                                state.filteredDocuments.isNotEmpty)
                              TextButton.icon(
                                onPressed: _showSortDialog,
                                icon: Icon(
                                  Icons.sort,
                                  size: 16,
                                  color: primaryColor,
                                ),
                                label: Text(
                                  'Urutkan',
                                  style: TS.labelSmall.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Active Filters Section
                if (state is DocumentLoaded &&
                    (state.isFilterMode || state.isSearchMode))
                  SliverToBoxAdapter(
                    child: CustomFilterChipGroup(
                      categoryFilter: state.currentCategoryFilter,
                      dateRangeFilter: _getDateRangeText(state),
                      onClearCategory: () {
                        context
                            .read<DocumentBloc>()
                            .add(const ClearFilterEvent());
                      },
                      onClearDateRange: () {
                        context
                            .read<DocumentBloc>()
                            .add(const ClearFilterEvent());
                      },
                      onClearAll: () {
                        _searchController.clear();
                        context
                            .read<DocumentBloc>()
                            .add(const ClearSearchEvent());
                        context
                            .read<DocumentBloc>()
                            .add(const ClearFilterEvent());
                      },
                    ),
                  ),

                // Content Section
                _buildContent(state),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build content berdasarkan state
  Widget _buildContent(DocumentState state) {
    if (state is DocumentLoading) {
      return _buildLoadingContent();
    }

    if (state is DocumentError) {
      return _buildErrorContent(state.message);
    }

    if (state is DocumentLoaded) {
      if (state.filteredDocuments.isEmpty) {
        return _buildEmptyContent(state);
      }
      return _buildDocumentList(state.filteredDocuments);
    }

    return _buildInitialContent();
  }

  /// Build loading content dengan skeleton
  Widget _buildLoadingContent() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => const CustomDocumentCardSkeleton(),
        childCount: 6,
      ),
    );
  }

  /// Build error content
  Widget _buildErrorContent(String message) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: errorColor,
            ),
            SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: TS.titleMedium.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TS.bodyMedium.copyWith(
                color: neutral70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<DocumentBloc>().add(const LoadDocumentsEvent());
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

  /// Build empty content
  Widget _buildEmptyContent(DocumentLoaded state) {
    final isSearchMode = state.isSearchMode;
    final isFilterMode = state.isFilterMode;

    String title = 'Tidak Ada Dokumen';
    String subtitle = 'Belum ada dokumen yang tersedia.';

    if (isSearchMode) {
      title = 'Tidak Ditemukan';
      subtitle =
          'Tidak ada dokumen yang sesuai dengan pencarian "${state.currentQuery}".';
    } else if (isFilterMode) {
      title = 'Tidak Ada Hasil';
      subtitle = 'Tidak ada dokumen yang sesuai dengan filter yang dipilih.';
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchMode ? Icons.search_off : Icons.folder_open,
              size: 64,
              color: neutral50,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TS.titleMedium.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TS.bodyMedium.copyWith(
                color: neutral70,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearchMode || isFilterMode) ...[
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  context.read<DocumentBloc>().add(const ClearSearchEvent());
                  context.read<DocumentBloc>().add(const ClearFilterEvent());
                },
                child: Text(
                  'Tampilkan Semua Dokumen',
                  style: TS.labelMedium.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build initial content
  Widget _buildInitialContent() {
    return SliverToBoxAdapter(
      child: Container(
        padding: REdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              size: 64.w,
              color: neutral50,
            ),
            16.verticalSpace,
            Text(
              'Memuat Dokumen...',
              style: TS.titleMedium.copyWith(
                color: neutral90,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build document list
  Widget _buildDocumentList(List<DocumentEntity> documents) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final document = documents[index];
          return CustomDocumentCard(
            document: document,
            onTap: () => _navigateToDocumentDetail(document),
            onLongPress: () => _showDocumentOptions(document),
          );
        },
        childCount: documents.length,
      ),
    );
  }

  /// Helper methods
  int _getActiveFilterCount(DocumentState state) {
    if (state is! DocumentLoaded) return 0;

    int count = 0;
    if (state.currentCategoryFilter != null) count++;
    if (state.currentStartDate != null && state.currentEndDate != null) count++;

    return count;
  }

  String? _getDateRangeText(DocumentLoaded state) {
    if (state.currentStartDate == null || state.currentEndDate == null)
      return null;

    final start = state.currentStartDate!;
    final end = state.currentEndDate!;

    return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
  }

  void _navigateToDocumentDetail(DocumentEntity document) {
    // Jika ada file URL, buka preview file
    if (document.fileUrl.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentPreviewPage(
            document: document,
          ),
        ),
      );
    } else {
      // Jika tidak ada file, tampilkan popup validasi
      _showFileNotAvailableDialog(document);
    }
  }

  void _showFileNotAvailableDialog(DocumentEntity document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: primaryColor,
              size: 24.sp,
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(
                'File Tidak Tersedia',
                style: TS.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: neutral90,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'File untuk dokumen "${document.title}" tidak tersedia.',
              style: TS.bodyMedium.copyWith(color: Colors.black),
            ),
            8.verticalSpace,
            Text(
              'Silakan hubungi administrator untuk informasi lebih lanjut.',
              style: TS.bodySmall.copyWith(color: Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Tutup',
              style: TS.labelLarge.copyWith(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentOptions(DocumentEntity document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: REdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                _navigateToDocumentDetail(document);
              },
            ),
            ListTile(
              leading: Icon(
                document.isDownloaded ? Icons.download_done : Icons.download,
                color: document.isDownloaded ? successColor : primaryColor,
              ),
              title:
                  Text(document.isDownloaded ? 'Sudah Tersimpan' : 'Download'),
              onTap: document.isDownloaded
                  ? null
                  : () {
                      Navigator.pop(context);
                      _downloadDocument(document);
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _downloadDocument(DocumentEntity document) {
    context.read<DocumentBloc>().add(DownloadDocumentEvent(document));
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

  void _showFilterDialog() {
    // TODO: Implement filter dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  void _showSortDialog() {
    // TODO: Implement sort dialog
    showDialog(
      context: context,
      builder: (context) => _buildSortDialog(),
    );
  }

  void _showDownloadDialog() {
    // TODO: Implement download all dialog
    showDialog(
      context: context,
      builder: (context) => _buildDownloadDialog(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter Dokumen',
            style: TS.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          16.verticalSpace,
          // TODO: Add filter options (category, date range)
          const Text('Filter options akan ditambahkan di sini'),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Apply filter
                    Navigator.pop(context);
                  },
                  child: const Text('Terapkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortDialog() {
    return AlertDialog(
      title: const Text('Urutkan Dokumen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: Add sort options
          const Text('Sort options akan ditambahkan di sini'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Apply sort
            Navigator.pop(context);
          },
          child: const Text('Terapkan'),
        ),
      ],
    );
  }

  Widget _buildDownloadDialog() {
    return AlertDialog(
      title: const Text('Download Dokumen'),
      content: const Text('Pilih opsi download:'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: Navigate to downloaded documents
          },
          child: const Text('Lihat Tersimpan'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: Download all documents
          },
          child: const Text('Download Semua'),
        ),
      ],
    );
  }
}
