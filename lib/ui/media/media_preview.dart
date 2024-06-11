import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../advanced_media_picker_impl.dart';
import '../../utils/extensions.dart';
import '../../utils/video_file_formatter.dart';

class MediaPreview extends StatefulWidget {
  final String path;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;
  final bool isSelected;

  const MediaPreview({
    required this.path,
    required this.onTap,
    this.onDelete,
    this.onSelect,
    this.isSelected = false,
    super.key,
  });

  @override
  State<MediaPreview> createState() => _MediaPreviewState();
}

final Map<String, Widget> _bytesData = <String, Widget>{};

class _MediaPreviewState extends State<MediaPreview> {
  @override
  void initState() {
    super.initState();
    _loadAsset();
  }

  Future<void> _loadAsset() async {
    if (widget.path.isVideo()) {
      final Uint8List? bytes =
          await VideoFileFormatter.getUint8List(File(widget.path));
      _bytesData[widget.path] = Image.memory(
        bytes ?? Uint8List(0),
        fit: BoxFit.cover,
        frameBuilder: (BuildContext context, Widget child, int? frame,
            bool wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black54, width: 3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: widget.path.isPicture()
                  ? Image.file(
                      File(widget.path),
                      fit: BoxFit.cover,
                    )
                  : _bytesData[widget.path] ?? const SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: widget.isSelected ? widget.onSelect : widget.onDelete,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: widget.isSelected
                    ? dataStore.cameraStyle.cameraSelectedMediaButton
                    : dataStore.cameraStyle.cameraDeleteMediaButton,
              ),
            ),
          ),
          if (widget.path.isVideo())
            Positioned(
              bottom: 4,
              left: 6,
              child: dataStore.cameraStyle.videoIcon,
            ),
        ],
      ),
    );
  }
}
