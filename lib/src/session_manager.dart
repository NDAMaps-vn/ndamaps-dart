import 'package:uuid/uuid.uuid.dart';

class SessionManager {
  String? _token;
  DateTime? _createdAt;
  final Duration _ttl = const Duration(minutes: 5);
  final Uuid _uuid = const Uuid();

  String getOrCreate() {
    final now = DateTime.now();
    if (_token != null && _createdAt != null && now.difference(_createdAt!) <= _ttl) {
      return _token!;
    }
    _token = _uuid.v4();
    _createdAt = now;
    return _token!;
  }

  String? getCurrent() {
    final now = DateTime.now();
    if (_token != null && _createdAt != null && now.difference(_createdAt!) <= _ttl) {
      return _token;
    }
    _token = null;
    return null;
  }

  void reset() {
    _token = null;
  }
}
