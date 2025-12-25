import 'package:flutter/material.dart';

Widget alreadyHaveAn(String text1, String text2, VoidCallback? onClick) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text1, style: TextStyle(color: Colors.grey, fontSize: 16)),
      SizedBox(width: 5),
      TextButton(
        onPressed: onClick,
        child: Text(text2, style: TextStyle(color: Colors.black, fontSize: 15)),
      ),
    ],
  );
}
