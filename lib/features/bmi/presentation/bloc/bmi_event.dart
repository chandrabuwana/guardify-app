part of 'bmi_bloc.dart';

abstract class BMIEvent {}

// User Profile Events
class BMIGetUserProfile extends BMIEvent {
  final String userId;
  BMIGetUserProfile(this.userId);
}

// Search Events
class BMISearchUsers extends BMIEvent {
  final String query;
  BMISearchUsers(this.query);
}

class BMILoadAllUsers extends BMIEvent {}

class BMILoadMoreUsers extends BMIEvent {}

// Pin Events
class BMITogglePin extends BMIEvent {
  final String userId;
  final bool isPinned;
  BMITogglePin(this.userId, this.isPinned);
}

class BMILoadPinnedUsers extends BMIEvent {}

// BMI Calculation Events
class BMICalculate extends BMIEvent {
  final String userId;
  final double weight;
  final double height;
  final String? notes;
  final String? recordedBy;

  BMICalculate({
    required this.userId,
    required this.weight,
    required this.height,
    this.notes,
    this.recordedBy,
  });
}

// History Events
class BMILoadHistory extends BMIEvent {
  final String userId;
  final bool forceRefresh; // Flag untuk force refresh data
  BMILoadHistory(this.userId, {this.forceRefresh = false});
}

class BMIDeleteRecord extends BMIEvent {
  final String recordId;
  BMIDeleteRecord(this.recordId);
}

// Filter Events
class BMIFilterByCategory extends BMIEvent {
  final String category;
  BMIFilterByCategory(this.category);
}

// Reset Events
class BMIReset extends BMIEvent {}

class BMIClearError extends BMIEvent {}
