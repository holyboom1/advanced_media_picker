import 'package:flutter/material.dart';

class CameraStyle {
  final Widget cameraCloseIcon;

  final Widget takePictureIcon;

  final Widget chooseCameraIcon;

  final Widget cameraBackButton;

  final Widget cameraAddMediaButton;

  final Widget cameraDeleteMediaButton;

  final Widget cameraSelectedMediaButton;

  final Widget cameraIcon;

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
    this.cameraBackButton = const Icon(
      Icons.arrow_back_ios_new,
      color: Colors.white,
    ),
    this.cameraAddMediaButton = const Icon(
      Icons.add,
      color: Colors.white,
    ),
    this.cameraDeleteMediaButton = const Icon(
      Icons.delete,
      color: Colors.white,
    ),
    this.cameraSelectedMediaButton = const Icon(
      Icons.done,
      color: Colors.white,
    ),
    this.cameraIcon = const Icon(
      Icons.video_call_rounded,
      color: Colors.white,
    ),
  });
}
