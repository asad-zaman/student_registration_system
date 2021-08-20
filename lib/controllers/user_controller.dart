import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_registration_system/models/database_provider.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/models/repositories/user_repository.dart';

class UserController extends GetxController {
  //Editing controllers to handle input field changes
  var confirmPasswordController = TextEditingController();
  var firstnameController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  var lastnameController = TextEditingController();
  var locationController = TextEditingController();
  var mobileController = TextEditingController();

  //Observables to handle state
  var communicationWithServer = false.obs;
  var confirmPasswordVisible = true.obs;
  var passwordVisible = true.obs;
  var user = User.empty().obs;
  var genderError = false.obs;
  var typeError = false.obs;
  var imagePath = ''.obs;

  late UserRepository userRepository;
  var selectedGender = Rx<dynamic>(null);
  var selectedUser = Rx<dynamic>(null);

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleConfirmPassword() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    DatabaseProvider.srsDatabase.then(
      (value) => userRepository = UserRepository(userDao: value.userDao),
    );
  }

  void addOrUpdate(bool isUpdate) async {
    communicationWithServer.value = true;

    //preserve the previous data to restore in case of failure
    var currentUser = json.encode(user.value.toJson());

    //Copied the selected image to application directory
    if (imagePath.isNotEmpty) {
      var directory = await getApplicationDocumentsDirectory();
      try {
        var path = '${directory.path}/profile_images';
        var rootDirectory = Directory(path);
        if (!rootDirectory.existsSync()) rootDirectory.createSync();

        var fromFile = File(imagePath.value);
        var toFile = File(
            '${rootDirectory.path}/${usernameController.text}_${DateTime.now().millisecondsSinceEpoch}${extension(imagePath.value)}');

        toFile.writeAsBytesSync(fromFile.readAsBytesSync());

        user.value.picture = toFile.path;
      } catch (e) {
        user.value.picture = imagePath.value;
        print(e);
      }
    }

    //update the user with current informations
    user.value.password = confirmPasswordController.text;
    user.value.firstname = firstnameController.text;
    user.value.location = locationController.text;
    user.value.lastname = lastnameController.text;
    user.value.username = usernameController.text;
    user.value.mobile = mobileController.text;
    user.value.gender = selectedGender.value;
    user.value.userType = selectedUser.value;

    try {
      //check existing user with the username to avoid duplication
      var checkUser = await userRepository.findUser(user.value.username);
      if (checkUser == null || isUpdate) {
        await userRepository.addOrUpdateUser(user.value);

        //Under successful adtion / updation navigate user from this page
        Get.back(result: true);
        Get.snackbar(
          'Info',
          "Successfully ${isUpdate ? 'updated' : 'added'}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        //reset the username if already exist
        usernameController.text = '';
        Get.snackbar(
          'Error',
          "Username '${user.value.username}' already exist",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      //In case failure set the previous information
      user.value = User.fromJson(json.decode(currentUser));
      print(e);
      Get.snackbar(
        'Error',
        "Unable to ${isUpdate ? 'update' : 'add'} the user",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    communicationWithServer.value = false;
  }

  //Pick image from [Camera] or [Gallery] based on user selection
  void pickImage(String value) async {
    var image = await ImagePicker().pickImage(
      source: value == 'camera' ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 70,
    );

    if (image != null) imagePath.value = image.path;
  }
}
