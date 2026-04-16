import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:masr_al_qsariya/core/methods/download_file.dart';

class ConvertNetworkFiles {
  static bool isImageLink(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {return false;}
    return true;
  }

  static Future<MultipartFile> convertFileToMultipartFile({required String path}) async{
    if(isImageLink(path)){path = await DownloadFile.saveImage(path);}
    return await MultipartFile.fromFile(path, filename: path.split('/').last, contentType: MediaType.parse(lookupMimeType(path) ?? 'application/octet-stream'));
  }
}