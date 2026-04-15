import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import 'package:intl/intl.dart';

class PatrolTimelineWidget extends StatelessWidget {
  final String routeName;
  final List<PatrolCheckpoint> checkpoints;
  final bool isDiperiksa;

  const PatrolTimelineWidget({
    Key? key,
    required this.routeName,
    required this.checkpoints,
    this.isDiperiksa = false,
  }) : super(key: key);

  /// Helper method to build full image URL from relative or absolute URL
  String _buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '';
    }
    
    // If already a full URL, return as is
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    
    // Get base URL
    String baseUrl = AppConstants.baseUrl;
    
    // Check if URL is just a filename (no slashes, but has file extension)
    final hasFileExtension = imageUrl.toLowerCase().contains('.jpg') || 
        imageUrl.toLowerCase().contains('.jpeg') || 
        imageUrl.toLowerCase().contains('.png') || 
        imageUrl.toLowerCase().contains('.gif') || 
        imageUrl.toLowerCase().contains('.webp');
    
    // If URL is just a filename (contains extension but no slashes), 
    // construct URL with file endpoint
    if (!imageUrl.contains('/') && hasFileExtension) {
      // Use /api/v1/file/{filename} endpoint
      return '$baseUrl/file/$imageUrl';
    }
    
    // If relative path, construct full URL using base URL
    // Remove leading slash if present
    final cleanPath = imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl;
    
    // If path doesn't start with api/v1, add it
    if (!cleanPath.startsWith('api/')) {
      return '$baseUrl/$cleanPath';
    }
    
    // If path already has api, use base URL without /api/v1
    String fileBaseUrl = baseUrl;
    if (fileBaseUrl.endsWith('/api/v1')) {
      fileBaseUrl = fileBaseUrl.substring(0, fileBaseUrl.length - 7);
    } else if (fileBaseUrl.endsWith('/api')) {
      fileBaseUrl = fileBaseUrl.substring(0, fileBaseUrl.length - 4);
    }
    
    // Construct full URL
    return '$fileBaseUrl/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy - HH.mm', 'id_ID');
    final timeFormat = DateFormat('HH.mm', 'id_ID');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Route Header
        Row(
          children: [
            Text(
              routeName,
              style: TS.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (!isDiperiksa) ...[
              8.horizontalSpace,
              Container(
                padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Belum Selesai Diperiksa',
                  style: TS.labelSmall.copyWith(
                    color: errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        16.verticalSpace,

        // Timeline
        if (checkpoints.isEmpty)
          Padding(
            padding: REdgeInsets.only(left: 20),
            child: Text(
              'Belum ada checkpoint',
              style: TS.bodySmall.copyWith(color: Colors.grey[600]),
            ),
          )
        else
          ...checkpoints.asMap().entries.map((entry) {
            final index = entry.key;
            final checkpoint = entry.value;
            final isLast = index == checkpoints.length - 1;

            return _buildTimelineItem(
              context: context,
              checkpoint: checkpoint,
              dateFormat: dateFormat,
              timeFormat: timeFormat,
              isLast: isLast,
            );
          }).toList(),
      ],
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required PatrolCheckpoint checkpoint,
    required DateFormat dateFormat,
    required DateFormat timeFormat,
    required bool isLast,
  }) {
    // Determine status: completed if has bukti and is checked, or status is "Selesai"
    final isCompleted = (checkpoint.status == 'Selesai' || 
                        (checkpoint.isDiperiksa && checkpoint.buktiUrl != null));
    final isTambahan = checkpoint.status == 'Tambahan';
    
    // Dot color: blue if completed, red if missing bukti or not checked, grey otherwise
    final dotColor = isCompleted
        ? const Color(0xFF1E88E5)
        : (!checkpoint.isDiperiksa || checkpoint.buktiUrl == null)
            ? errorColor
            : Colors.grey;
    final lineColor = isCompleted
        ? const Color(0xFF1E88E5)
        : Colors.grey[300]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 60.h,
                color: lineColor,
                margin: REdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        12.horizontalSpace,

        // Checkpoint content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkpoint name
              Text(
                checkpoint.name,
                style: TS.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              4.verticalSpace,

              // Timestamp
              if (checkpoint.timestamp != null)
                Text(
                  dateFormat.format(checkpoint.timestamp!),
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                )
              else
                Text(
                  'Tidak ada jam patroli',
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),

              // Proof file
              if (checkpoint.buktiUrl != null) ...[
                4.verticalSpace,
                Builder(
                  builder: (context) {
                    final fullImageUrl = _buildImageUrl(checkpoint.buktiUrl);
                    if (fullImageUrl.isEmpty) {
                      return Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 24.sp,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () => _showImagePreview(context, fullImageUrl),
                      child: Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            fullImageUrl,
                            fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 24.sp,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                    );
                  },
                ),
              ] else if (checkpoint.status != 'Tambahan') ...[
                4.verticalSpace,
                Text(
                  'Tidak ada gambar',
                  style: TS.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],

              // Tambahan label
              if (isTambahan) ...[
                4.verticalSpace,
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Tambahan',
                    style: TS.labelSmall.copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.all(0),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      padding: REdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: REdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 64.sp,
                            color: Colors.white,
                          ),
                          16.verticalSpace,
                          Text(
                            'Gagal memuat gambar',
                            style: TS.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}










