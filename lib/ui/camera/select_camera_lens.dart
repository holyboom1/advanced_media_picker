part of '../../flutter_media_picker_impl.dart';

class SelectCameraLens extends StatefulWidget {
  const SelectCameraLens({super.key});

  @override
  State<SelectCameraLens> createState() => _SelectCameraLensState();
}

class _SelectCameraLensState extends State<SelectCameraLens> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 150,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ..._cameras.map((CameraDescription camera) {
                  if (camera.lensDirection == CameraLensDirection.front) return Container();
                  return GestureDetector(
                    onTap: () {
                      isCameraReady.value = false;
                      cameraController = CameraController(
                        camera,
                        ResolutionPreset.medium,
                      )..initialize().then((_) {
                          isCameraReady.value = true;
                        });
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: camera == cameraController!.description
                                ? Colors.white.withOpacity(0.5)
                                : Colors.transparent,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
