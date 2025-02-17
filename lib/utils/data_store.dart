part of '../advanced_media_picker_impl.dart';

/// Plugin data store
final class DataStore {
  /// Data store
  DataStore({
    required this.style,
    required this.cameraStyle,
    required this.pickerController,
    required this.onCameraPermissionDeniedCallback,
    required this.enableAudio,
  });

  /// Main completer
  final Completer<List<XFile>> mainCompleter = Completer<List<XFile>>();

  /// Main completer for advancedPicker
  final Completer<({List<XFile> assets, bool needMirrorPhoto})> advancedPickerCompleter =
      Completer<({List<XFile> assets, bool needMirrorPhoto})>();

  /// Main completer for assets picker
  final Completer<List<AssetModel>> mainAssetsCompleter = Completer<List<AssetModel>>();

  /// Stream controller for the data store
  final StreamController<List<XFile>> streamController = StreamController<List<XFile>>();

  /// Picker controller
  final PickerController pickerController;

  /// Picker style
  final PickerStyle style;

  /// Camera style
  final CameraStyle cameraStyle;

  /// Open permission settings
  final VoidCallback onCameraPermissionDeniedCallback;

  /// Enable audio - if true will request permission to microphone
  final bool enableAudio;

  List<String> allowedTypes = <String>[];
  final int sizePerPage = 10;

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
  bool isNeedToShowAlert = true;
  bool isNeedToToggleDirectories = true;

  ValueNotifier<bool> isPreviewOpen = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPreviewCameraReady = ValueNotifier<bool>(false);

  late CameraController cameraController;

  /// Initialize camera
  Future<void> initCameras() async {
    final List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );
    unawaited(cameraController.setFlashMode(FlashMode.off));

    try {
      await cameraController.initialize().then((_) {
        isPreviewCameraReady.value = true;
      });
    } catch (_) {
      isPreviewCameraReady.value = false;
    }
  }

  Future<void> dispose() async {
    await cameraController.dispose();
  }
}
