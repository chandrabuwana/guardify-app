import 'package:equatable/equatable.dart';

/// Entity untuk LeaveRequestType
class LeaveRequestTypeEntity extends Equatable {
  final int id;
  final bool active;
  final String? createBy;
  final String? createDate;
  final String? description;
  final String name;
  final String? updateBy;
  final String? updateDate;
  final int? quota;

  const LeaveRequestTypeEntity({
    required this.id,
    required this.active,
    this.createBy,
    this.createDate,
    this.description,
    required this.name,
    this.updateBy,
    this.updateDate,
    this.quota,
  });

  @override
  List<Object?> get props => [
        id,
        active,
        createBy,
        createDate,
        description,
        name,
        updateBy,
        updateDate,
        quota,
      ];
}

