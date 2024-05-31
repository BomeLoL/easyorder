import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Background_image extends StatelessWidget {
    final Widget child;


  
  const Background_image({
    required this.child,
  });


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Transform.rotate(
              angle: 0.3,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'images/fruits.png',
                  width: 480,
                  height: 245,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          child,
        ],
      );
  }
}