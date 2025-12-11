class OfflineSyncService {
  static bool isOnline = true;
  static final List<Map<String, dynamic>> _pendingSync = [];

  static void addPendingSync(Map<String, dynamic> data) {
    _pendingSync.add(data);
  }

  static List<Map<String, dynamic>> getPendingSync() =>
      List.unmodifiable(_pendingSync);

  static void syncAll() {
    if (isOnline) {
      // Envoyer les données au backend
      _pendingSync.clear();
    }
  }
}
