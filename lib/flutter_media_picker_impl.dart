import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import 'flutter_media_picker.dart';
import 'models/camera_style.dart';
import 'ui/camera/camera_preview.dart';
import 'ui/camera/flash_mode_button.dart';
import 'ui/shimmer.dart';

part 'models/assets_type.dart';
part 'ui/asset_widget.dart';
part 'ui/camera/select_camera_lens.dart';
part 'ui/camera_screen.dart';
part 'ui/camera_view.dart';
part 'ui/content_view.dart';
part 'ui/directory_widget.dart';
part 'ui/picker_bottom_sheet.dart';

final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
  imageOption: const FilterOption(),
  audioOption: const FilterOption(),
  videoOption: const FilterOption(),
);

const int _sizePerPage = 20;

Map<String, int> _totalEntitiesCount = <String, int>{};
Map<String, int> _pages = <String, int>{};
Map<String, bool> _hasMoreToLoad = <String, bool>{};

ValueNotifier<AssetPathEntity?> _selectedPath = ValueNotifier<AssetPathEntity?>(null);
ValueNotifier<List<AssetPathEntity>> _availablePath =
    ValueNotifier<List<AssetPathEntity>>(<AssetPathEntity>[]);
final Map<String, ValueNotifier<List<AssetEntity>>> pathData =
    <String, ValueNotifier<List<AssetEntity>>>{};
ValueNotifier<List<AssetEntity>> _selectedAssets =
    ValueNotifier<List<AssetEntity>>(<AssetEntity>[]);

List<CameraDescription> _cameras = <CameraDescription>[];

ValueNotifier<List<XFile>> _capturedImages = ValueNotifier<List<XFile>>(<XFile>[]);
ValueNotifier<List<XFile>> _capturedVideos = ValueNotifier<List<XFile>>(<XFile>[]);

int limitToSelection = -1;
int videoDuration = -1;
bool isNeedToShowCamera = true;
bool isNeedToTakeVideo = true;

Future<List<XFile>> onClose() async {
  final List<XFile> assets = <XFile>[..._capturedImages.value, ..._capturedVideos.value];
  await Future.forEach(_selectedAssets.value, (AssetEntity element) async {
    final File? file = await element.file;
    if (file != null) {
      assets.add(XFile(file.path));
    }
  });
  _selectedAssets.value.clear();
  _availablePath.value.clear();
  _capturedImages.value.clear();
  _capturedVideos.value.clear();

  return assets;
}

void onOnSelectAsset(AssetEntity asset) {
  if (_selectedAssets.value.contains(asset)) {
    _selectedAssets.value = <AssetEntity>[..._selectedAssets.value]..remove(asset);
  } else {
    if (limitToSelection != -1 && _selectedAssets.value.length >= limitToSelection) {
      return;
    }
    _selectedAssets.value = <AssetEntity>[..._selectedAssets.value, asset];
  }
}

Future<void> loadMoreAsset({
  required AssetPathEntity path,
}) async {
  final int page = _pages[path.id]! + 1;
  final List<AssetEntity> entities = await path.getAssetListPaged(
    page: page,
    size: _sizePerPage,
  );
  pathData[path.id]!.value = <AssetEntity>[...pathData[path.id]!.value, ...entities];
  _pages[path.id] = page;
  _hasMoreToLoad[path.id] = entities.length < _totalEntitiesCount[path.id]!;
}

Future<void> getAssetsPath({
  required PickerAssetType allowedTypes,
}) async {
  _availablePath.value = await PhotoManager.getAssetPathList(
    type: allowedTypes.toRequestType,
    filterOption: _filterOptionGroup,
  );

  final Completer<void> completer = Completer<void>();
  if (_availablePath.value.isNotEmpty) {
    unawaited(Future.forEach(_availablePath.value, (AssetPathEntity element) async {
      pathData[element.id] = ValueNotifier<List<AssetEntity>>(<AssetEntity>[]);
      final List<AssetEntity> entities = await element.getAssetListPaged(
        page: 0,
        size: _sizePerPage,
      );
      pathData[element.id]!.value = entities;
      _totalEntitiesCount[element.id] = await element.assetCountAsync;
      _pages[element.id] = 0;
      _hasMoreToLoad[element.id] = entities.length < _totalEntitiesCount[element.id]!;
      if (element == _availablePath.value.first) {
        _selectedPath.value = element;
        completer.complete();
      }
    }));

    return completer.future;
  }
}

Future<bool> requestPermissions() async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  if (!ps.hasAccess) {
    return false;
  }
  return true;
}
