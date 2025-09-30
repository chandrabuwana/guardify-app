import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/document_entity.dart';

/// Custom Card untuk menampilkan item dokumen dengan design yang konsisten
///
/// Card ini menyediakan layout standar untuk item dokumen dengan:
/// - Icon folder di kiri dengan warna merah
/// - Konten utama di tengah (title dan subtitle)
/// - Ripple effect saat ditekan
/// - Shadow yang halus
/// - Rounded corners
class CustomDocumentCard extends StatelessWidget {
  const CustomDocumentCard({
    Key? key,
    required this.document,
    this.onTap,
    this.onLongPress,
    this.elevation = 2,
    this.margin,
    this.borderRadius,
  }) : super(key: key);

  /// Entity dokumen yang akan ditampilkan
  final DocumentEntity document;

  /// Callback ketika card ditekan
  final VoidCallback? onTap;

  /// Callback ketika card ditekan lama
  final VoidCallback? onLongPress;

  /// Elevation shadow card
  final double elevation;

  /// Margin di sekitar card
  final EdgeInsets? margin;

  /// Border radius card
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: elevation,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          splashColor: primaryColor.withOpacity(0.1),
          highlightColor: primaryColor.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon folder di kiri
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.folder,
                    color: primaryColor,
                    size: 24,
                  ),
                ),

                SizedBox(width: 16),

                // Konten utama
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title dokumen
                      Text(
                        document.title,
                        style: TS.titleSmall.copyWith(
                          color: neutral90,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      4.verticalSpace,

                      // Subtitle (kategori | tanggal)
                      Text(
                        document.subtitle,
                        style: TS.bodySmall.copyWith(
                          color: neutral50,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Optional: Tampilkan status download jika ada
                      if (document.isDownloaded) ...[
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.download_done,
                              size: 14,
                              color: successColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Tersimpan',
                              style: TS.caption.copyWith(
                                color: successColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Optional: Action button di kanan
                if (onLongPress != null) ...[
                  SizedBox(width: 8),
                  Icon(
                    Icons.more_vert,
                    color: neutral50,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Card untuk skeleton loading
class CustomDocumentCardSkeleton extends StatelessWidget {
  const CustomDocumentCardSkeleton({
    Key? key,
    this.margin,
  }) : super(key: key);

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Skeleton icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: neutral30,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              SizedBox(width: 16),

              // Skeleton content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skeleton title
                    Container(
                      height: 16.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: neutral30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    SizedBox(height: 8),

                    // Skeleton subtitle
                    Container(
                      height: 12,
                      width: 120,
                      decoration: BoxDecoration(
                        color: neutral30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Factory methods untuk variasi Card yang umum digunakan
extension CustomDocumentCardFactory on CustomDocumentCard {
  /// Card dengan action button download
  static Widget withDownloadAction({
    required DocumentEntity document,
    VoidCallback? onTap,
    VoidCallback? onDownload,
    bool isDownloading = false,
  }) {
    return Container(
      margin: REdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: primaryColor.withOpacity(0.1),
          highlightColor: primaryColor.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon folder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.folder,
                    color: primaryColor,
                    size: 24,
                  ),
                ),

                SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        style: TS.titleSmall.copyWith(
                          color: neutral90,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.verticalSpace,
                      Text(
                        document.subtitle,
                        style: TS.bodySmall.copyWith(
                          color: neutral50,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Download button
                if (onDownload != null) ...[
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: isDownloading ? null : onDownload,
                    icon: isDownloading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                          )
                        : Icon(
                            document.isDownloaded
                                ? Icons.download_done
                                : Icons.download,
                            color: document.isDownloaded
                                ? successColor
                                : primaryColor,
                            size: 24,
                          ),
                    splashRadius: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
