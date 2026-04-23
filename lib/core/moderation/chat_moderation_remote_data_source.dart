import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:mime/mime.dart';

abstract class ChatModerationRemoteDataSource {
  Future<Map<String, dynamic>> review({
    String? text,
    List<String> attachmentPaths,
  });
}

class ChatModerationRemoteDataSourceImpl implements ChatModerationRemoteDataSource {
  const ChatModerationRemoteDataSourceImpl(this._api);

  final ApiBaseHelper _api;

  @override
  Future<Map<String, dynamic>> review({
    String? text,
    List<String> attachmentPaths = const [],
  }) async {
    final formData = FormData();
    if (text != null && text.trim().isNotEmpty) {
      formData.fields.add(MapEntry('text', text.trim()));
    }

    for (final path in attachmentPaths) {
      final mime = lookupMimeType(path);
      final file = await MultipartFile.fromFile(
        path,
        contentType: mime != null ? DioMediaType.parse(mime) : null,
      );
      formData.files.add(MapEntry('attachments[]', file));
    }

    return _api.post<Map<String, dynamic>>(
      url: AppEndpoints.chatModerationReview,
      formData: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}

