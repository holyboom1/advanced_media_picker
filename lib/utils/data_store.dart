part of '../advanced_media_picker_impl.dart';

/// Plugin data store
final class DataStore {
  /// Data store
  DataStore({
    required this.style,
    required this.cameraStyle,
    required this.pickerController,
  });

  /// Main completer
  final Completer<List<XFile>> mainCompleter = Completer<List<XFile>>();

  /// Picker controller
  final PickerController pickerController;

  /// Picker style
  final PickerStyle style;

  /// Camera style
  final CameraStyle cameraStyle;

  List<String> allowedTypes = <String>[];
  final int sizePerPage = 20;

  Map<String, int> totalEntitiesCount = <String, int>{};
  Map<String, int> pages = <String, int>{};
  Map<String, bool> hasMoreToLoad = <String, bool>{};

  ValueNotifier<AssetPathEntity?> selectedPath = ValueNotifier<AssetPathEntity?>(null);
  ValueNotifier<List<AssetPathEntity>> availablePath =
      ValueNotifier<List<AssetPathEntity>>(<AssetPathEntity>[]);
  Map<String, ValueNotifier<List<AssetEntity>>> pathData =
      <String, ValueNotifier<List<AssetEntity>>>{};
  ValueNotifier<List<AssetModel>> selectedAssets = ValueNotifier<List<AssetModel>>(<AssetModel>[]);

  int limitToSelection = -1;
  int maxVideoDuration = -1;
  bool isNeedToShowCamera = true;
  bool isNeedToTakeVideo = true;
  bool isNeedToShowFolders = true;

  ValueNotifier<FlashMode> flashModeNotifier = ValueNotifier<FlashMode>(FlashMode.off);
  CameraController? cameraController;
  ValueNotifier<bool> isCameraReady = ValueNotifier<bool>(false);
  ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPreviewOpen = ValueNotifier<bool>(false);

  List<CameraDescription> cameras = <CameraDescription>[];
}
