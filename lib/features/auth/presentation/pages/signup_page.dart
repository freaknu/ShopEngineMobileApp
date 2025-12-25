import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/app_dialogs.dart';
import 'package:ecommerce_app/core/constants/widgets/app_loading.dart';
import 'package:ecommerce_app/features/auth/domain/entity/create_account.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/rememberme_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isHandlingSuccess = false;

  @override
  void dispose() {
    _isHandlingSuccess = false;
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _signUp() {
    context.read<AuthBloc>().add(
          SignupEvent(
            CreateAccount(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              name: _userNameController.text.trim(),
              role: const ["USER"],
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppcolorPallets.primaryColor.withOpacity(0.05),
            AppcolorPallets.secondaryColor,
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar("", context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                /// ---------------- HEADER ----------------
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Account 🎉",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppcolorPallets.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Join us and start your shopping journey",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppcolorPallets.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// ---------------- FORM ----------------
                AuthField(
                  controller: _userNameController,
                  fieldName: "Username",
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                AuthField(
                  controller: _emailController,
                  fieldName: "Email Address",
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                AuthField(
                  controller: _passwordController,
                  fieldName: "Password",
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                const RemembermeWidget(),

                const SizedBox(height: 32),

                /// ---------------- BUTTON + BLOC ----------------
                BlocConsumer<AuthBloc, AuthState>(
                  listenWhen: (previous, current) {
                    // Only listen to state changes, not rebuilds of the same state
                    return previous.runtimeType != current.runtimeType;
                  },
                  listener: (context, state) async {
                    if (state is AuthLoading) {
                      _isHandlingSuccess = false; // Reset flag when loading starts
                      AppLoading.show(context, message: 'Creating account...');
                    }

                    if (state is AuthFailure) {
                      AppLoading.hide();
                      if (!mounted) return;
                      
                      await AppDialogs.showErrorDialog(
                        context: context,
                        title: 'Signup Failed',
                        message: state.failureMessage,
                        buttonText: 'Try Again',
                      );
                    }

                    if (state is AuthSuccess) {
                      if (_isHandlingSuccess) return; // Already handling success, skip
                      _isHandlingSuccess = true;
                      
                      AppLoading.hide();
                      // Wait a bit before showing success
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (!mounted) return;
                      
                      await AppDialogs.showSuccessDialog(
                        context: context,
                        title: 'Account Created!',
                        message: state.successMessage,
                        buttonText: 'Start Shopping',
                      );
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppcolorPallets.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppcolorPallets.primaryColor.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                /// ---------------- SIGNIN LINK ----------------
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signin'),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: AppcolorPallets.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: AppcolorPallets.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------------- TERMS ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: AppcolorPallets.textLight,
                        height: 1.5,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        const TextSpan(
                          text: "By creating an account you agree to our ",
                        ),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppcolorPallets.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
