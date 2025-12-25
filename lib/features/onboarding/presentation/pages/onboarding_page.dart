import 'package:ecommerce_app/features/onboarding/presentation/widgets/genderselection_widget.dart';
import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppcolorPallets.primaryColor,
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Image.asset(
                "assets/images/onboarding_image.png",
                fit: BoxFit.contain,
              ),
              GenderselectionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
