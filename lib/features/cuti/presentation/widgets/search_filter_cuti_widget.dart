import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import 'filter_cuti_bottom_sheet.dart';

class SearchFilterCutiWidget extends StatefulWidget {
  final Function(String? searchQuery, String? status, String? tipeCuti,
      DateTime? tanggalMulai, DateTime? tanggalSelesai, String? sortBy) onFilterApplied;
  final Function(String) onSearchChanged;

  const SearchFilterCutiWidget({
    Key? key,
    required this.onFilterApplied,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<SearchFilterCutiWidget> createState() => _SearchFilterCutiWidgetState();
}

class _SearchFilterCutiWidgetState extends State<SearchFilterCutiWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterCutiBottomSheet(
        initialStatus: null,
        initialTipeCuti: null,
        initialTanggalMulai: null,
        initialTanggalSelesai: null,
        initialSort: null,
      ),
    );

    if (result != null) {
      widget.onFilterApplied(
        _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        result['status'] as String?,
        result['tipeCuti'] as String?,
        result['tanggalMulai'] as DateTime?,
        result['tanggalSelesai'] as DateTime?,
        result['sort'] as String?,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  widget.onSearchChanged(value);
                  // Filter state is managed by parent, so we pass null for other filters
                  // Parent will maintain the filter state
                },
                style: TS.bodyMedium.copyWith(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: Colors.grey.shade500,
                  ),
                  prefixIcon: Padding(
                    padding: REdgeInsets.only(left: 16, right: 12),
                    child: Icon(
                      Icons.search,
                      color: primaryColor,
                      size: 20.w,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? Padding(
                          padding: REdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade500,
                              size: 20.w,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              widget.onSearchChanged('');
                              // Filter state is managed by parent
                            },
                            splashRadius: 16.r,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: REdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          12.horizontalSpace,

          // Filter Button
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _openFilterDialog,
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

