import 'package:flutter/material.dart';

Widget customIcon(Image asset, VoidCallback? onClick) {
  return GestureDetector(
    onTap: onClick,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        child: asset,
      ),
    ),
  );
}
