import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/shift_schedule.dart';
import '../bloc/schedule_bloc.dart';
import 'shift_detail_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _hasLoadedInitialData = false;

  void _loadSchedule(BuildContext context) async {
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
    
    if (!mounted) return;
    
    context.read<ScheduleBloc>().add(LoadDailyAgenda(
      userId: userId,
      year: _focusedDay.year,
      month: _focusedDay.month,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal Kerja',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          // Load schedule when first built
          if (!_hasLoadedInitialData && !state.isLoading) {
            _hasLoadedInitialData = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadSchedule(context);
            });
          }
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agenda Esok Hari Section
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agenda Esok Hari',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildAgendaCard(state),
                    ],
                  ),
                ),

                // Calendar Section
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildCalendarHeader(state),
                      SizedBox(height: 16.h),
                      _buildCalendar(state),
                    ],
                  ),
                ),
                
                SizedBox(height: 100.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAgendaCard(ScheduleState state) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final agenda = state.dailyAgendas.firstWhere(
      (a) => a.date.day == tomorrow.day && 
             a.date.month == tomorrow.month && 
             a.date.year == tomorrow.year,
      orElse: () => state.dailyAgendas.isNotEmpty 
          ? state.dailyAgendas.first 
          : DailyAgenda(
              date: DateTime(2025, 9, 12),
              shiftType: 'Shift Pagi',
              position: 'Pos Merpati',
            ),
    );

    return GestureDetector(
      onTap: () async {
        final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
        if (!mounted) return;
        
        final scheduleBloc = context.read<ScheduleBloc>();
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: scheduleBloc,
              child: ShiftDetailPage(
                userId: userId,
                date: agenda.date,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Calendar Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Color(0xFFE74C3C),
              ),
            ),
            SizedBox(width: 12.w),
            
            // Shift Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agenda.shiftType,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('dd MMMM yyyy', 'id_ID').format(agenda.date),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Position Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  agenda.position,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE74C3C),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Lokasi Jaga',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader(ScheduleState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month - 1,
              );
            });
            _loadSchedule(context);
          },
        ),
        Text(
          DateFormat('MMMM yyyy', 'id_ID').format(_focusedDay),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month + 1,
              );
            });
            _loadSchedule(context);
          },
        ),
      ],
    );
  }

  Widget _buildCalendar(ScheduleState state) {
    return TableCalendar(
      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      headerVisible: false,
      daysOfWeekHeight: 40.h,
      rowHeight: 80.h,
      
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: const Color(0xFFE74C3C),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: const Color(0xFFE74C3C).withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(fontSize: 14.sp),
        weekendTextStyle: TextStyle(fontSize: 14.sp),
      ),
      
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
        weekendStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
      
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, state);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, state, isToday: true);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, state, isSelected: true);
        },
      ),
      
      onDaySelected: (selectedDay, focusedDay) async {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        
        final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
        if (!mounted) return;
        
        final scheduleBloc = context.read<ScheduleBloc>();
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: scheduleBloc,
              child: ShiftDetailPage(
                userId: userId,
                date: selectedDay,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCell(DateTime day, ScheduleState state, {
    bool isToday = false,
    bool isSelected = false,
  }) {
    final agenda = state.dailyAgendas.firstWhere(
      (a) => a.date.day == day.day && 
             a.date.month == day.month && 
             a.date.year == day.year,
      orElse: () => DailyAgenda(
        date: DateTime(2000, 1, 1),
        shiftType: '',
        position: '',
      ),
    );

    final hasShift = agenda.shiftType.isNotEmpty;

    return Container(
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isToday 
            ? const Color(0xFFE74C3C)
            : isSelected 
                ? const Color(0xFFE74C3C).withOpacity(0.7)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isToday || isSelected ? Colors.white : Colors.black,
            ),
          ),
          if (hasShift) ...[
            SizedBox(height: 4.h),
            Text(
              agenda.shiftType,
              style: TextStyle(
                fontSize: 9.sp,
                color: isToday || isSelected 
                    ? Colors.white 
                    : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              agenda.position,
              style: TextStyle(
                fontSize: 8.sp,
                color: isToday || isSelected 
                    ? Colors.white70 
                    : Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
