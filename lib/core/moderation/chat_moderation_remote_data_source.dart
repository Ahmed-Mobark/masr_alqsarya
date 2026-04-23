abstract class ChatModerationRemoteDataSource {
  Future<Map<String, dynamic>> review({
    String? text,
    List<String> attachmentPaths,
  });
}
