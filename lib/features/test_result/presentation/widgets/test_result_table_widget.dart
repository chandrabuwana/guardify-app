import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../domain/entities/test_member_result_entity.dart';

/// Widget table untuk menampilkan hasil Test anggota
/// Kolom: Nama, Jabatan, Nilai, Atasan (avatar)
class TestResultTableWidget extends StatelessWidget {
  final List<TestMemberResultEntity> results;

  const TestResultTableWidget({
    Key? key,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nama',
                    style: TS.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: neutral90,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Jabatan',
                    style: TS.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: neutral90,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Nilai',
                    style: TS.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: neutral90,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Atasan',
                    style: TS.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: neutral90,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Table Body
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                final isLast = index == results.length - 1;

                return Container(
                  padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: neutral20,
                              width: 1,
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      // Nama
                      Expanded(
                        flex: 3,
                        child: Text(
                          result.nama,
                          style: TS.bodyMedium.copyWith(
                            color: neutral90,
                          ),
                        ),
                      ),

                      // Jabatan
                      Expanded(
                        flex: 2,
                        child: Text(
                          result.jabatan,
                          style: TS.bodyMedium.copyWith(
                            color: neutral70,
                          ),
                        ),
                      ),

                      // Nilai
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: REdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getNilaiColor(result.nilai).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            result.nilai.toString(),
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getNilaiColor(result.nilai),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // Atasan Avatar
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: result.atasanImageUrl != null
                              ? CircleAvatar(
                                  radius: 16.r,
                                  backgroundImage: NetworkImage(result.atasanImageUrl!),
                                  onBackgroundImageError: (_, __) {},
                                  child: result.atasanImageUrl!.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 16.w,
                                          color: neutral50,
                                        )
                                      : null,
                                )
                              : CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: neutral20,
                                  child: Icon(
                                    Icons.person,
                                    size: 16.w,
                                    color: neutral50,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // NOTE Section (Optional)
          Container(
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16.w,
                  color: const Color(0xFFFF9800),
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    'NOTE: by default sort by',
                    style: TS.caption.copyWith(
                      color: const Color(0xFFFF9800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNilaiColor(int nilai) {
    if (nilai >= 80) {
      return successColor; // Hijau untuk nilai tinggi
    } else if (nilai >= 70) {
      return const Color(0xFF2196F3); // Biru untuk nilai sedang-tinggi
    } else if (nilai >= 60) {
      return const Color(0xFFFF9800); // Orange untuk nilai sedang
    } else {
      return errorColor; // Merah untuk nilai rendah
    }
  }
}

