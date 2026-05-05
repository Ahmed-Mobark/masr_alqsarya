import 'package:masr_al_qsariya/features/messages/domain/entities/chat_audit_log_entry.dart';

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return {};
}

String _str(dynamic v) {
  if (v == null) return '';
  if (v is String) return v.trim();
  return v.toString();
}

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is int) {
    if (v > 2000000000000) return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true);
    if (v > 1000000000) return DateTime.fromMillisecondsSinceEpoch(v * 1000, isUtc: true);
  }
  final s = _str(v);
  if (s.isEmpty) return null;
  return DateTime.tryParse(s);
}

class ChatAuditLogEntryModel {
  const ChatAuditLogEntryModel({
    this.id,
    required this.incidentLabel,
    this.occurredAt,
    required this.originalText,
    required this.revisedText,
  });

  final int? id;
  final String incidentLabel;
  final DateTime? occurredAt;
  final String originalText;
  final String revisedText;

  factory ChatAuditLogEntryModel.fromMap(Map<String, dynamic> m) {
    final idVal = m['id'];
    int? id;
    if (idVal is num) id = idVal.toInt();

    final incident = _firstStr(m, const [
      'incident_code',
      'code',
      'reference',
      'title',
      'event',
      'label',
      'name',
    ]);

    final original = _firstStr(m, const [
      'original_message',
      'original_text',
      'original',
      'draft_text',
      'before',
      'redacted_text',
    ]);

    final revised = _firstStr(m, const [
      'ai_suggestion',
      'revised_text',
      'revised',
      'sent_text',
      'after',
      'final_text',
    ]);

    final at = _firstDynamic(m, const [
      'created_at',
      'occurred_at',
      'at',
      'timestamp',
      'date',
    ]);

    final fallbackIncident = _fallbackIncidentLabel(m);

    return ChatAuditLogEntryModel(
      id: id,
      incidentLabel: incident.isNotEmpty ? incident : fallbackIncident,
      occurredAt: _parseDate(at),
      originalText: original,
      revisedText: revised,
    );
  }

  static String _fallbackIncidentLabel(Map<String, dynamic> m) {
    final msgId = m['workspace_chat_message_id'];
    if (msgId is num && msgId.toInt() > 0) {
      return '#${msgId.toInt()}';
    }
    final logId = m['id'];
    if (logId is num) {
      return '#${logId.toInt()}';
    }
    return '';
  }

  ChatAuditLogEntry toEntity() => ChatAuditLogEntry(
        id: id,
        incidentLabel: incidentLabel,
        occurredAt: occurredAt,
        originalText: originalText,
        revisedText: revisedText,
      );

  static String _firstStr(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final s = _str(m[k]);
      if (s.isNotEmpty) return s;
    }
    return '';
  }

  static dynamic _firstDynamic(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v != null) return v;
    }
    return null;
  }
}

List<Map<String, dynamic>> _logRowsFromJson(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is List) {
    return data.map(_asMap).where((e) => e.isNotEmpty).toList();
  }
  if (data is Map<String, dynamic>) {
    for (final key in const ['data', 'items', 'logs', 'entries']) {
      final inner = data[key];
      if (inner is List) {
        return inner.map(_asMap).where((e) => e.isNotEmpty).toList();
      }
    }
  }
  return const [];
}

class ChatAuditLogResponseModel {
  const ChatAuditLogResponseModel({required this.entries});

  final List<ChatAuditLogEntryModel> entries;

  factory ChatAuditLogResponseModel.fromResponse(Map<String, dynamic> json) {
    final rows = _logRowsFromJson(json);
    return ChatAuditLogResponseModel(
      entries: rows.map(ChatAuditLogEntryModel.fromMap).toList(),
    );
  }

  List<ChatAuditLogEntry> toEntities() => entries.map((e) => e.toEntity()).toList();
}
