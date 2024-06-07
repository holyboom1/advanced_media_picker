import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

import '../advanced_media_picker.dart';

/// Asset model
class AssetModel {
  /// Asset id
  final String id;

  /// Asset file
  final XFile file;

  /// Asset type
  final AssetType type;

  /// Asset model
  AssetModel({
    required this.id,
    required this.file,
    required this.type,
  });

  /// Create asset model from asset entity
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

  /// Create asset model list from asset entity list
  static Future<List<AssetModel>> fromAssetEntities(
      List<AssetEntity> entities) async {
    final List<AssetModel> assets = <AssetModel>[];
    await Future.forEach(entities, (AssetEntity entity) async {
      final AssetModel asset = await fromAssetEntity(entity);
      assets.add(asset);
    });
    return assets;
  }

  /// Create asset model from xfile
  factory AssetModel.fromXFile(XFile file) {
    return AssetModel(
      id: file.path,
      file: file,
      type: AssetType.image,
    );
  }
}
