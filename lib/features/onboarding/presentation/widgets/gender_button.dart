import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  final String buttonText;
  final VoidCallbackAction? onSelection;
  final Color backGroundColor;
  final Color textColor;
  const GenderButton({
    super.key,
    required this.buttonText,
    this.onSelection,
    required this.backGroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backGroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
          onPressed: () => onSelection,
          child: Text(buttonText, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}
