import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleSvgAvatar extends StatelessWidget {
  final String svgAsset;
  final double radius;

  const CircleSvgAvatar({
    super.key,
    required this.svgAsset,
    this.radius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SvgPicture.asset(
        svgAsset,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
      ),
    );
  }
}
