import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imgUrl;
  const ProductImage({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      child: Image.network(
        imgUrl,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
