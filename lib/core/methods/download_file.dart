import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile {
  static Future<String?> downloadPdf({required String url}) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/event-masters-${DateTime.now().millisecondsSinceEpoch}.pdf';
      await sl<Dio>().download(url, filePath);
      return filePath;
    } catch (error) {
      return null;
    }
  }


  static Future<String?> convertToPdf({required String data}) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/event-masters-${DateTime.now().millisecondsSinceEpoch}.pdf';

      List<int> pdfBytes = base64Decode(data);
      
      File file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      return filePath;
      
    } catch (error) {
      return null;
    }
  }



  static Future<String> saveImage(String imageUrl) async {
    Directory directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/remontada-${DateTime.now().millisecondsSinceEpoch}.png';
    File file = File(filePath);
    final response = await sl<Dio>().get(imageUrl, options: Options(responseType: ResponseType.bytes));
    await file.writeAsBytes(response.data);
    return filePath;
  }
}

