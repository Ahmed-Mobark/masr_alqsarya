import 'package:masr_al_qsariya/features/home/domain/entities/home_awaiting_call.dart';

class HomeAwaitingCallModel {
  const HomeAwaitingCallModel({
    required this.id,
    required this.status,
    required this.createdByName,
    this.scheduledStartsAt,
    this.workspaceId,
    this.workspaceName,
  });

  final int id;
  final String status;
  final DateTime? scheduledStartsAt;
  final String createdByName;
  final int? workspaceId;
  final String? workspaceName;

  factory HomeAwaitingCallModel.fromJson(Map<String, dynamic> json) {
    final root = Map<String, dynamic>.from(json);
    final itemRaw = root['item'];
    final item = itemRaw is Map<String, dynamic>
        ? itemRaw
        : (itemRaw is Map ? Map<String, dynamic>.from(itemRaw) : <String, dynamic>{});

    return HomeAwaitingCallModel(
      id: _readInt(item, const ['id']) ?? 0,
      status: _readString(item, const ['status']) ?? '',
      createdByName: _readString(item, const ['created_by_name']) ?? '',
      scheduledStartsAt:
          _readDate(item, const ['scheduled_starts_at']) ?? _readDate(root, const ['occurred_at']),
      workspaceId: _readInt(item, const ['workspace_id']),
      workspaceName: _readString(item, const ['workspace_name']),
    );
  }

  HomeAwaitingCall toEntity() => HomeAwaitingCall(
        id: id,
        status: status,
        scheduledStartsAt: scheduledStartsAt,
        createdByName: createdByName,
        workspaceId: workspaceId,
        workspaceName: workspaceName,
      );

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static DateTime? _readDate(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        final parsed = DateTime.tryParse(value.trim());
        if (parsed != null) return parsed.toLocal();
      }
    }
    return null;
  }
}
