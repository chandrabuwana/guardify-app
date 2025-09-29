// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AttendanceModel',
      json,
      ($checkedConvert) {
        final val = AttendanceModel(
          id: $checkedConvert('id', (v) => v as String),
          userId: $checkedConvert('user_id', (v) => v as String),
          userName: $checkedConvert('user_name', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$AttendanceTypeEnumMap, v)),
          shiftType: $checkedConvert(
              'shift_type', (v) => $enumDecode(_$ShiftTypeEnumMap, v)),
          timestamp:
              $checkedConvert('timestamp', (v) => DateTime.parse(v as String)),
          guardLocation: $checkedConvert('guard_location', (v) => v as String),
          currentLocation:
              $checkedConvert('current_location', (v) => v as String),
          latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
          personalClothing:
              $checkedConvert('personal_clothing', (v) => v as String),
          securityReport:
              $checkedConvert('security_report', (v) => v as String),
          photoPath: $checkedConvert('photo_path', (v) => v as String?),
          patrolRoute: $checkedConvert('patrol_route', (v) => v as String),
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$AttendanceStatusEnumMap, v) ??
                  AttendanceStatus.pending),
          rejectionReason:
              $checkedConvert('rejection_reason', (v) => v as String?),
          approvalChain: $checkedConvert(
              'approval_chain',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const []),
          approvedBy: $checkedConvert('approved_by', (v) => v as String?),
          approvedAt: $checkedConvert('approved_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updated_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'userName': 'user_name',
        'shiftType': 'shift_type',
        'guardLocation': 'guard_location',
        'currentLocation': 'current_location',
        'personalClothing': 'personal_clothing',
        'securityReport': 'security_report',
        'photoPath': 'photo_path',
        'patrolRoute': 'patrol_route',
        'rejectionReason': 'rejection_reason',
        'approvalChain': 'approval_chain',
        'approvedBy': 'approved_by',
        'approvedAt': 'approved_at',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at'
      },
    );

Map<String, dynamic> _$AttendanceModelToJson(AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'type': _$AttendanceTypeEnumMap[instance.type]!,
      'shift_type': _$ShiftTypeEnumMap[instance.shiftType]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'guard_location': instance.guardLocation,
      'current_location': instance.currentLocation,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'personal_clothing': instance.personalClothing,
      'security_report': instance.securityReport,
      'photo_path': instance.photoPath,
      'patrol_route': instance.patrolRoute,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'rejection_reason': instance.rejectionReason,
      'approval_chain': instance.approvalChain,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$AttendanceTypeEnumMap = {
  AttendanceType.clockIn: 'clockIn',
  AttendanceType.clockOut: 'clockOut',
};

const _$ShiftTypeEnumMap = {
  ShiftType.morning: 'morning',
  ShiftType.night: 'night',
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.pending: 'pending',
  AttendanceStatus.approved: 'approved',
  AttendanceStatus.rejected: 'rejected',
};
