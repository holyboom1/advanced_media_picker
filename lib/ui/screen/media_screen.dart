part of '../../advanced_media_picker_impl.dart';

class MediaScreen extends StatefulWidget {
  final String filePath;
  final bool isMediaFromPreview;
  final CameraStyle style;
  final VoidCallback? onTapFromPreview;
  final bool isLimitReached;

  const MediaScreen({
    required this.filePath,
    this.isMediaFromPreview = false,
    required this.style,
    this.onTapFromPreview,
    this.isLimitReached = false,
    super.key,
  });

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final ValueNotifier<bool> _isPreviewTapped = ValueNotifier<bool>(false);
  String _filePath = '';
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    _formatVideo(widget.filePath);
  }

  Future<void> _formatVideo(String filePath) async {
    if (filePath.isVideo()) {
      bytes = await VideoFileFormatter.getUint8List(File(filePath));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isPreviewTapped,
                builder: (BuildContext context, bool isPreviewTapped, Widget? child) {
                  if (isPreviewTapped) {
                    if (_filePath.isVideo()) {
                      _formatVideo(_filePath);
                    }
                    return _filePath.isPicture()
                        ? Image.file(File(_filePath))
                        : bytes != null
                            ? Image.memory(bytes!)
                            : const Center(child: CircularProgressIndicator(color: Colors.grey));
                  } else {
                    return widget.filePath.isPicture()
                        ? Image.file(File(widget.filePath))
                        : bytes != null
                            ? Image.memory(bytes!)
                            : const Center(child: CircularProgressIndicator(color: Colors.grey));
                  }
                },
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: dataStore.isPreviewOpen,
              builder: (BuildContext context, bool value, Widget? child) {
                return Positioned(
                  bottom: 190,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: dataStore.isPreviewOpen.value ? 1 : 0,
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      constraints: const BoxConstraints(maxHeight: 130),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: dataStore.isPreviewOpen.value ? 130 : 0,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dataStore.capturedAssets.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MediaPreview(
                            style: widget.style,
                            isSelected: true,
                            onSelect: () {
                              //select - deselect
                            },
                            onTap: () {
                              _isPreviewTapped.value = true;
                              _filePath = dataStore.capturedAssets.value[index].path;
                              setState(() {});
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
            ),
            Positioned(
              bottom: 142,
              right: 22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.isLimitReached ||
                          dataStore.capturedAssets.value.length + 1 > dataStore.limitToSelection
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                  widget.isMediaFromPreview ||
                          dataStore.capturedAssets.value.length > 1 ||
                          widget.isLimitReached
                      ? ValueListenableBuilder<bool>(
                          valueListenable: dataStore.isPreviewOpen,
                          builder: (BuildContext context, bool value, Widget? child) {
                            return GestureDetector(
                              onTap: () {
                                dataStore.isPreviewOpen.value = !dataStore.isPreviewOpen.value;
                              },
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Visibility(
                                    visible: dataStore.capturedAssets.value.isNotEmpty,
                                    child: MediaPreviewControlButton(
                                      countValue: dataStore.capturedAssets.value.length.toString(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 22,
              child: GestureDetector(
                onTap: () {
                  dataStore.isPreviewOpen.value = false;
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    border: Border.all(color: Colors.white, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 22,
              child: GestureDetector(
                onTap: () {
                  dataStore.isPreviewOpen.value = false;
                  assetsService.onClose();
                  Navigator.of(context).popUntil((Route route) => route.isFirst);
                },
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
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
