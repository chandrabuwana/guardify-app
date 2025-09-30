import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';

/// Custom Filter Button dengan design yang konsisten
///
/// Button ini menyediakan:
/// - Icon funnel di kiri
/// - Background merah gelap
/// - Text putih
/// - Rounded corners
/// - Ripple effect saat ditekan
class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    Key? key,
    this.onPressed,
    this.text = 'Filter',
    this.icon = Icons.tune,
    this.isActive = false,
    this.activeCount,
    this.enabled = true,
    this.width,
    this.height,
  }) : super(key: key);

  /// Callback ketika button ditekan
  final VoidCallback? onPressed;

  /// Text yang ditampilkan di button
  final String text;

  /// Icon yang ditampilkan di button
  final IconData icon;

  /// Apakah button dalam state active/selected
  final bool isActive;

  /// Jumlah filter yang aktif (opsional)
  final int? activeCount;

  /// Apakah button enabled atau disabled
  final bool enabled;

  /// Lebar button (opsional)
  final double? width;

  /// Tinggi button (opsional)
  final double? height;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isActive ? primaryColor : primaryColor.withOpacity(0.9);
    final foregroundColor = enabled ? Colors.white : Colors.white70;

    return SizedBox(
      width: width,
      height: height ?? 40.h,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(20.r),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: foregroundColor,
                  size: 18.w,
                ),

                if (text.isNotEmpty) ...[
                  6.horizontalSpace,
                  Text(
                    text,
                    style: TS.labelMedium.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                // Badge untuk menampilkan jumlah filter aktif
                if (activeCount != null && activeCount! > 0) ...[
                  4.horizontalSpace,
                  Container(
                    padding: REdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      activeCount.toString(),
                      style: TS.caption.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

/// Custom Chip Filter untuk menampilkan filter yang sedang aktif
class CustomFilterChip extends StatelessWidget {
  const CustomFilterChip({
    Key? key,
    required this.label,
    this.onDeleted,
    this.backgroundColor,
    this.labelColor,
    this.deleteIconColor,
  }) : super(key: key);

  /// Label text yang ditampilkan di chip
  final String label;

  /// Callback ketika delete button ditekan
  final VoidCallback? onDeleted;

  /// Background color chip
  final Color? backgroundColor;

  /// Color untuk label text
  final Color? labelColor;

  /// Color untuk delete icon
  final Color? deleteIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.only(right: 8, bottom: 4),
      child: Chip(
        label: Text(
          label,
          style: TS.labelSmall.copyWith(
            color: labelColor ?? primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: backgroundColor ?? primaryColor.withOpacity(0.1),
        deleteIcon: Icon(
          Icons.close,
          size: 16.w,
          color: deleteIconColor ?? primaryColor,
        ),
        onDeleted: onDeleted,
        side: BorderSide(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

/// Widget untuk menampilkan kumpulan filter chips
class CustomFilterChipGroup extends StatelessWidget {
  const CustomFilterChipGroup({
    Key? key,
    this.categoryFilter,
    this.dateRangeFilter,
    this.onClearCategory,
    this.onClearDateRange,
    this.onClearAll,
  }) : super(key: key);

  /// Filter kategori yang aktif
  final String? categoryFilter;

  /// Filter rentang tanggal yang aktif
  final String? dateRangeFilter;

  /// Callback untuk clear kategori filter
  final VoidCallback? onClearCategory;

  /// Callback untuk clear date range filter
  final VoidCallback? onClearDateRange;

  /// Callback untuk clear semua filter
  final VoidCallback? onClearAll;

  bool get hasActiveFilters =>
      categoryFilter != null || dateRangeFilter != null;

  @override
  Widget build(BuildContext context) {
    if (!hasActiveFilters) return const SizedBox.shrink();

    return Container(
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filter Aktif:',
                style: TS.labelSmall.copyWith(
                  color: neutral70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (onClearAll != null)
                TextButton(
                  onPressed: onClearAll,
                  style: TextButton.styleFrom(
                    padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Hapus Semua',
                    style: TS.caption.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          4.verticalSpace,
          Wrap(
            children: [
              if (categoryFilter != null)
                CustomFilterChip(
                  label: 'Kategori: $categoryFilter',
                  onDeleted: onClearCategory,
                ),
              if (dateRangeFilter != null)
                CustomFilterChip(
                  label: 'Tanggal: $dateRangeFilter',
                  onDeleted: onClearDateRange,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
