import '../models/panic_button_model.dart';

abstract class PanicButtonLocalDataSource {
  Future<bool> cachePanicButton(PanicButtonModel panicButton);
  Future<List<PanicButtonModel>> getCachedPanicButtons();
  Future<bool> clearPanicButtonCache();
}

class PanicButtonLocalDataSourceImpl implements PanicButtonLocalDataSource {
  // This would typically use SharedPreferences, Hive, or SQLite
  static List<PanicButtonModel> _cachedPanicButtons = [];

  @override
  Future<bool> cachePanicButton(PanicButtonModel panicButton) async {
    try {
      _cachedPanicButtons.add(panicButton);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<PanicButtonModel>> getCachedPanicButtons() async {
    return _cachedPanicButtons;
  }

  @override
  Future<bool> clearPanicButtonCache() async {
    try {
      _cachedPanicButtons.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
