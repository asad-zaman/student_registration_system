import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_registration_system/models/database_provider.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/models/repositories/user_repository.dart';

class HomeController extends GetxController {
  //Observable users
  final userItems = List<User>.empty().obs;
  late UserRepository userRepository;

  @override
  void onInit() {
    super.onInit();
    DatabaseProvider.srsDatabase.then((value) {
      userRepository = UserRepository(userDao: value.userDao);
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    userItems.assignAll(await userRepository.findUsersExceptCurrent());
  }

  Future<void> deleteUser(int index) async {
    try {
      await userRepository.deleteUser(userItems[index]);
      //remove it from observeable if success
      userItems.removeAt(index);

      Get.snackbar(
        'Info',
        'Successfully deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Unable to delete the user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
