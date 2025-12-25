import 'package:flutter/material.dart';

class OauthField extends StatelessWidget {
  final String text;
  final Color backGroundColor;
  final Image icon;
  final VoidCallbackAction? onClick;
  const OauthField({
    super.key,
    required this.text,
    required this.backGroundColor,
    required this.icon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => onClick,
          style: ElevatedButton.styleFrom(
            backgroundColor: backGroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16, width: 16, child: icon),
              SizedBox(width: 6),
              Text(text, style: TextStyle(fontSize: 17, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
