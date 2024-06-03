import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_media_picker/flutter_media_picker_platform_interface.dart';
import 'package:flutter_media_picker/flutter_media_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMediaPickerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMediaPickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMediaPickerPlatform initialPlatform = FlutterMediaPickerPlatform.instance;

  test('$MethodChannelFlutterMediaPicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMediaPicker>());
  });

  test('getPlatformVersion', () async {
    FlutterMediaPicker flutterMediaPickerPlugin = FlutterMediaPicker();
    MockFlutterMediaPickerPlatform fakePlatform = MockFlutterMediaPickerPlatform();
    FlutterMediaPickerPlatform.instance = fakePlatform;

    expect(await flutterMediaPickerPlugin.getPlatformVersion(), '42');
  });
}
