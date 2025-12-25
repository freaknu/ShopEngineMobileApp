import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/features/onboarding/presentation/widgets/gender_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class GenderselectionWidget extends StatelessWidget {
  const GenderselectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1),
        decoration: BoxDecoration(
          color: AppcolorPallets.thirdColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                "Look Good, Feel Good",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Create your individual & unique style\n",
                    ),
                    TextSpan(
                      text: "and look amazing everyday.",
                      style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                    ),
                  ],
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: GenderButton(
                      buttonText: "Men",
                      backGroundColor: AppcolorPallets.primaryColor,
                      textColor: AppcolorPallets.secondaryColor,
                    ),
                  ),
                  Expanded(
                    child: GenderButton(
                      buttonText: "Women",
                      backGroundColor: AppcolorPallets.secondaryColor,
                      textColor: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed("/signin"),
                child: Text(
                  "Skip",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
