import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'shift_schedule_model.dart';
import 'shift_category_response_model.dart';
import 'route_response_model.dart';

part 'shift_detail_response_model.g.dart';

/// Response model for ShiftDetail/list API
@JsonSerializable()
class ShiftDetailResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<ShiftDetailItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  ShiftDetailResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory ShiftDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftDetailResponseModelToJson(this);
}

/// Individual shift detail item
@JsonSerializable()
class ShiftDetailItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'IdShift')
  final String idShift;

  @JsonKey(name: 'Shift')
  final ShiftModel shift;

  @JsonKey(name: 'UserId')
  final String? userId;

  @JsonKey(name: 'User')
  final UserModel? user;

  @JsonKey(name: 'IdRoute')
  final String? idRoute;

  @JsonKey(name: 'Route')
  final RouteModel? route;

  @JsonKey(name: 'Location')
  final String location;

  ShiftDetailItemModel({
    required this.id,
    required this.idShift,
    required this.shift,
    this.userId,
    this.user,
    this.idRoute,
    this.route,
    required this.location,
  });

  factory ShiftDetailItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftDetailItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftDetailItemModelToJson(this);

  /// Convert to ShiftScheduleModel with all team members
  ShiftScheduleModel toShiftScheduleModel(
    List<ShiftDetailItemModel> allItems, {
    ShiftCategoryModel? shiftCategory,
    RouteDataModel? routeData,
  }) {
    // Get all team members from the same shift
    final teamMembers = allItems
        .where((item) => item.idShift == idShift)
        .map((item) => TeamMemberModel(
              id: item.userId ?? item.id,
              name: item.user?.fullname ?? item.user?.username ?? 'Unknown',
              position: item.location,
              photoUrl: null,
            ))
        .toList();

    // Determine shift name (prioritize shiftCategory from API)
    final String shiftName = shiftCategory?.name ??
        shift.shiftCategory?.name ??
        (shift.idShiftCategory == 1 ? 'Shift Pagi' : 'Shift Malam');

    // Determine shift time (prioritize shiftCategory from API)
    final String shiftTime = shiftCategory?.getFormattedTime() ??
        shift.shiftCategory?.getFormattedTime() ??
        _getShiftTimeFromDate(shift.shiftDate);

    // Determine route name (prioritize routeData from GET /Route/get/{id})
    final String routeName = routeData?.name ?? route?.name ?? idRoute ?? 'N/A';

    // Parse date
    final DateTime parsedDate = DateTime.parse(shift.shiftDate);
    final String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    return ShiftScheduleModel(
      id: idShift,
      date: formattedDate,
      shiftName: shiftName,
      shiftTime: shiftTime,
      location: location,
      position: location,
      route: routeName,
      patrolLocations: const [], // Will be populated from RouteDetail API
      teamMembers: teamMembers,
    );
  }

  /// Fallback: Extract shift time from ShiftDate timestamp
  String _getShiftTimeFromDate(String shiftDate) {
    try {
      final DateTime date = DateTime.parse(shiftDate);
      final hour = date.hour;

      if (hour >= 7 && hour < 19) {
        return '07:00 - 19:00 WIB'; // Shift Pagi
      } else {
        return '19:00 - 07:00 WIB'; // Shift Malam
      }
    } catch (e) {
      return 'N/A';
    }
  }
}

/// Shift model
@JsonSerializable()
class ShiftModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'ShiftDate')
  final String shiftDate;

  @JsonKey(name: 'IdShiftCategory')
  final int idShiftCategory;

  @JsonKey(name: 'ShiftCategory')
  final ShiftCategoryModel? shiftCategory;

  ShiftModel({
    required this.id,
    required this.shiftDate,
    required this.idShiftCategory,
    this.shiftCategory,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
}

/// User model
@JsonSerializable()
class UserModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  UserModel({
    required this.id,
    this.username,
    this.fullname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

/// Route model (nested in ShiftDetailItem)
@JsonSerializable()
class RouteModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  RouteModel({
    required this.id,
    required this.name,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}
