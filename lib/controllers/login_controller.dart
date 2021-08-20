import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_registration_system/models/database_provider.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/models/repositories/user_repository.dart';
import 'package:student_registration_system/utils/preference_util.dart';
import 'package:student_registration_system/views/side_bar_layout.dart';

/*This controller handle the authentication related operation and provide
  different views like snackbar, toast, dialog in different states. It uses
  obserables by which view gets notified when change the content and update
  accordingly.*/

class LoginController extends GetxController {
  var userName = "".obs;
  var userPassword = "".obs;
  var passwordVisible = true.obs;
  var communicatingWithServer = false.obs;
  late UserRepository userRepository;

  // Initialize the repository by injecting dao
  @override
  void onInit() {
    super.onInit();
    DatabaseProvider.srsDatabase.then(
        (value) => userRepository = UserRepository(userDao: value.userDao));
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  void updateUserName(String name) {
    userName.value = name;
  }

  void updateUserPassword(String password) {
    userPassword.value = password;
  }

  /* Handle login and show information based on state. In case of successfull
  authenticcation store the information in shared preference */

  Future handleLogin() async {
    communicatingWithServer.value = true;

    var generalResponse = await userRepository.authenticateUser(
        userName.value, userPassword.value);

    if (generalResponse.status == 200) {
      PreferenceUtil.setValue(PreferenceUtil.KEY_LOGGED_IN, true);

      var user = generalResponse.data as User;

      PreferenceUtil.setValue(PreferenceUtil.KEY_USERNAME, userName.value);
      PreferenceUtil.setValue(PreferenceUtil.KEY_USER, user.toJson());

      Get.offAll(() => SideBarLayout(user: user));

      Get.snackbar(
        'Info',
        generalResponse.message!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        generalResponse.message!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    communicatingWithServer.value = false;
  }
}
