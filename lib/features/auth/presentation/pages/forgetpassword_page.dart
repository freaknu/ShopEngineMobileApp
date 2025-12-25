import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/app_dialogs.dart';
import 'package:ecommerce_app/core/constants/widgets/button_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class ForgetpasswordPage extends StatefulWidget {
  const ForgetpasswordPage({super.key});

  @override
  State<ForgetpasswordPage> createState() => _ForgetpasswordPageState();
}

class _ForgetpasswordPageState extends State<ForgetpasswordPage> {
  final TextEditingController _controller = TextEditingController();

  void _sendOtp() {
    context.read<AuthBloc>().add(SendOtp(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("", context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Forget Password",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("assets/images/forget_password.png"),
                  ),
                  SizedBox(height: 30),
                  AuthField(
                    controller: _controller,
                    fieldName: "Email Address",
                    isPassword: false,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      "Please write your email to receive a confirmation code to set a new password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        AppDialogs.showSuccessDialog(
                          context: context,
                          title: 'Email Sent!',
                          message: state.successMessage,
                          buttonText: 'Continue',
                        ).then((_) {
                          Get.offNamed('/verify',arguments: {
                            'email' : _controller.text
                          });
                        });
                      } else if (state is AuthFailure) {
                        AppDialogs.showErrorDialog(
                          context: context,
                          title: 'Error',
                          message: state.failureMessage,
                          buttonText: 'Try Again',
                        );
                      }
                    },
                    builder: (context, state) {
                      return ButtonWidget(
                        buttonText: "Confirm mail",
                        buttonBackGroundColor: AppcolorPallets.primaryColor,
                        buttonTextColor: Colors.white,
                        onClick: _sendOtp,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
