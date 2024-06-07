part of '../../advanced_media_picker_impl.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    dataStore.flashModeNotifier.addListener(onChangeFlashMode);
    dataStore.isCameraReady.value = true;
  }

  @override
  void dispose() {
    dataStore.cameraController?.setFlashMode(FlashMode.off);
    dataStore.flashModeNotifier.removeListener(onChangeFlashMode);
    super.dispose();
  }

  void onChangeFlashMode() {
    switch (dataStore.flashModeNotifier.value) {
      case FlashMode.off:
        dataStore.cameraController!.setFlashMode(FlashMode.off);
        break;
      case FlashMode.torch:
        dataStore.cameraController!.setFlashMode(FlashMode.torch);
        break;
      case FlashMode.auto:
        dataStore.cameraController!.setFlashMode(FlashMode.auto);
        break;
      case FlashMode.always:
        dataStore.cameraController!.setFlashMode(FlashMode.always);
        break;
    }
  }

  Future<void> navigateToMediaScreen(String filePath, [bool? isLimitReached]) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MediaScreen(
          filePath: filePath,
          isLimitReached: isLimitReached ?? false,
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    if (dataStore.limitToSelection != -1 &&
        dataStore.selectedAssets.value.length >= dataStore.limitToSelection) {
      return;
    }
    final XFile file;
    if (dataStore.cameraController != null && !dataStore.isRecording.value) {
      file = await dataStore.cameraController!.takePicture();
    } else {
      file = await dataStore.cameraController!.stopVideoRecording();
      dataStore.isRecording.value = false;
    }
    dataStore.selectedAssets.addAsset(AssetModel.fromXFile(file));
    if (dataStore.selectedAssets.value.length == 1) {
      await navigateToMediaScreen(file.path);
    }

    if (dataStore.selectedAssets.value.length >= dataStore.limitToSelection) {
      await navigateToMediaScreen(file.path, true);
    }
  }

  Future<void> takeVideo() async {
    if (dataStore.limitToSelection != -1 &&
        dataStore.selectedAssets.value.length >= dataStore.limitToSelection) {
      return;
    }
    if (dataStore.cameraController != null) {
      if (dataStore.isRecording.value) {
        final XFile file = await dataStore.cameraController!.stopVideoRecording();
        dataStore.isRecording.value = false;
        dataStore.selectedAssets.addAsset(AssetModel.fromXFile(file));
      } else {
        dataStore.isRecording.value = true;
        await dataStore.cameraController!.startVideoRecording();
      }
    }
  }

  void flipCamera() {
    if (dataStore.cameraController != null) {
      dataStore.isCameraReady.value = false;
      if (dataStore.cameraController!.description.lensDirection == CameraLensDirection.front) {
        dataStore.cameraController = CameraController(
          dataStore.cameras.firstWhere(
            (CameraDescription element) => element.lensDirection == CameraLensDirection.back,
          ),
          ResolutionPreset.medium,
        )..initialize().then((_) {
            dataStore.isCameraReady.value = true;
          });
      } else {
        dataStore.cameraController = CameraController(
          dataStore.cameras.firstWhere(
            (CameraDescription element) => element.lensDirection == CameraLensDirection.front,
          ),
          ResolutionPreset.medium,
        )..initialize().then((_) {
            dataStore.isCameraReady.value = true;
          });
      }
    }
  }

  void onZoom() {
    if (dataStore.cameraController != null) {
      dataStore.cameraController!.setZoomLevel(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          const CameraPreviewWidget(),
          MediaPreviewList(),
          ValueListenableBuilder<bool>(
            valueListenable: dataStore.isCameraReady,
            builder: (BuildContext context, bool value, Widget? child) {
              if (dataStore.cameraController!.description.lensDirection !=
                      CameraLensDirection.front &&
                  dataStore.cameras.length > 2) return const SelectCameraLens();
              return Container();
            },
          ),
          ValueListenableBuilder<List<AssetModel>>(
            valueListenable: dataStore.selectedAssets,
            builder: (BuildContext context, List<AssetModel> value, Widget? child) {
              return GestureDetector(
                onTap: () {
                  setState(() {});
                  dataStore.isPreviewOpen.value = !dataStore.isPreviewOpen.value;
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 120, right: 20),
                    child: Visibility(
                      visible: dataStore.selectedAssets.value.isNotEmpty,
                      child: MediaPreviewControlButton(
                        countValue: dataStore.selectedAssets.value.length.toString(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 42,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const FlashModeButton(),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: dataStore.isRecording,
                    builder: (_, bool isRecordingValue, __) {
                      return GestureDetector(
                        onTap: takePicture,
                        onLongPress: takeVideo,
                        child: Icon(
                          isRecordingValue ? Icons.stop : Icons.fiber_manual_record,
                          color: isRecordingValue ? Colors.red : Colors.white,
                          size: 90,
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder<List<AssetModel>>(
                  valueListenable: dataStore.selectedAssets,
                  builder: (BuildContext context, List<AssetModel> value, Widget? child) {
                    return value.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              dataStore.isPreviewOpen.value = false;
                              assetsService.onClose();
                              Navigator.of(context).popUntil((Route route) => route.isFirst);
                            },
                            child: Padding(
                              padding: dataStore.cameraStyle.finishButtonPadding,
                              child: Text(
                                dataStore.cameraStyle.finishButtonTitle,
                                style: dataStore.cameraStyle.finishButtonStyle,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: dataStore.cameraStyle.flipCameraIcon,
                            onPressed: flipCamera,
                          );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 42,
            right: 22,
            child: IconButton(
              icon: dataStore.cameraStyle.cameraCloseIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
