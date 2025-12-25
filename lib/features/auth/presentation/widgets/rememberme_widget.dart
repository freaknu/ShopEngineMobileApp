import 'package:flutter/material.dart';

class RemembermeWidget extends StatefulWidget {
  const RemembermeWidget({super.key});

  @override
  State<RemembermeWidget> createState() => _RemembermeWidgetState();
}

class _RemembermeWidgetState extends State<RemembermeWidget> {
  bool _isRemembered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Remember me", style: TextStyle(color: Colors.black)),
          Switch(
            value: _isRemembered,
            onChanged: (value) {
              setState(() {
                _isRemembered = value;
              });
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
