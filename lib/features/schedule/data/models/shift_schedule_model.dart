import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/shift_schedule.dart';

part 'shift_schedule_model.g.dart';

@JsonSerializable()
class ShiftScheduleModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Date')
  final String date;

  @JsonKey(name: 'ShiftName')
  final String shiftName;

  @JsonKey(name: 'ShiftTime')
  final String shiftTime;

  @JsonKey(name: 'Location')
  final String location;

  @JsonKey(name: 'Position')
  final String position;

  @JsonKey(name: 'Route')
  final String route;

  @JsonKey(name: 'PatrolLocations')
  final List<PatrolLocationModel> patrolLocations;

  @JsonKey(name: 'TeamMembers')
  final List<TeamMemberModel> teamMembers;

  const ShiftScheduleModel({
    required this.id,
    required this.date,
    required this.shiftName,
    required this.shiftTime,
    required this.location,
    required this.position,
    required this.route,
    required this.patrolLocations,
    required this.teamMembers,
  });

  factory ShiftScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftScheduleModelToJson(this);

  ShiftSchedule toEntity() {
    return ShiftSchedule(
      id: id,
      date: DateTime.parse(date),
      shiftName: shiftName,
      shiftTime: shiftTime,
      location: location,
      position: position,
      route: route,
      patrolLocations: patrolLocations.map((e) => e.toEntity()).toList(),
      teamMembers: teamMembers.map((e) => e.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class PatrolLocationModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Type')
  final String type;

  const PatrolLocationModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory PatrolLocationModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolLocationModelToJson(this);

  PatrolLocation toEntity() {
    return PatrolLocation(
      id: id,
      name: name,
      type: type,
    );
  }
}

@JsonSerializable()
class TeamMemberModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Position')
  final String position;

  @JsonKey(name: 'PhotoUrl')
  final String? photoUrl;

  const TeamMemberModel({
    required this.id,
    required this.name,
    required this.position,
    this.photoUrl,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMemberModelToJson(this);

  TeamMember toEntity() {
    return TeamMember(
      id: id,
      name: name,
      position: position,
      photoUrl: photoUrl,
    );
  }
}

@JsonSerializable()
class DailyAgendaModel {
  @JsonKey(name: 'Date')
  final String date;

  @JsonKey(name: 'ShiftType')
  final String shiftType;

  @JsonKey(name: 'Position')
  final String position;

  const DailyAgendaModel({
    required this.date,
    required this.shiftType,
    required this.position,
  });

  factory DailyAgendaModel.fromJson(Map<String, dynamic> json) =>
      _$DailyAgendaModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyAgendaModelToJson(this);

  DailyAgenda toEntity() {
    return DailyAgenda(
      date: DateTime.parse(date),
      shiftType: shiftType,
      position: position,
    );
  }
}
