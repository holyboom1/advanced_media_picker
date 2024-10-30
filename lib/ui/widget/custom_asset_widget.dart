part of '../../advanced_media_picker_impl.dart';

class CustomAssetWidget extends StatelessWidget {
  final AssetEntity asset;

  const CustomAssetWidget({
    super.key,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => assetsService.onOnSelectAsset(asset),
      child: ValueListenableBuilder<List<AssetModel>>(
        valueListenable: dataStore.selectedAssets,
        builder: (BuildContext context, List<AssetModel> value, Widget? child) {
          final int index = dataStore.selectedAssets.value
              .indexWhere((AssetModel element) => element.id == asset.id);

          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: dataStore.style.itemsBorderRadius,
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
                Align(
                  alignment: dataStore.style.selectIconAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: dataStore.selectedAssets.value.containsAsset(asset)
                        ? dataStore.style.customSelectAssetIcon != null
                            ? Stack(
                                children: <Widget>[
                                  dataStore.style.customSelectAssetIcon!,
                                  Container(
                                    width: 28,
                                    height: 28,
                                    child: Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        style: dataStore.style.customSelectAssetCountStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: dataStore.style.selectIconBackgroundColor,
                                  border: dataStore.style.selectIconBorder,
                                  shape: BoxShape.circle,
                                ),
                                child: dataStore.selectedAssets.value.containsAsset(asset)
                                    ? dataStore.style.selectIcon
                                    : const SizedBox(),
                              )
                        : dataStore.style.unselectAssetIcon != null
                            ? dataStore.style.unselectAssetIcon
                            : SizedBox.shrink(),
                  ),
                ),
                dataStore.selectedAssets.value.length == 4 &&
                        !dataStore.selectedAssets.value.containsAsset(asset)
                    ? Container(
                        width: 150,
                        height: 150,
                        color: Colors.black.withOpacity(0.4),
                      )
                    : SizedBox.shrink(),
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
          );
        },
      ),
    );
  }
}
