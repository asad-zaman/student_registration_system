import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_registration_system/models/database_provider.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/models/repositories/user_repository.dart';

class ChangePasswordController extends GetxController {
  var confirmPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  var communicationWithServer = false.obs;
  var confirmPasswordVisible = true.obs;
  var currentPasswordVisible = true.obs;
  var passwordVisible = true.obs;
  var user = User.empty().obs;

  late UserRepository userRepository;

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleConfirmPassword() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  void toggleCurrentPassword() {
    currentPasswordVisible.value = !currentPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    DatabaseProvider.srsDatabase.then(
      (value) => userRepository = UserRepository(userDao: value.userDao),
    );
  }

  void updateUser() async {
    communicationWithServer.value = true;
    var currentPassword = user.value.password;

    try {
      user.value.password = confirmPasswordController.text;
      await userRepository.addOrUpdateUser(user.value);

      //Under successful updation navigate user from this page
      Get.back(result: true);
      Get.snackbar(
        'Info',
        'Successfully changed password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      //In case failure set the previous information
      user.value.password = currentPassword;
      print(e);
      Get.snackbar(
        'Error',
        'Unable to change password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    communicationWithServer.value = false;
  }
}
