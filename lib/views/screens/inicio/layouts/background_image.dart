import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String imagePath;
  final double? position;

  const BackgroundImage({Key? key, required this.imagePath, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: position != null ? MediaQuery.of(context).size.height * position! : null,
      child: Image.asset(
        imagePath,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
