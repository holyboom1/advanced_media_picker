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
    return ValueListenableBuilder<int>(
      valueListenable: _capturedAssetsLength,
      builder: (BuildContext context, int value, Widget? child) {
        return Positioned(
          bottom: 225,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isPreviewOpen.value ? 1 : 0,
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isPreviewOpen.value ? 130 : 0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value,
                itemBuilder: (BuildContext context, int index) {
                  return MediaPreview(
                    style: style,
                    onTap: () {
                      isPreviewOpen.value = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return MediaScreen(
                              style: style,
                              filePath: _capturedAssets.value[index].path,
                              isMediaFromPreview: true,
                              onTapFromPreview: onTap,
                            );
                          },
                        ),
                      );
                    },
                    onDelete: () {
                      _capturedAssets.value.removeAt(index);
                      _capturedAssetsLength.value = _capturedAssets.value.length;
                    },
                    path: _capturedAssets.value.isNotEmpty ? _capturedAssets.value[index].path : '',
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
