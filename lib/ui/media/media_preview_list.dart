part of '../../advanced_media_picker_impl.dart';

class MediaPreviewList extends StatelessWidget {
  const MediaPreviewList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AssetModel>>(
      valueListenable: dataStore.selectedAssets,
      builder: (BuildContext context, List<AssetModel> value, Widget? child) {
        return Positioned(
          bottom: 225,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: dataStore.isPreviewOpen.value ? 1 : 0,
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: dataStore.isPreviewOpen.value ? 130 : 0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  return MediaPreview(
                    onTap: () {
                      dataStore.isPreviewOpen.value = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return MediaScreen(
                              filePath: dataStore.selectedAssets.value[index].file.path,
                              isMediaFromPreview: true,
                            );
                          },
                        ),
                      );
                    },
                    onDelete: () {
                      dataStore.selectedAssets.removeAsset(dataStore.selectedAssets.value[index]);
                    },
                    path: dataStore.selectedAssets.value.isNotEmpty
                        ? dataStore.selectedAssets.value[index].file.path
                        : '',
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
