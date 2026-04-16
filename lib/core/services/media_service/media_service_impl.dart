import 'dart:io';
import 'dart:math';
import 'package:masr_al_qsariya/core/enums/media_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'media_services.dart';

class MediaServiceImpl implements MediaService {
  @override
  Future<File?> uploadImage(BuildContext context, AppImageSource appImageSource) async {
    try {
      File? processedPickedImageFile;
      ImageSource? imageSource = ImageSource.values.byName(appImageSource.name);
      final imagePicker = ImagePicker();
      final rawPickedImageFile = await imagePicker.pickImage(source: imageSource, imageQuality: 50);
      if (rawPickedImageFile != null) {
        processedPickedImageFile = File(rawPickedImageFile.path);
        processedPickedImageFile = await compressFile(processedPickedImageFile);
        return processedPickedImageFile;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<File?>?> uploadMultiImage(BuildContext context) async {
    try {
      List<File?> pickedImageFiles = [];
      final imagePicker = ImagePicker();
      final rawPickedImageFiles = await imagePicker.pickMultiImage(imageQuality: 50);
      if (rawPickedImageFiles.isNotEmpty) {
        pickedImageFiles.clear();
        for (var file in rawPickedImageFiles) {
          final processedPickedImageFile = await compressFile(File(file.path));
          pickedImageFiles.add(processedPickedImageFile);
        }
        return pickedImageFiles;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<File?>?> uploadFiles(BuildContext context) async {
    try {
      List<File?> pickedFiles = [];
      final rawPickedFiles = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.any);
      if (rawPickedFiles != null && rawPickedFiles.paths.isNotEmpty) {
        pickedFiles.clear();
        for (var path in rawPickedFiles.paths) {
          String extension = path!.split('.').last.toLowerCase();
          if(extension == 'png' || extension == 'jpg' || extension == 'jpeg' || extension == 'heic'){
            final processedPickedFile = await compressFile(File(path));
            pickedFiles.add(processedPickedFile);
          } else {
            pickedFiles.add(File(path));
          }
        }
        return pickedFiles;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<File?> compressFile(File file, {int quality = 30}) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/${Random().nextInt(1000)}-temp.jpg';
    XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(file.absolute.path, targetPath, quality: quality);
    File? compressedFile = compressedXFile != null? File(compressedXFile.path) : null;
    return compressedFile;
  }
}