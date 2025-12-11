class AuditService {
  static final List<String> _logs = [];

  static void log(String action) {
    _logs.add('${DateTime.now()}: $action');
  }

  static List<String> getLogs() => List.unmodifiable(_logs);
}
