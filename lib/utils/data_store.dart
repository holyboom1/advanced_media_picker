part of '../advanced_media_picker_impl.dart';

class DataStore {
  PickerStyle style = PickerStyle();
  CameraStyle cameraStyle = CameraStyle();

  final int sizePerPage = 20;

  Map<String, int> totalEntitiesCount = <String, int>{};
  Map<String, int> pages = <String, int>{};
  Map<String, bool> hasMoreToLoad = <String, bool>{};

  ValueNotifier<AssetPathEntity?> selectedPath = ValueNotifier<AssetPathEntity?>(null);
  ValueNotifier<List<AssetPathEntity>> availablePath =
      ValueNotifier<List<AssetPathEntity>>(<AssetPathEntity>[]);
  Map<String, ValueNotifier<List<AssetEntity>>> pathData =
      <String, ValueNotifier<List<AssetEntity>>>{};
  ValueNotifier<List<AssetEntity>> selectedAssets =
      ValueNotifier<List<AssetEntity>>(<AssetEntity>[]);

  int limitToSelection = -1;
  int maxVideoDuration = -1;
  bool isNeedToShowCamera = true;
  bool isNeedToTakeVideo = true;

  ValueNotifier<FlashMode> flashModeNotifier = ValueNotifier<FlashMode>(FlashMode.off);
  CameraController? cameraController;
  ValueNotifier<bool> isCameraReady = ValueNotifier<bool>(false);
  ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPreviewOpen = ValueNotifier<bool>(false);

  List<CameraDescription> cameras = <CameraDescription>[];
  ValueNotifier<List<XFile>> capturedAssets = ValueNotifier<List<XFile>>(<XFile>[]);
}
