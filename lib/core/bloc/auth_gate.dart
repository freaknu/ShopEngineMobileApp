import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:ecommerce_app/core/bloc/auth_status_bloc.dart';
import 'package:ecommerce_app/core/bloc/auth_status_state.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStatusBloc, AuthStatusState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Get.offAllNamed('/home');
        } else if (state is Unauthenticated) {
          Get.offAllNamed('/signin');
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
