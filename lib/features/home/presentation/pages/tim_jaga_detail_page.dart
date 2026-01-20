import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';

class TimJagaDetailPage extends StatefulWidget {
  final ShiftNowData shiftNow;

  const TimJagaDetailPage({
    super.key,
    required this.shiftNow,
  });

  @override
  State<TimJagaDetailPage> createState() => _TimJagaDetailPageState();
}

class _TimJagaDetailPageState extends State<TimJagaDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedAreaFilter;
  Map<String, String> _userIdToAreaMap = {};
  bool _isLoadingAreaMap = true;

  @override
  void initState() {
    super.initState();
    _loadAreaMapping();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Memanggil get_schedule_pengawas untuk mendapatkan mapping userId -> areaName
  Future<void> _loadAreaMapping() async {
    try {
      final scheduleRepository = getIt<ScheduleRepository>();
      final today = DateTime.now();
      
      // Panggil get_schedule_pengawas untuk mendapatkan informasi area
      final result = await scheduleRepository.getSchedulePengawas(date: today);
      
      if (result.isSuccess && result.shiftDetail != null) {
        final shiftDetail = result.shiftDetail!;
        
        // Loop melalui team members untuk mendapatkan mapping userId -> position (area)
        for (final member in shiftDetail.teamMembers) {
          // Position field contains "AreaName|ShiftName" format for pengawas schedule
          // Extract area name (before |)
          final areaName = member.position.contains('|') 
              ? member.position.split('|')[0] 
              : member.position;
          
          // Jika sudah ada mapping untuk userId ini, gabungkan area names
          if (_userIdToAreaMap.containsKey(member.id)) {
            final existingAreas = _userIdToAreaMap[member.id]!.split(', ');
            if (!existingAreas.contains(areaName)) {
              _userIdToAreaMap[member.id] = '${_userIdToAreaMap[member.id]}, $areaName';
            }
          } else {
            _userIdToAreaMap[member.id] = areaName;
          }
        }
      }
    } catch (e) {
      print('⚠️ Error getting schedule pengawas for area mapping: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAreaMap = false;
        });
      }
    }
  }

  /// Format tanggal untuk ditampilkan
  String _formatShiftDate() {
    try {
      final date = DateTime.parse(widget.shiftNow.shiftDate);
      final dayName = DateFormat('EEEE', 'id_ID').format(date);
      final dateStr = DateFormat('d MMMM yyyy', 'id_ID').format(date);
      return '$dayName, $dateStr';
    } catch (e) {
      return widget.shiftNow.shiftDate;
    }
  }

  /// Get all unique areas from personnel
  List<String> _getAllAreas() {
    final areas = <String>{};
    for (final personnel in widget.shiftNow.listPersonel) {
      final area = _userIdToAreaMap[personnel.userId] ?? 'Pos';
      // Handle multiple areas (comma-separated)
      final areaList = area.split(', ');
      areas.addAll(areaList);
    }
    return areas.toList()..sort();
  }

  /// Filter personnel by search and area
  List<PersonnelWithArea> _getFilteredPersonnel() {
    final query = _searchController.text.toLowerCase().trim();
    final List<PersonnelWithArea> result = [];

    for (final personnel in widget.shiftNow.listPersonel) {
      final area = _userIdToAreaMap[personnel.userId] ?? 'Pos';
      final areaList = area.split(', ');

      // Filter by search query
      final matchesSearch = query.isEmpty ||
          personnel.fullname.toLowerCase().contains(query) ||
          areaList.any((a) => a.toLowerCase().contains(query));

      // Filter by area
      final matchesArea = _selectedAreaFilter == null ||
          _selectedAreaFilter!.isEmpty ||
          areaList.contains(_selectedAreaFilter);

      if (matchesSearch && matchesArea) {
        // Add personnel for each area they're assigned to
        for (final areaName in areaList) {
          result.add(PersonnelWithArea(
            userId: personnel.userId,
            fullname: personnel.fullname,
            images: personnel.images,
            area: areaName,
          ));
        }
      }
    }

    return result;
  }

  /// Group personnel by area
  Map<String, List<PersonnelWithArea>> _groupByArea(List<PersonnelWithArea> personnelList) {
    final grouped = <String, List<PersonnelWithArea>>{};
    
    for (final personnel in personnelList) {
      if (!grouped.containsKey(personnel.area)) {
        grouped[personnel.area] = [];
      }
      // Avoid duplicates (same person in same area)
      if (!grouped[personnel.area]!.any((p) => p.userId == personnel.userId)) {
        grouped[personnel.area]!.add(personnel);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final filteredPersonnel = _getFilteredPersonnel();
    final groupedPersonnel = _groupByArea(filteredPersonnel);
    final allAreas = _getAllAreas();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hari Ini',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Shift Information
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: Colors.white,
            child: Text(
              'Tim ${widget.shiftNow.shiftName} - ${_formatShiftDate()}',
              style: TS.bodyMedium.copyWith(
                color: neutral70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Search and Filter
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: neutral10,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: primaryColor),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Cari',
                        hintStyle: TextStyle(
                          color: neutral50,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: neutral50,
                          size: 20.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                // Filter button
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.filter_list, color: Colors.white, size: 20.sp),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: null,
                        child: Text(
                          'Semua',
                          style: TS.bodyMedium.copyWith(
                            color: _selectedAreaFilter == null ? primaryColor : neutral90,
                            fontWeight: _selectedAreaFilter == null ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      ...allAreas.map((area) => PopupMenuItem(
                        value: area,
                        child: Text(
                          area,
                          style: TS.bodyMedium.copyWith(
                            color: _selectedAreaFilter == area ? primaryColor : neutral90,
                            fontWeight: _selectedAreaFilter == area ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      )),
                    ],
                    onSelected: (value) {
                      setState(() {
                        _selectedAreaFilter = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Personnel List
          Expanded(
            child: _isLoadingAreaMap
                ? Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : groupedPersonnel.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64.sp,
                              color: neutral50,
                            ),
                            16.verticalSpace,
                            Text(
                              'Tidak ada personil ditemukan',
                              style: TS.bodyMedium.copyWith(
                                color: neutral70,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        itemCount: groupedPersonnel.length,
                        itemBuilder: (context, index) {
                          final area = groupedPersonnel.keys.toList()[index];
                          final personnelList = groupedPersonnel[area]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Area Title
                              Padding(
                                padding: EdgeInsets.only(top: index > 0 ? 16.h : 0, bottom: 8.h),
                                child: Text(
                                  area,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: neutral90,
                                  ),
                                ),
                              ),
                              // Personnel Grid
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8.w,
                                  mainAxisSpacing: 8.h,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: personnelList.length,
                                itemBuilder: (context, idx) {
                                  final personnel = personnelList[idx];
                                  return _buildPersonnelCard(personnel);
                                },
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonnelCard(PersonnelWithArea personnel) {
    return Container(
      decoration: BoxDecoration(
        color: babyBlueColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          CircleAvatar(
            radius: 28.r,
            backgroundColor: neutral30,
            backgroundImage: personnel.images != null && personnel.images!.isNotEmpty
                ? NetworkImage(personnel.images!)
                : null,
            child: personnel.images == null || personnel.images!.isEmpty
                ? Icon(
                    Icons.person,
                    size: 28.sp,
                    color: neutral50,
                  )
                : null,
          ),
          6.verticalSpace,

          // Nama
          Flexible(
            child: Text(
              personnel.fullname,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: neutral90,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          4.verticalSpace,

          // Status Badge
          Container(
            constraints: BoxConstraints(
              maxWidth: double.infinity,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 3.h,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              personnel.area,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          6.verticalSpace,

          // Kirim Pesan button
          SizedBox(
            width: double.infinity,
            height: 28.h,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Kirim pesan ke ${personnel.fullname}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                'Kirim Pesan',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model untuk personil dengan area
class PersonnelWithArea {
  final String userId;
  final String fullname;
  final String? images;
  final String area;

  PersonnelWithArea({
    required this.userId,
    required this.fullname,
    this.images,
    required this.area,
  });
}
