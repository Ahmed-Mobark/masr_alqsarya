import 'dart:typed_data';

import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/messages/data/models/chat_message_model.dart';

abstract class MessagesRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchChatThreads(int workspaceId);

  Future<List<ChatMessageModel>> fetchChatMessages(
    int workspaceId,
    int chatId,
  );

  Future<void> sendChatMessage(
    int workspaceId,
    int chatId,
    String body,
  );

  Future<Uint8List> downloadChatAttachment(
    int workspaceId,
    int chatId,
    int attachmentId,
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
  Future<void> sendChatMessage(
    int workspaceId,
    int chatId,
    String body,
  ) async {
    await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceChatMessages(workspaceId, chatId),
      body: {'body': body},
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
}
