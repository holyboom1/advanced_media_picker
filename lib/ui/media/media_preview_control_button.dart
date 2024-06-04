part of '../../advanced_media_picker_impl.dart';

class MediaPreviewControlButton extends StatelessWidget {
  final String countValue;

  const MediaPreviewControlButton({
    required this.countValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        shape: BoxShape.circle,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: isPreviewOpen.value
            ? const Icon(Icons.clear, color: Colors.white, size: 20)
            : Text(
                countValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
