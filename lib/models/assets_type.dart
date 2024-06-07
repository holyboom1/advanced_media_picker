part of '../advanced_media_picker_impl.dart';

/// Picker asset type
enum PickerAssetType {
  /// All assets
  other,

  /// All assets
  all,

  /// Image assets
  image,

  /// Video assets
  imageAndVideo,

  /// Audio assets
  video,

  /// Audio assets
  audio;

  /// Create picker asset type from request type
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

  /// Get request type
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
