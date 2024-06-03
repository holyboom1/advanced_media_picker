part of '../flutter_media_picker_impl.dart';

enum PickerAssetType {
  other,
  all,
  image,
  imageAndVideo,
  video,
  audio;

  static PickerAssetType fromRequestType(RequestType value) {
    switch (value) {
      case RequestType.image:
        return PickerAssetType.image;
      case RequestType.video:
        return PickerAssetType.video;
      case RequestType.audio:
        return PickerAssetType.audio;
      case RequestType.common:
        return PickerAssetType.imageAndVideo;
      default:
        return PickerAssetType.all;
    }
  }

  RequestType get toRequestType {
    switch (this) {
      case PickerAssetType.image:
        return RequestType.image;
      case PickerAssetType.video:
        return RequestType.video;
      case PickerAssetType.audio:
        return RequestType.audio;
      case PickerAssetType.imageAndVideo:
        return RequestType.common;
      default:
        return RequestType.all;
    }
  }
}
