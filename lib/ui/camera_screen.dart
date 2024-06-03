part of '../flutter_media_picker_impl.dart';

class CameraScreen extends StatefulWidget {
  final CameraStyle style;

  const CameraScreen({
    super.key,
    required this.style,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

ValueNotifier<FlashMode> flashModeNotifier = ValueNotifier<FlashMode>(FlashMode.off);
CameraController? cameraController;
ValueNotifier<bool> isCameraReady = ValueNotifier<bool>(false);
ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    flashModeNotifier.addListener(onChangeFlashMode);
    isCameraReady.value = true;
  }

  @override
  void dispose() {
    cameraController?.setFlashMode(FlashMode.off);
    flashModeNotifier.removeListener(onChangeFlashMode);
    super.dispose();
  }

  void onChangeFlashMode() {
    switch (flashModeNotifier.value) {
      case FlashMode.off:
        cameraController!.setFlashMode(FlashMode.off);
        break;
      case FlashMode.torch:
        cameraController!.setFlashMode(FlashMode.torch);
        break;
      case FlashMode.auto:
        cameraController!.setFlashMode(FlashMode.auto);
        break;
      case FlashMode.always:
        cameraController!.setFlashMode(FlashMode.always);
        break;
    }
  }

  Future<void> takePicture() async {
    if (limitToSelection != -1 && _capturedImages.value.length >= limitToSelection) {
      return;
    }
    if (cameraController != null && !isRecording.value) {
      final XFile file = await cameraController!.takePicture();
      _capturedImages.value = <XFile>[
        ..._capturedImages.value,
        file,
      ];
    } else if (isRecording.value) {
      final XFile file = await cameraController!.stopVideoRecording();
      isRecording.value = false;
      _capturedVideos.value = <XFile>[
        ..._capturedVideos.value,
        file,
      ];
    }
  }

  Future<void> takeVideo() async {
    if (limitToSelection != -1 && _capturedVideos.value.length >= limitToSelection) {
      return;
    }
    if (cameraController != null) {
      if (isRecording.value) {
        final XFile file = await cameraController!.stopVideoRecording();
        isRecording.value = false;
        _capturedVideos.value = <XFile>[
          ..._capturedVideos.value,
          file,
        ];
      } else {
        isRecording.value = true;
        await cameraController!.startVideoRecording();
      }
    }
  }

  void flipCamera() {
    if (cameraController != null) {
      isCameraReady.value = false;
      if (cameraController!.description.lensDirection == CameraLensDirection.front) {
        cameraController = CameraController(
          _cameras.firstWhere(
            (CameraDescription element) => element.lensDirection == CameraLensDirection.back,
          ),
          ResolutionPreset.medium,
        )..initialize().then((_) {
            isCameraReady.value = true;
          });
      } else {
        cameraController = CameraController(
          _cameras.firstWhere(
            (CameraDescription element) => element.lensDirection == CameraLensDirection.front,
          ),
          ResolutionPreset.medium,
        )..initialize().then((_) {
            isCameraReady.value = true;
          });
      }
    }
  }

  void onZoom() {
    if (cameraController != null) {
      cameraController!.setZoomLevel(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          const CameraPreviewWidget(),
          ValueListenableBuilder<bool>(
            valueListenable: isCameraReady,
            builder: (BuildContext context, bool value, Widget? child) {
              if (cameraController!.description.lensDirection != CameraLensDirection.front &&
                  _cameras.length > 2) return const SelectCameraLens();
              return Container();
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
                      valueListenable: isRecording,
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
                    )),
                IconButton(
                  icon: const Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                  ),
                  onPressed: flipCamera,
                ),
              ],
            ),
          ),
          Positioned(
            top: 42,
            right: 22,
            child: IconButton(
              icon: widget.style.cameraCloseIcon,
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
