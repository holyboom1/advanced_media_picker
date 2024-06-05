part of '../../advanced_media_picker_impl.dart';

class MediaPreviewList extends StatelessWidget {
  final CameraStyle style;
  final VoidCallback? onTap;

  const MediaPreviewList({
    required this.style,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<XFile>>(
      valueListenable: dataStore.capturedAssets,
      builder: (BuildContext context, List<XFile> value, Widget? child) {
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
                    style: style,
                    onTap: () {
                      dataStore.isPreviewOpen.value = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return MediaScreen(
                              style: style,
                              filePath: dataStore.capturedAssets.value[index].path,
                              isMediaFromPreview: true,
                              onTapFromPreview: onTap,
                            );
                          },
                        ),
                      );
                    },
                    onDelete: () {
                      dataStore.capturedAssets.value.removeAt(index);
                    },
                    path: dataStore.capturedAssets.value.isNotEmpty
                        ? dataStore.capturedAssets.value[index].path
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
