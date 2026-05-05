import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/messages/data/models/chat_audit_log_entry_model.dart';
import 'package:masr_al_qsariya/features/messages/data/models/chat_message_model.dart';
import 'package:masr_al_qsariya/features/messages/data/models/chat_tone_insights_model.dart';
import 'package:mime/mime.dart';

abstract class MessagesRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchChatThreads(int workspaceId);

  Future<List<ChatMessageModel>> fetchChatMessages(
    int workspaceId,
    int chatId,
  );

  Future<int?> sendChatMessage(
    int workspaceId,
    int chatId,
    String? body,
    List<String> attachmentPaths,
  );

  Future<void> logChatModerationDecision({
    required int workspaceId,
    required int chatId,
    required int workspaceChatMessageId,
    required bool suggestionAccepted,
    required String originalMessage,
    String? aiSuggestion,
  });

  Future<Uint8List> downloadChatAttachment(
    int workspaceId,
    int chatId,
    int attachmentId,
  );

  Future<ChatToneInsightsModel> fetchChatToneInsights(
    int workspaceId,
    int chatId,
  );

  Future<ChatAuditLogResponseModel> fetchChatAuditLogs(
    int workspaceId,
    int chatId,
  );
}

List<Map<String, dynamic>> _mapListFromJson(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is List) {
    return data.whereType<Map<String, dynamic>>().toList();
  }
  if (data is Map<String, dynamic>) {
    final inner = data['data'];
    if (inner is List) {
      return inner.whereType<Map<String, dynamic>>().toList();
    }
  }
  return [];
}

class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  const MessagesRemoteDataSourceImpl(this._api);

  final ApiBaseHelper _api;

  @override
  Future<List<Map<String, dynamic>>> fetchChatThreads(int workspaceId) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceChats(workspaceId),
    );
    return _mapListFromJson(response);
  }

  @override
  Future<List<ChatMessageModel>> fetchChatMessages(
    int workspaceId,
    int chatId,
  ) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceChatMessages(workspaceId, chatId),
    );
    return _mapListFromJson(response)
        .map(ChatMessageModel.fromMap)
        .toList();
  }

  @override
  Future<int?> sendChatMessage(
    int workspaceId,
    int chatId,
    String? body,
    List<String> attachmentPaths,
  ) async {
    final formData = FormData();
    if (body != null && body.trim().isNotEmpty) {
      formData.fields.add(MapEntry('body', body.trim()));
    }

    // Backend validation expects `attachments` as an array.
    // Send as repeated `attachments[]` parts.
    for (final path in attachmentPaths) {
      final mime = lookupMimeType(path);
      final file = await MultipartFile.fromFile(
        path,
        contentType: mime != null ? DioMediaType.parse(mime) : null,
      );
      formData.files.add(MapEntry('attachments[]', file));
    }

    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceChatMessages(workspaceId, chatId),
      formData: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final id = data['id'];
      if (id is num) return id.toInt();
    }
    return null;
  }

  @override
  Future<void> logChatModerationDecision({
    required int workspaceId,
    required int chatId,
    required int workspaceChatMessageId,
    required bool suggestionAccepted,
    required String originalMessage,
    String? aiSuggestion,
  }) async {
    final formData = FormData.fromMap({
      'workspace_chat_message_id': workspaceChatMessageId.toString(),
      'suggestion_accepted': suggestionAccepted ? '1' : '0',
      'original_message': originalMessage,
      'ai_suggestion': aiSuggestion,
    });

    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceChatModerationLogs(workspaceId, chatId),
      formData: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<Uint8List> downloadChatAttachment(
    int workspaceId,
    int chatId,
    int attachmentId,
  ) {
    return _api.getBytes(
      url: AppEndpoints.workspaceChatAttachmentDownload(
        workspaceId,
        chatId,
        attachmentId,
      ),
    );
  }

  @override
  Future<ChatToneInsightsModel> fetchChatToneInsights(
    int workspaceId,
    int chatId,
  ) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceChatTone(workspaceId, chatId),
    );
    return ChatToneInsightsModel.fromResponse(response);
  }

  @override
  Future<ChatAuditLogResponseModel> fetchChatAuditLogs(
    int workspaceId,
    int chatId,
  ) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceChatLogs(workspaceId, chatId),
    );
    return ChatAuditLogResponseModel.fromResponse(response);
  }
}
