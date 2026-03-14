import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/cuti_kuota_item_entity.dart';

class KuotaCutiGrid extends StatelessWidget {
  final List<CutiKuotaItemEntity> kuotaList;

  const KuotaCutiGrid({
    Key? key,
    required this.kuotaList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure we have at least 4 items (pad with empty if needed)
    final displayList = List<CutiKuotaItemEntity>.from(kuotaList);
    while (displayList.length < 4) {
      displayList.add(const CutiKuotaItemEntity(quota: 0, remaining: 0));
    }
    // Take only first 4 items
    final items = displayList.take(4).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card size based on available width
        final cardWidth = (constraints.maxWidth - 12.w) / 2;
        final cardHeight = cardWidth; // Square cards
        
        return SizedBox(
          height: (cardHeight * 2) + 12.h, // 2 rows + spacing
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _KuotaCutiCard(
                kuota: items[index],
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}

class _KuotaCutiCard extends StatelessWidget {
  final CutiKuotaItemEntity kuota;
  final int index;

  const _KuotaCutiCard({
    required this.kuota,
    required this.index,
  });

  // Define card colors based on index
  Color get _backgroundColor {
    switch (index) {
      case 0:
        return const Color(0xFFFFE5E5); // Light pink/red
      case 1:
        return const Color(0xFFE5E5FF); // Light blue/lavender
      case 2:
        return primaryColor; // Dark red
      case 3:
        return const Color(0xFF1E3A8A); // Dark blue
      default:
        return Colors.grey.shade200;
    }
  }

  Color get _textColor {
    switch (index) {
      case 0:
      case 1:
        return Colors.black87;
      case 2:
      case 3:
        return Colors.white;
      default:
        return Colors.black87;
    }
  }

  Color get _iconColor {
    switch (index) {
      case 0:
        return primaryColor; // Dark red
      case 1:
        return const Color(0xFF1E3A8A); // Dark blue
      case 2:
      case 3:
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.luggage_outlined,
              color: _iconColor,
              size: 28.sp,
            ),
          ),

          // Content
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sisa',
                  style: TS.bodySmall.copyWith(
                    color: _textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                2.verticalSpace,
                Text(
                  '${kuota.remaining} Hari',
                  style: TS.titleMedium.copyWith(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Text(
                  'Kuota : ${kuota.quota} Hari',
                  style: TS.bodySmall.copyWith(
                    color: _textColor.withOpacity(0.8),
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Text(
                  (kuota.leaveRequestName != null && kuota.leaveRequestName!.isNotEmpty)
                      ? kuota.leaveRequestName!
                      : '-',
                  style: TS.bodySmall.copyWith(
                    color: _textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
