import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const MyButton(),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Open Picker'),
        onPressed: () async {
          final List<XFile> result = await AdvancedMediaPicker.openPicker(
              context: context,
              style: PickerStyle(),
              cameraStyle: CameraStyle(),
              allowedTypes: PickerAssetType.image,
              maxVideoDuration: 60,
              selectionLimit: 10,
              showCamera: true,
              videoCamera: true);
        },
      ),
    );
  }
}
