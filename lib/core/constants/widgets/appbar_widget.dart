import 'package:flutter/material.dart';

AppBar customAppBar(
  String? text,
  BuildContext contexts, [
  List<Widget>? action,
  bool? flag
]) {
  return AppBar(
    title: Text(text ?? ""),
    actions: action,
    automaticallyImplyLeading: false,
    leading: (Navigator.canPop(contexts) && (flag == null || flag == false))
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(contexts);
                },
              ),
            ),
          )
        : null,
  );
}
