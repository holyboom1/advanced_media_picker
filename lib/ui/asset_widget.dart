part of '../advanced_media_picker_impl.dart';

class AssetWidget extends StatelessWidget {
  final AssetEntity asset;
  final PickerStyle theme;

  const AssetWidget({
    super.key,
    required this.asset,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onOnSelectAsset(asset),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: theme.itemsBorderRadius,
          color: _selectedAssets.value.contains(asset)
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
                          baseColor: theme.shimmerBaseColor,
                          highlightColor: theme.shimmerHighlightColor,
                          child: child,
                        );
                },
              ),
            ),
            ValueListenableBuilder<List<AssetEntity>>(
              valueListenable: _selectedAssets,
              builder: (BuildContext context, List<AssetEntity> value, Widget? child) {
                return Align(
                  alignment: theme.selectIconAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.selectIconBackgroundColor,
                        border: theme.selectIconBorder,
                        shape: BoxShape.circle,
                      ),
                      child: _selectedAssets.value.contains(asset)
                          ? theme.selectIcon
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
