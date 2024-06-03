part of '../flutter_media_picker_impl.dart';

class DirectoryWidget extends StatefulWidget {
  final AssetPathEntity path;
  final PickerStyle theme;

  const DirectoryWidget({
    super.key,
    required this.path,
    required this.theme,
  });

  @override
  State<DirectoryWidget> createState() => _DirectoryWidgetState();
}

class _DirectoryWidgetState extends State<DirectoryWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectedPath.value = widget.path;
      },
      child: ValueListenableBuilder<AssetPathEntity?>(
        valueListenable: _selectedPath,
        builder: (BuildContext context, AssetPathEntity? value, Widget? child) {
          if (value == null ||
              pathData[widget.path.id] == null ||
              pathData[widget.path.id]!.value.isEmpty) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Stack(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: _selectedPath.value!.id == widget.path.id
                      ? widget.theme.selectedFolderDecoration
                      : widget.theme.unselectedFolderDecoration,
                  child: AssetEntityImage(
                    pathData[widget.path.id]!.value.first,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      return loadingProgress == null
                          ? child
                          : Shimmer.fromColors(
                              baseColor: widget.theme.shimmerBaseColor,
                              highlightColor: widget.theme.shimmerHighlightColor,
                              child: child,
                            );
                    },
                  ),
                ),
                Align(
                  alignment: widget.theme.selectIconAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.theme.selectIconBackgroundColor,
                        border: widget.theme.selectIconBorder,
                        shape: BoxShape.circle,
                      ),
                      child:
                          value.id == widget.path.id ? widget.theme.selectIcon : const SizedBox(),
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
                        color: _selectedPath.value!.id == widget.path.id
                            ? widget.theme.selectedFolderTextColor
                            : widget.theme.unselectedFolderTextColor,
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
