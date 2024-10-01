part of '../../advanced_media_picker_impl.dart';

class AssetWidget extends StatelessWidget {
  final AssetEntity asset;
  final bool isAdvancedMediaPicker;

  const AssetWidget({
    super.key,
    required this.asset,
    this.isAdvancedMediaPicker = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isAdvancedMediaPicker
          ? assetsService.captureAssetSelection(asset)
          : assetsService.onOnSelectAsset(asset),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: dataStore.style.itemsBorderRadius,
          color: dataStore.selectedAssets.value.containsAsset(asset)
              ? Colors.blue.withOpacity(0.5)
              : Colors.transparent,
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: AssetEntityImage(
                asset,
                fit: BoxFit.cover,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize(150, 150),
                loadingBuilder:
                    (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : Shimmer.fromColors(
                          baseColor: dataStore.style.shimmerBaseColor,
                          highlightColor: dataStore.style.shimmerHighlightColor,
                          child: child,
                        );
                },
              ),
            ),
            ValueListenableBuilder<List<AssetModel>>(
              valueListenable: dataStore.selectedAssets,
              builder: (BuildContext context, List<AssetModel> value, Widget? child) {
                return Align(
                  alignment: dataStore.style.selectIconAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: dataStore.style.selectIconBackgroundColor,
                        border: dataStore.style.selectIconBorder,
                        shape: BoxShape.circle,
                      ),
                      child: dataStore.selectedAssets.value.containsAsset(asset) &&
                              !isAdvancedMediaPicker
                          ? dataStore.style.selectIcon
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
            if (asset.type == AssetType.video)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      asset.duration.toTime(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
