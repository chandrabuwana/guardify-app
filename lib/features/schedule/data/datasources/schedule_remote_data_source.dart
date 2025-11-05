import 'package:injectable/injectable.dart';
import '../models/shift_schedule_model.dart';

/// Mock data source untuk schedule (implementasi sementara)
/// Ganti dengan @RestApi() Retrofit ketika API sudah ready
@Injectable(as: ScheduleRemoteDataSource)
class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  @override
  Future<List<ShiftScheduleModel>> getMonthlySchedule({
    required String userId,
    required int year,
    required int month,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - return empty untuk bulan lain
    if (month != 9) {
      return [];
    }

    // Mock schedule untuk September 2025
    return [
      ShiftScheduleModel(
        id: '1',
        date: '2025-09-12',
        shiftName: 'Shift Pagi',
        shiftTime: '07.00 WIB',
        location: 'Lokasi Jaga',
        position: 'Pos Merpati',
        route: 'Rute A',
        patrolLocations: [
          const PatrolLocationModel(
            id: '1',
            name: 'Pos Merak',
            type: 'Pos Merak',
          ),
          const PatrolLocationModel(
            id: '2',
            name: 'Pos Gajah',
            type: 'Pos Gajah',
          ),
          const PatrolLocationModel(
            id: '3',
            name: 'Pos Merpati',
            type: 'Pos Merpati',
          ),
        ],
        teamMembers: [
          const TeamMemberModel(
            id: '1',
            name: 'Aiman Hafiz',
            position: 'Pos Gajah',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '2',
            name: 'Aiman Hafiz',
            position: 'Pos Gajan',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '3',
            name: 'Aiman Hafiz',
            position: 'Pos Ayam',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '4',
            name: 'Aiman Hafiz',
            position: 'Pos Gajah',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '5',
            name: 'Aiman Hafiz',
            position: 'Pos Gajan',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '6',
            name: 'Aiman Hafiz',
            position: 'Pos Gajah',
            photoUrl: null,
          ),
        ],
      ),
    ];
  }

  @override
  Future<ShiftScheduleModel?> getShiftDetail({
    required String userId,
    required DateTime date,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return detail untuk 12 September 2025
    if (date.year == 2025 && date.month == 9 && date.day == 12) {
      return ShiftScheduleModel(
        id: '1',
        date: '2025-09-12',
        shiftName: 'Shift Pagi',
        shiftTime: '07.00 WIB',
        location: 'Lokasi Jaga',
        position: 'Pos Merpati',
        route: 'Rute A',
        patrolLocations: [
          const PatrolLocationModel(
            id: '1',
            name: 'Pos Merak',
            type: 'Pos Merak',
          ),
          const PatrolLocationModel(
            id: '2',
            name: 'Pos Gajah',
            type: 'Pos Gajah',
          ),
          const PatrolLocationModel(
            id: '3',
            name: 'Pos Merpati',
            type: 'Pos Merpati',
          ),
        ],
        teamMembers: [
          const TeamMemberModel(
            id: '1',
            name: 'Aiman Hafiz',
            position: 'Pos Gajah',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '2',
            name: 'Aiman Hafiz',
            position: 'Pos Gajan',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '3',
            name: 'Aiman Hafiz',
            position: 'Pos Ayam',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '4',
            name: 'Aiman Hafiz',
            position: 'Pos Gajah',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '5',
            name: 'Aiman Hafiz',
            position: 'Pos Gajan',
            photoUrl: null,
          ),
          const TeamMemberModel(
            id: '6',
            name: 'Aiman Hafiz',
            position: 'Pos Gajah',
            photoUrl: null,
          ),
        ],
      );
    }

    return null;
  }

  @override
  Future<List<DailyAgendaModel>> getDailyAgenda({
    required String userId,
    required int year,
    required int month,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Mock agenda untuk September 2025
    if (year == 2025 && month == 9) {
      return List.generate(20, (index) {
        final day = index + 1;
        final isEvenDay = day % 2 == 0;
        
        return DailyAgendaModel(
          date: '2025-09-${day.toString().padLeft(2, '0')}',
          shiftType: isEvenDay ? 'Shift Pagi' : 'Shift Malam',
          position: 'Pos Gajah',
        );
      });
    }

    return [];
  }
}

/// Abstract data source interface
abstract class ScheduleRemoteDataSource {
  Future<List<ShiftScheduleModel>> getMonthlySchedule({
    required String userId,
    required int year,
    required int month,
  });

  Future<ShiftScheduleModel?> getShiftDetail({
    required String userId,
    required DateTime date,
  });

  Future<List<DailyAgendaModel>> getDailyAgenda({
    required String userId,
    required int year,
    required int month,
  });
}

// Retrofit implementation (uncomment when API ready)
/*
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'schedule_remote_data_source.g.dart';

@RestApi()
abstract class ScheduleRemoteDataSource {
  factory ScheduleRemoteDataSource(Dio dio, {String baseUrl}) =
      _ScheduleRemoteDataSource;

  @GET('/Schedule/monthly')
  Future<List<ShiftScheduleModel>> getMonthlySchedule(
    @Query('userId') String userId,
    @Query('year') int year,
    @Query('month') int month,
  );

  @GET('/Schedule/detail')
  Future<ShiftScheduleModel?> getShiftDetail(
    @Query('userId') String userId,
    @Query('date') String date,
  );

  @GET('/Schedule/agenda')
  Future<List<DailyAgendaModel>> getDailyAgenda(
    @Query('userId') String userId,
    @Query('year') int year,
    @Query('month') int month,
  );
}
*/
