// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_rekap_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRekapDetailResponseModel _$AttendanceRekapDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AttendanceRekapDetailResponseModel',
      json,
      ($checkedConvert) {
        final val = AttendanceRekapDetailResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : AttendanceRekapDetailDataModel.fromJson(
                      v as Map<String, dynamic>)),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'data': 'Data',
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$AttendanceRekapDetailResponseModelToJson(
        AttendanceRekapDetailResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

AttendanceRekapDetailDataModel _$AttendanceRekapDetailDataModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AttendanceRekapDetailDataModel',
      json,
      ($checkedConvert) {
        final val = AttendanceRekapDetailDataModel(
          idAttendance: $checkedConvert('IdAttendance', (v) => v as String),
          idShift: $checkedConvert('IdShift', (v) => v as String),
          fullname: $checkedConvert('Fullname', (v) => v as String),
          nrp: $checkedConvert('Nrp', (v) => v as String),
          jabatan: $checkedConvert('Jabatan', (v) => v as String),
          photoPegawai: $checkedConvert('PhotoPegawai', (v) => v as String?),
          statusLaporan: $checkedConvert('StatusLaporan', (v) => v as String),
          shiftDate: $checkedConvert('ShiftDate', (v) => v as String),
          shiftName: $checkedConvert('ShiftName', (v) => v as String),
          location: $checkedConvert('Location', (v) => v as String?),
          route: $checkedConvert('Route', (v) => v as String?),
          patrol: $checkedConvert('Patrol', (v) => v as String?),
          checkIn: $checkedConvert('CheckIn', (v) => v as String?),
          photoPakaian: $checkedConvert(
              'PhotoPakaian',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          notes: $checkedConvert('Notes', (v) => v as String?),
          photoPengamanan: $checkedConvert(
              'PhotoPengamanan',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          listCarryOver: $checkedConvert(
              'ListCarryOver',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      CarryOverItemModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          photoCheckin: $checkedConvert(
              'PhotoCheckin',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          listRoute: $checkedConvert(
              'ListRoute',
              (v) => (v as List<dynamic>)
                  .map(
                      (e) => RouteItemModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          checkOut: $checkedConvert('CheckOut', (v) => v as String?),
          carryOver: $checkedConvert('CarryOver', (v) => v as String?),
          isOvertime: $checkedConvert('IsOvertime', (v) => v as bool),
          statusKerja: $checkedConvert('StatusKerja', (v) => v as String?),
          photoCheckout: $checkedConvert(
              'PhotoCheckout',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          photoCheckoutPengamanan: $checkedConvert(
              'PhotoCheckoutPengamanan',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          photoCheckoutPakaian: $checkedConvert(
              'PhotoCheckoutPakaian',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          photoOvertime: $checkedConvert(
              'PhotoOvertime',
              (v) => v == null
                  ? null
                  : PhotoInfoModel.fromJson(v as Map<String, dynamic>)),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          feedback: $checkedConvert('Feedback', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAttendance': 'IdAttendance',
        'idShift': 'IdShift',
        'fullname': 'Fullname',
        'nrp': 'Nrp',
        'jabatan': 'Jabatan',
        'photoPegawai': 'PhotoPegawai',
        'statusLaporan': 'StatusLaporan',
        'shiftDate': 'ShiftDate',
        'shiftName': 'ShiftName',
        'location': 'Location',
        'route': 'Route',
        'patrol': 'Patrol',
        'checkIn': 'CheckIn',
        'photoPakaian': 'PhotoPakaian',
        'notes': 'Notes',
        'photoPengamanan': 'PhotoPengamanan',
        'listCarryOver': 'ListCarryOver',
        'photoCheckin': 'PhotoCheckin',
        'listRoute': 'ListRoute',
        'checkOut': 'CheckOut',
        'carryOver': 'CarryOver',
        'isOvertime': 'IsOvertime',
        'statusKerja': 'StatusKerja',
        'photoCheckout': 'PhotoCheckout',
        'photoCheckoutPengamanan': 'PhotoCheckoutPengamanan',
        'photoCheckoutPakaian': 'PhotoCheckoutPakaian',
        'photoOvertime': 'PhotoOvertime',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'feedback': 'Feedback'
      },
    );

Map<String, dynamic> _$AttendanceRekapDetailDataModelToJson(
        AttendanceRekapDetailDataModel instance) =>
    <String, dynamic>{
      'IdAttendance': instance.idAttendance,
      'IdShift': instance.idShift,
      'Fullname': instance.fullname,
      'Nrp': instance.nrp,
      'Jabatan': instance.jabatan,
      'PhotoPegawai': instance.photoPegawai,
      'StatusLaporan': instance.statusLaporan,
      'ShiftDate': instance.shiftDate,
      'ShiftName': instance.shiftName,
      'Location': instance.location,
      'Route': instance.route,
      'Patrol': instance.patrol,
      'CheckIn': instance.checkIn,
      'PhotoPakaian': instance.photoPakaian?.toJson(),
      'Notes': instance.notes,
      'PhotoPengamanan': instance.photoPengamanan?.toJson(),
      'ListCarryOver': instance.listCarryOver.map((e) => e.toJson()).toList(),
      'PhotoCheckin': instance.photoCheckin?.toJson(),
      'ListRoute': instance.listRoute.map((e) => e.toJson()).toList(),
      'CheckOut': instance.checkOut,
      'CarryOver': instance.carryOver,
      'IsOvertime': instance.isOvertime,
      'StatusKerja': instance.statusKerja,
      'PhotoCheckout': instance.photoCheckout?.toJson(),
      'PhotoCheckoutPengamanan': instance.photoCheckoutPengamanan?.toJson(),
      'PhotoCheckoutPakaian': instance.photoCheckoutPakaian?.toJson(),
      'PhotoOvertime': instance.photoOvertime?.toJson(),
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'Feedback': instance.feedback,
    };

PhotoInfoModel _$PhotoInfoModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PhotoInfoModel',
      json,
      ($checkedConvert) {
        final val = PhotoInfoModel(
          filename: $checkedConvert('Filename', (v) => v as String?),
          url: $checkedConvert('Url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'filename': 'Filename', 'url': 'Url'},
    );

Map<String, dynamic> _$PhotoInfoModelToJson(PhotoInfoModel instance) =>
    <String, dynamic>{
      'Filename': instance.filename,
      'Url': instance.url,
    };

CarryOverItemModel _$CarryOverItemModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CarryOverItemModel',
      json,
      ($checkedConvert) {
        final val = CarryOverItemModel(
          note: $checkedConvert('Note', (v) => v as String),
          status: $checkedConvert('Status', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'note': 'Note', 'status': 'Status'},
    );

Map<String, dynamic> _$CarryOverItemModelToJson(CarryOverItemModel instance) =>
    <String, dynamic>{
      'Note': instance.note,
      'Status': instance.status,
    };

RouteItemModel _$RouteItemModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteItemModel',
      json,
      ($checkedConvert) {
        final val = RouteItemModel();
        return val;
      },
    );

Map<String, dynamic> _$RouteItemModelToJson(RouteItemModel instance) =>
    <String, dynamic>{};
