import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoFileFormatter {
  static Future<Uint8List?> getUint8List(File? videoFile) async {
    if (videoFile != null) {
      final Uint8List? uint8list = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.WEBP,
      );
      return uint8list;
    } else {
      return null;
    }
  }
}
