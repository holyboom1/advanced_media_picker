part of '../../advanced_media_picker_impl.dart';

class DirectoryWidget extends StatefulWidget {
  final AssetPathEntity path;

  const DirectoryWidget({
    super.key,
    required this.path,
  });

  @override
  State<DirectoryWidget> createState() => _DirectoryWidgetState();
}

class _DirectoryWidgetState extends State<DirectoryWidget> {
  @override
  void initState() {
    super.initState();
    if (dataStore.pathData[widget.path.id] == null) {
      loadPath();
    } else {
      isLoaded = true;
    }
  }

  Future<void> loadPath() async {
    await assetsService.loadAssetPath(widget.path);
    isLoaded = true;
  }

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dataStore.selectedPath.value = widget.path;
      },
      child: ValueListenableBuilder<AssetPathEntity?>(
        valueListenable: dataStore.selectedPath,
        builder: (BuildContext context, AssetPathEntity? value, Widget? child) {
          if (value == null ||
              dataStore.pathData[widget.path.id] == null ||
              dataStore.pathData[widget.path.id]!.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Stack(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: dataStore.selectedPath.value!.id == widget.path.id
                      ? dataStore.style.selectedFolderDecoration
                      : dataStore.style.unselectedFolderDecoration,
                  child: AssetEntityImage(
                    dataStore.pathData[widget.path.id]!.value.first,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      return loadingProgress == null
                          ? child
                          : Shimmer.fromColors(
                              baseColor: dataStore.style.shimmerBaseColor,
                              highlightColor:
                                  dataStore.style.shimmerHighlightColor,
                              child: child,
                            );
                    },
                  ),
                ),
                Align(
                  alignment: dataStore.style.selectIconAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: dataStore.style.selectIconBackgroundColor,
                        border: dataStore.style.selectIconBorder,
                        shape: BoxShape.circle,
                      ),
                      child: value.id == widget.path.id
                          ? dataStore.style.selectIcon
                          : const SizedBox(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      widget.path.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            dataStore.selectedPath.value!.id == widget.path.id
                                ? dataStore.style.selectedFolderTextColor
                                : dataStore.style.unselectedFolderTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
