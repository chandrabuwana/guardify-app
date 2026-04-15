abstract class PersonnelEvent {
  const PersonnelEvent();
}

/// Load personnel list by status
class LoadPersonnelByStatusEvent extends PersonnelEvent {
  final String status; // 'Aktif', 'Pending', 'Non Aktif'
  final int page;
  final int pageSize;

  const LoadPersonnelByStatusEvent(this.status, {this.page = 1, this.pageSize = 20});
}

/// Load personnel detail
class LoadPersonnelDetailEvent extends PersonnelEvent {
  final String personnelId;

  const LoadPersonnelDetailEvent(this.personnelId);
}

/// Search personnel
class SearchPersonnelEvent extends PersonnelEvent {
  final String query;
  final String status;

  const SearchPersonnelEvent(this.query, this.status);
}

/// Approve personnel (Pending → Aktif)
class ApprovePersonnelEvent extends PersonnelEvent {
  final String personnelId;
  final String feedback;

  const ApprovePersonnelEvent(this.personnelId, this.feedback);
}

/// Revise personnel (request revision)
class RevisePersonnelEvent extends PersonnelEvent {
  final String personnelId;
  final String feedback;

  const RevisePersonnelEvent(this.personnelId, this.feedback);
}

/// Load more personnel (pagination) - API dipanggil saat scroll
class LoadMorePersonnelEvent extends PersonnelEvent {
  final String status;

  const LoadMorePersonnelEvent(this.status);
}

/// Clear personnel detail
class ClearPersonnelDetailEvent extends PersonnelEvent {
  const ClearPersonnelDetailEvent();
}
