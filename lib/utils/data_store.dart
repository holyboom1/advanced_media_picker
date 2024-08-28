part of '../advanced_media_picker_impl.dart';

/// Plugin data store
final class DataStore {
  /// Data store
  DataStore({
    required this.style,
    required this.cameraStyle,
    required this.pickerController,
    required this.openCameraPermissionSettings,
  });

  /// Main completer
  final Completer<List<XFile>> mainCompleter = Completer<List<XFile>>();

  /// Picker controller
  final PickerController pickerController;

  /// Picker style
  final PickerStyle style;

  /// Camera style
  final CameraStyle cameraStyle;

  /// Open permission settings
  final VoidCallback openCameraPermissionSettings;

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

  ValueNotifier<bool> isPreviewOpen = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPreviewCameraReady = ValueNotifier<bool>(false);

  late CameraController cameraController;

  Future<void> initCameras() async {
    final List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
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
