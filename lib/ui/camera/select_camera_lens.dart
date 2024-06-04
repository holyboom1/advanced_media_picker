part of '../../advanced_media_picker_impl.dart';

class SelectCameraLens extends StatefulWidget {
  const SelectCameraLens({super.key});

  @override
  State<SelectCameraLens> createState() => _SelectCameraLensState();
}

class _SelectCameraLensState extends State<SelectCameraLens> with SingleTickerProviderStateMixin {
  int selectedCameraIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 170,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ..._cameras.map((CameraDescription camera) {
                  if (camera.lensDirection == CameraLensDirection.front) {
                    return Container();
                  }
                  final int cameraIndex = _cameras.indexOf(camera);
                  final bool isSelected = cameraIndex == selectedCameraIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCameraIndex = cameraIndex;
                        _animationController.forward();
                      });
                      isCameraReady.value = false;
                      cameraController = CameraController(
                        camera,
                        ResolutionPreset.medium,
                      )..initialize().then((_) {
                          isCameraReady.value = true;
                        });
                    },
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.scale(
                          scale: isSelected ? _animation.value : 1.0,
                          child: child,
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 32,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isSelected ? Colors.white.withOpacity(0.5) : Colors.transparent,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
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
