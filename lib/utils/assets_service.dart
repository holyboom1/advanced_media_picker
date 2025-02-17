part of '../advanced_media_picker_impl.dart';

/// Assets service
class AssetsService {
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup();

  /// close picker and return selected assets to the caller
  Future<void> onClose() async {
    final List<XFile> assets = <XFile>[];
    unawaited(dataStore.pickerController.hide());
    dataStore.selectedAssets.value.forEach((AssetModel element) {
      assets.add(element.file);
    });
    dataStore.selectedAssets.value.clear();
    dataStore.availablePath.value.clear();
    dataStore.mainCompleter.complete(assets);
  }

  /// close picker and return selected AssetModels to the caller
  Future<void> onCloseAssetsPicker() async {
    final List<AssetModel> assets = List.from(dataStore.selectedAssets.value);
    unawaited(dataStore.pickerController.hide());
    dataStore.mainAssetsCompleter.complete(assets);
    dataStore.selectedAssets.value.clear();
    dataStore.availablePath.value.clear();
  }

  /// Select asset
  Future<void> onOnSelectAsset(AssetEntity asset) async {
    final bool isContain = dataStore.selectedAssets.value.containsAsset(asset);
    if (isContain) {
      dataStore.selectedAssets.removeAsset(await AssetModel.fromAssetEntity(asset));
    } else {
      if (dataStore.limitToSelection != -1 &&
          dataStore.selectedAssets.value.length >= dataStore.limitToSelection) {
        return;
      }
      dataStore.selectedAssets.addAsset(await AssetModel.fromAssetEntity(asset));
    }
  }

  /// Select asset and return it to the caller
  Future<void> captureAssetSelection(AssetEntity asset) async {
    dataStore.selectedAssets.value.clear();
    dataStore.selectedAssets.addAsset(await AssetModel.fromAssetEntity(asset));
    final List<XFile> assets = <XFile>[];
    dataStore.selectedAssets.value.forEach((AssetModel element) {
      assets.add(element.file);
    });
    dataStore.selectedAssets.value.clear();
    dataStore.availablePath.value.clear();
    unawaited(dataStore.cameraController.dispose());
    dataStore.isPreviewCameraReady.value = false;
    dataStore.advancedPickerCompleter.complete((
      assets: assets,
      needMirrorPhoto: false,
    ));
  }

  /// Take photo from basicCameraScreen and return assets to the caller
  Future<void> onTakePhoto({bool needMirrorPhoto = false}) async {
    final List<XFile> assets = <XFile>[];
    dataStore.selectedAssets.value.forEach((AssetModel element) async {
      assets.add(element.file);
    });
    dataStore.selectedAssets.value.clear();
    dataStore.availablePath.value.clear();
    dataStore.advancedPickerCompleter.complete((
      assets: assets,
      needMirrorPhoto: needMirrorPhoto,
    ));
  }

  /// Load more assets
  Future<void> loadMoreAsset({
    required AssetPathEntity path,
  }) async {
    final int page = dataStore.pages[path.id]! + 1;
    final List<AssetEntity> entities = await path.getAssetListPaged(
      page: page,
      size: dataStore.sizePerPage,
    );
    dataStore.pathData[path.id]!.value = <AssetEntity>[
      ...dataStore.pathData[path.id]!.value,
      ...entities
    ];
    dataStore.pages[path.id] = page;
    dataStore.hasMoreToLoad[path.id] =
        dataStore.pathData[path.id]!.value.length < dataStore.totalEntitiesCount[path.id]!;
  }

  /// Get assets path
  Future<void> getAssetsPath({
    required PickerAssetType allowedTypes,
  }) async {
    dataStore.availablePath.value = await PhotoManager.getAssetPathList(
      type: allowedTypes.toRequestType,
      filterOption: _filterOptionGroup,
    );

    if (dataStore.availablePath.value.isNotEmpty) {
      final List<AssetEntity> entities =
          await dataStore.availablePath.value.first.getAssetListPaged(
        page: 0,
        size: dataStore.sizePerPage,
      );
      dataStore.pathData[dataStore.availablePath.value.first.id] =
          ValueNotifier<List<AssetEntity>>(<AssetEntity>[]);

      dataStore.pathData[dataStore.availablePath.value.first.id]!.value = entities;
      dataStore.totalEntitiesCount[dataStore.availablePath.value.first.id] =
          await dataStore.availablePath.value.first.assetCountAsync;
      dataStore.pages[dataStore.availablePath.value.first.id] = 0;
      dataStore.hasMoreToLoad[dataStore.availablePath.value.first.id] =
          entities.length < dataStore.totalEntitiesCount[dataStore.availablePath.value.first.id]!;
      if (dataStore.availablePath.value.first == dataStore.availablePath.value.first) {
        dataStore.selectedPath.value = dataStore.availablePath.value.first;
      }
    }
  }

  /// Load asset path
  Future<void> loadAssetPath(AssetPathEntity assetPath) async {
    final List<AssetEntity> entities = await assetPath.getAssetListPaged(
      page: 0,
      size: dataStore.sizePerPage,
    );
    dataStore.pathData[assetPath.id] = ValueNotifier<List<AssetEntity>>(<AssetEntity>[]);

    dataStore.pathData[assetPath.id]!.value = entities;
    dataStore.totalEntitiesCount[assetPath.id] = await assetPath.assetCountAsync;
    dataStore.pages[assetPath.id] = 0;
    dataStore.hasMoreToLoad[assetPath.id] =
        entities.length < dataStore.totalEntitiesCount[assetPath.id]!;
  }

  /// Request permissions
  Future<bool> requestPermissions() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.hasAccess) {
      return false;
    }
    return true;
  }
}
