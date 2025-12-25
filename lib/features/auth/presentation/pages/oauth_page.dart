import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/button_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/alreadyhave_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/oauth_field.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class OauthPage extends StatefulWidget {
  const OauthPage({super.key});

  @override
  State<OauthPage> createState() => _OauthPageState();
}

class _OauthPageState extends State<OauthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("", context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Let's Get Started",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                OauthField(
                  text: "Facebook",
                  backGroundColor: AppcolorPallets.faceBookColor,
                  icon: Image.asset("assets/images/fb.png"),
                ),
                OauthField(
                  text: "Twitter",
                  backGroundColor: AppcolorPallets.twitterColor,
                  icon: Image.asset("assets/images/tw.png"),
                ),
                OauthField(
                  text: "Google",
                  backGroundColor: AppcolorPallets.googleColor,
                  icon: Image.asset("assets/images/g.png"),
                ),
              ],
            ),

            Column(
              children: [
                alreadyHaveAn(
                  "Already ave an account?",
                  "Signin",
                  () => Get.toNamed("/signin"),
                ),
                ButtonWidget(
                  buttonText: "Create an Account",
                  buttonBackGroundColor: AppcolorPallets.primaryColor,
                  buttonTextColor: Colors.white,
                  onClick: () => Get.toNamed("/signup"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
