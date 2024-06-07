import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

import '../advanced_media_picker.dart';

class AssetModel {
  final String id;
  final XFile file;
  final AssetType type;

  AssetModel({
    required this.id,
    required this.file,
    required this.type,
  });

  static Future<AssetModel> fromAssetEntity(AssetEntity entity) async {
    final File? file = await entity.file;
    if (file == null) {
      throw Exception('File not found');
    }
    final XFile xFile = XFile(file.path);
    return AssetModel(
      id: entity.id,
      file: xFile,
      type: entity.type,
    );
  }

  static Future<List<AssetModel>> fromAssetEntities(List<AssetEntity> entities) async {
    final List<AssetModel> assets = <AssetModel>[];
    await Future.forEach(entities, (AssetEntity entity) async {
      final AssetModel asset = await fromAssetEntity(entity);
      assets.add(asset);
    });
    return assets;
  }

  factory AssetModel.fromXFile(XFile file) {
    return AssetModel(
      id: file.path,
      file: file,
      type: AssetType.image,
    );
  }
}
