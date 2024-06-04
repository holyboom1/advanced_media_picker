extension FileTypeExtension on String {
  bool isPicture() =>
      toLowerCase().endsWith('.svg') ||
      toLowerCase().endsWith('.png') ||
      toLowerCase().endsWith('.jpg') ||
      toLowerCase().endsWith('.jpeg') ||
      toLowerCase().endsWith('.gif') ||
      toLowerCase().endsWith('.webp');

  bool isVideo() =>
      toLowerCase().endsWith('.mp4') ||
      toLowerCase().endsWith('.mov') ||
      toLowerCase().endsWith('.avi') ||
      toLowerCase().endsWith('.flv') ||
      toLowerCase().endsWith('.wmv');
}
