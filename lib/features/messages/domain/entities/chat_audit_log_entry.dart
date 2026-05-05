import 'package:equatable/equatable.dart';

class ChatAuditLogEntry extends Equatable {
  const ChatAuditLogEntry({
    this.id,
    required this.incidentLabel,
    required this.occurredAt,
    required this.originalText,
    required this.revisedText,
  });

  final int? id;

  /// Header line (incident code, event name, etc.).
  final String incidentLabel;

  final DateTime? occurredAt;
  final String originalText;
  final String revisedText;

  @override
  List<Object?> get props => [
        id,
        incidentLabel,
        occurredAt,
        originalText,
        revisedText,
      ];
}
