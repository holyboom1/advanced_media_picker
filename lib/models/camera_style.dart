import 'package:flutter/material.dart';

class CameraStyle {
  final Widget cameraCloseIcon;

  final Widget takePictureIcon;

  final Widget chooseCameraIcon;
  CameraStyle({
    this.cameraCloseIcon = const Icon(
      Icons.close,
      color: Colors.white,
    ),
    this.takePictureIcon = const Icon(
      Icons.camera,
      color: Colors.white,
    ),
    this.chooseCameraIcon = const Icon(
      Icons.camera_alt,
      color: Colors.white,
    ),
  });
}
