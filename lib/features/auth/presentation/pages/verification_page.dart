import 'dart:async';

import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/button_widget.dart';
import 'package:ecommerce_app/features/auth/domain/entity/verifyotp_request.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  
  String email = Get.arguments['email'];
  // Timer variables
  Timer? _timer;
  int _remainingSeconds = 300; 
  bool _canResend = false;

  void _verifyOTP() {
    // Collect OTP from all 4 controllers
    String otpString = _otpControllers.map((controller) => controller.text).join();
    
    // Validate OTP length
    if (otpString.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 4-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Convert to integer
    int otp = int.parse(otpString);
    
    // Send verification request
    context.read<AuthBloc>().add(VerifyOtp(VerifyotpRequest(otp, email)));
  }
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _remainingSeconds = 300; // Reset to 5 minutes
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _resendCode() {
    if (_canResend) {
      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      // Focus on first field
      _focusNodes[0].requestFocus();
      
      // Resend OTP
      context.read<AuthBloc>().add(SendOtp(email));
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Check if this is OTP verification success (not resend success)
          if (state.successMessage.toLowerCase().contains('verified')) {
            // OTP verified successfully, navigate to reset password page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate to reset password page with email argument (use offNamed to clear navigation stack)
            Get.offNamed('/reset', arguments: {'email': email});
          } else {
            // OTP resent successfully, stay on this page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code resent successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else if (state is AuthFailure) {
          // OTP verification or resend failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failureMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: customAppBar("", context),
        body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Verification Code",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset("assets/images/forget_password.png"),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => Flexible(
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppcolorPallets.primaryColor.withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppcolorPallets.primaryColor.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _canResend
                    ? TextButton(
                        onPressed: _resendCode,
                        child: Text(
                          "Resend Code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppcolorPallets.primaryColor,
                          ),
                        ),
                      )
                    : Text(
                        "Resend code in ${_formatTime(_remainingSeconds)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                ),
                SizedBox(height: 10),
                ButtonWidget(
                  buttonText: "Confirm code",
                  buttonBackGroundColor: AppcolorPallets.primaryColor,
                  buttonTextColor: Colors.white,
                  onClick: _verifyOTP,
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
