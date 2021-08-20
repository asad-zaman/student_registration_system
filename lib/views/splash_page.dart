import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_registration_system/controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  final splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Animator<double>(
              duration: Duration(seconds: 1),
              cycles: 0,
              builder: (context, animatorState, child) => FadeTransition(
                opacity: animatorState.controller,
                child: Image.asset(
                  "assets/images/ic_app_icon.png",
                  fit: BoxFit.contain,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Student Registration \nSystem',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 35,
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
