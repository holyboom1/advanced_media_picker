part of '../flutter_media_picker_impl.dart';

class CameraView extends StatefulWidget {
  final PickerStyle style;
  final CameraStyle? cameraStyle;

  const CameraView({
    super.key,
    required this.style,
    required this.cameraStyle,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
    )..initialize().then((_) {
        if (!mounted) {
          return;
        }
        cameraController?.setFocusMode(FocusMode.auto);
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null) {
      return Container();
    }
    if (!cameraController!.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            barrierColor: Colors.black26,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ),
                ),
                child: CameraScreen(
                  style: widget.cameraStyle ?? CameraStyle(),
                ),
              );
            },
            opaque: false,
            fullscreenDialog: true,
            barrierDismissible: true,
            pageBuilder: (_, __, ___) => CameraScreen(
              style: widget.cameraStyle ?? CameraStyle(),
            ),
          ),
        );
      },
      child: Container(
        decoration: widget.style.cameraContainerDecoration,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CameraPreview(cameraController!),
            ),
            Positioned.fill(
              child: Center(
                child: widget.style.cameraIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
