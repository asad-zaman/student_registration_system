import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/utils/preference_util.dart';
import 'package:student_registration_system/views/login_page.dart';

/* This controller handle the custom shaped sidebar navigation, transition 
and animation using obserables. Also hold user state and navigation */

class SideBarController extends GetxController
    with SingleGetTickerProviderMixin {
  //Duration for animation transition
  final animationDuration = const Duration(milliseconds: 500);
  late AnimationController animationController;
  var isSideBarOpened = false.obs;
  var user = User.empty().obs;

  @override
  void onInit() {
    super.onInit();
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void onClose() {
    //Dispose the controller
    animationController.dispose();
    super.onClose();
  }

  void onIconPressed() {
    final animationStatus = animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSideBarOpened.value = false;
      animationController.reverse();
    } else {
      isSideBarOpened.value = true;
      animationController.forward();
    }
  }

  //Clear login state from preference and navigate to login page
  void doLogout() {
    PreferenceUtil.setValue(PreferenceUtil.KEY_LOGGED_IN, false);
    Get.offAll(() => LoginPage());
  }
}
