import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_registration_system/controllers/change_password_controller.dart';
import 'package:student_registration_system/models/dto/user.dart';

class ChangePasswordPage extends StatelessWidget {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final changePasswordController = ChangePasswordController();

  ChangePasswordPage({required User user}) {
    changePasswordController.user.value = user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Change Password',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                if (formState.currentState != null &&
                    formState.currentState!.validate()) {
                  showConfirmation(context);
                }
              },
              icon: Obx(
                () {
                  return changePasswordController.communicationWithServer.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : Icon(
                          Icons.done_all,
                          size: 30,
                        );
                },
              ),
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: GetX<ChangePasswordController>(
        init: changePasswordController,
        builder: (controller) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                key: formState,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      obscureText: controller.currentPasswordVisible.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Shouldn't empty";
                        else if (controller.user.value.password != value)
                          return 'Current password not match';
                        else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.currentPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.toggleCurrentPassword,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: controller.passwordVisible.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: controller.passwordController,
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Shouldn't empty"
                          : null,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.passwordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePassword,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: controller.confirmPasswordVisible.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Shouldn't empty";
                        else if (value != controller.passwordController.text)
                          return "Password not match";
                        else
                          return null;
                      },
                      controller: controller.confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.confirmPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.toggleConfirmPassword,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Info'),
        content: new Text("Do you want to change the password"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              changePasswordController.updateUser();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
}
