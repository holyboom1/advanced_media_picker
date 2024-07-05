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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<List<XFile>>(
              valueListenable: selectedFiles,
              builder:
                  (BuildContext context, List<XFile> value, Widget? child) {
                return Column(
                  children: value.map((XFile file) {
                    return Text(file.path);
                  }).toList(),
                );
              },
            ),
            MyButton(),
          ],
        ),
      ),
    );
  }
}

final ValueNotifier<List<XFile>> selectedFiles =
    ValueNotifier<List<XFile>>(<XFile>[]);

class MyButton extends StatelessWidget {
  MyButton({super.key});

  final PickerController controller = PickerController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Open Picker'),
        onPressed: () async {
          final List<XFile> result = await AdvancedMediaPicker.openPicker(
            context: context,
            controller: controller,
            style: PickerStyle(),
            cameraStyle: CameraStyle(),
            allowedTypes: PickerAssetType.imageAndVideo,
            maxVideoDuration: 60,
            selectionLimit: 10,
          );
          print('#result# : $result');
          selectedFiles.value = result;
        },
      ),
    );
  }
}
