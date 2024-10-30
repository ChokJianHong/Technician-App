import 'package:flutter/material.dart';

class ImageAssetWidget extends StatelessWidget {
  final String assetPath;
  const ImageAssetWidget(this.assetPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: 24, // Set the desired width
      height: 24, // Set the desired height
      fit: BoxFit.contain, // Maintain the aspect ratio
    );
  }
}
