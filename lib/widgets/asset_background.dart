import 'package:flutter/material.dart';

class AssetBackground extends StatelessWidget {
  const AssetBackground({
    required this.asset,
    required this.overlayColor,
    required this.child,
    super.key,
  });

  final String asset;
  final Color overlayColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final physicalWidth =
        MediaQuery.sizeOf(context).width *
        MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = physicalWidth.clamp(720, 1200).round();

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          asset,
          fit: BoxFit.cover,
          cacheWidth: cacheWidth,
          filterQuality: FilterQuality.medium,
        ),
        ColoredBox(color: overlayColor),
        child,
      ],
    );
  }
}
