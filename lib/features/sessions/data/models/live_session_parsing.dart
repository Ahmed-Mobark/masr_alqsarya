Map<String, dynamic> liveSessionAsJsonMap(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return <String, dynamic>{};
}

Map<String, dynamic> liveSessionMediatorOrPersona(Map<String, dynamic> root) {
  final m = liveSessionAsJsonMap(root['mediator']);
  if (m.isNotEmpty) return m;
  final expert = liveSessionAsJsonMap(root['expert_persona']);
  if (expert.isNotEmpty) return expert;
  return liveSessionAsJsonMap(root['persona']);
}

String? liveSessionReadString(Map<String, dynamic> root, List<String> keys) {
  for (final k in keys) {
    final v = root[k];
    if (v == null) continue;
    final s = v.toString().trim();
    if (s.isNotEmpty) return s;
  }
  return null;
}

int? liveSessionReadInt(Map<String, dynamic> root, List<String> keys) {
  for (final k in keys) {
    final v = root[k];
    if (v is int) return v;
    if (v is num) return v.toInt();
  }
  return null;
}

bool? liveSessionReadBool(Map<String, dynamic> root, List<String> keys) {
  for (final k in keys) {
    final v = root[k];
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final lower = v.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
  }
  return null;
}

DateTime? liveSessionReadDateTime(Map<String, dynamic> root, List<String> keys) {
  for (final k in keys) {
    final v = root[k];
    if (v == null) continue;
    final parsed = DateTime.tryParse(v.toString());
    if (parsed != null) return parsed;
  }
  return null;
}

/// API shape: `start_date` "yyyy-MM-dd" + `start_time` "HH:mm:ss" (local wall clock).
DateTime? liveSessionParseStartDateTime(Map<String, dynamic> json) {
  final raw = Map<String, dynamic>.from(json);
  final d = liveSessionReadString(raw, const ['start_date', 'startDate']);
  final t = liveSessionReadString(raw, const ['start_time', 'startTime']);
  if (d == null || t == null) return null;

  final dateParts = d.split('-');
  if (dateParts.length != 3) return null;
  final y = int.tryParse(dateParts[0].trim());
  final mo = int.tryParse(dateParts[1].trim());
  final da = int.tryParse(dateParts[2].trim());
  if (y == null || mo == null || da == null) return null;

  final timeParts = t.trim().split(':');
  final h = int.tryParse(timeParts.isNotEmpty ? timeParts[0] : '0') ?? 0;
  final mi = timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;
  final se = timeParts.length > 2 ? (int.tryParse(timeParts[2].split('.').first) ?? 0) : 0;

  return DateTime(y, mo, da, h, mi, se);
}
