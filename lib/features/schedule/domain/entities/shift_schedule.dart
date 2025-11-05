/// Entity untuk jadwal shift
class ShiftSchedule {
  final String id;
  final DateTime date;
  final String shiftName;
  final String shiftTime;
  final String location;
  final String position;
  final String route;
  final List<PatrolLocation> patrolLocations;
  final List<TeamMember> teamMembers;

  const ShiftSchedule({
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
}

/// Entity untuk lokasi patroli
class PatrolLocation {
  final String id;
  final String name;
  final String type; // Pos Merak, Pos Gajah, Pos Merpati, Pos Ayam

  const PatrolLocation({
    required this.id,
    required this.name,
    required this.type,
  });
}

/// Entity untuk anggota tim jaga
class TeamMember {
  final String id;
  final String name;
  final String position;
  final String? photoUrl;

  const TeamMember({
    required this.id,
    required this.name,
    required this.position,
    this.photoUrl,
  });
}

/// Entity untuk agenda harian
class DailyAgenda {
  final DateTime date;
  final String shiftType; // Shift Pagi, Shift Malam
  final String position; // Pos Gajah, Pos Merpati, dll

  const DailyAgenda({
    required this.date,
    required this.shiftType,
    required this.position,
  });
}
