import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_registration_system/controllers/user_controller.dart';
import 'package:student_registration_system/models/dto/user.dart';

enum PageMode { View, Edit, Create }

//Handle user information forms based on different page mode like edit, create and view
class UserPage extends StatelessWidget {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final UserController userController = UserController();
  final bool isProfileUpdateOnly;
  final PageMode pageMode;

  UserPage(
      {User? user,
      this.pageMode = PageMode.Create,
      this.isProfileUpdateOnly = false}) {
    //Initialize form based on existing user in case of updation
    if (user != null) {
      userController.user.value = user;
      userController.selectedGender.value = user.gender;
      userController.selectedUser.value = user.userType;

      if (isProfileUpdateOnly)
        userController.confirmPasswordController.text = user.password;

      userController.locationController.text = user.location ?? '';
      userController.mobileController.text = user.mobile ?? '';
      userController.firstnameController.text = user.firstname;
      userController.passwordController.text = user.password;
      userController.usernameController.text = user.username;
      userController.lastnameController.text = user.lastname;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Used to check any changes made by user and ask confirmation before leave the page
    var isDirty = false;

    return WillPopScope(
      onWillPop: () => onWillPop(context, isDirty),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          toolbarHeight: 60,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'User Information',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            pageMode == PageMode.View
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      tooltip: 'Save',
                      onPressed: () {
                        //Check form state and validate it before proceed
                        if (formState.currentState != null &&
                            formState.currentState!.validate()) {
                          if (userController.selectedUser.value == null) {
                            userController.typeError.value = true;
                            return;
                          }

                          if (userController.selectedGender.value == null) {
                            userController.genderError.value = true;
                            return;
                          }

                          showConfirmation(context);
                        }
                        if (userController.selectedUser.value == null) {
                          userController.typeError.value = true;
                        }

                        if (userController.selectedGender.value == null) {
                          userController.genderError.value = true;
                        }
                      },
                      icon: Obx(
                        () {
                          //Show progress indicator in case of background operation
                          return userController.communicationWithServer.value
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
        body: GetX<UserController>(
          init: userController,
          builder: (controller) {
            return SingleChildScrollView(
              child: Form(
                key: formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              radius: 63,
                              child: Material(
                                elevation: 4.0,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: Colors.white,
                                child: getProfileImage(),
                              ),
                            ),
                          ),
                          //Enable or disable the modification based on mode
                          pageMode == PageMode.View
                              ? SizedBox()
                              : Positioned(
                                  bottom: 5,
                                  right: 10,
                                  child: PopupMenuButton(
                                    onSelected: controller.pickImage,
                                    icon: ClipOval(
                                      child: Material(
                                        color: Colors.pinkAccent,
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'camera',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.camera,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Camera'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'gallery',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.image,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Gallery'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    isProfileUpdateOnly
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              'Login Information',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                    isProfileUpdateOnly
                        ? SizedBox()
                        : Card(
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    enabled: pageMode != PageMode.View,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    controller: controller.usernameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? "Shouldn't empty"
                                            : null,
                                    onChanged: (value) {
                                      isDirty = true;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    enabled: pageMode != PageMode.View,
                                    obscureText:
                                        controller.passwordVisible.value,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: controller.passwordController,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? "Shouldn't empty"
                                            : null,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
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
                                  pageMode == PageMode.View
                                      ? SizedBox()
                                      : SizedBox(height: 10),
                                  pageMode == PageMode.View
                                      ? SizedBox()
                                      : TextFormField(
                                          enabled: pageMode != PageMode.View,
                                          obscureText: controller
                                              .confirmPasswordVisible.value,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: controller
                                              .confirmPasswordController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty)
                                              return "Shouldn't empty";
                                            else if (value !=
                                                controller
                                                    .passwordController.text)
                                              return "Password not match";
                                            else
                                              return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Confirm Password',
                                            border: OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                controller
                                                        .confirmPasswordVisible
                                                        .value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                              ),
                                              onPressed: controller
                                                  .toggleConfirmPassword,
                                            ),
                                          ),
                                          onChanged: (value) {
                                            isDirty = true;
                                          },
                                        ),
                                  SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "User Type:",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                enabled:
                                                    pageMode != PageMode.View,
                                                title: Text(
                                                  "Admin",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                leading: Radio(
                                                  value: 0,
                                                  groupValue: controller
                                                      .selectedUser.value,
                                                  onChanged: (value) {
                                                    if (pageMode !=
                                                        PageMode.View) {
                                                      isDirty = true;
                                                      controller.typeError
                                                          .value = false;
                                                      controller.selectedUser
                                                          .value = value;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                enabled:
                                                    pageMode != PageMode.View,
                                                title: Text(
                                                  "Student",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                leading: Radio(
                                                  value: 1,
                                                  groupValue: controller
                                                      .selectedUser.value,
                                                  onChanged: (value) {
                                                    if (pageMode !=
                                                        PageMode.View) {
                                                      isDirty = true;
                                                      controller.typeError
                                                          .value = false;
                                                      controller.selectedUser
                                                          .value = value;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  controller.typeError.value
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Text(
                                            "User type shouldn't empty",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        'Basic Information',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: pageMode != PageMode.View,
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: controller.firstnameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? "Shouldn't empty"
                                            : null,
                                    keyboardType: TextInputType.name,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      isDirty = true;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    enabled: pageMode != PageMode.View,
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: controller.lastnameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? "Shouldn't empty"
                                            : null,
                                    keyboardType: TextInputType.name,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      isDirty = true;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender:",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          enabled: pageMode != PageMode.View,
                                          title: Text(
                                            "Male",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                            ),
                                          ),
                                          leading: Radio(
                                            value: "male",
                                            groupValue:
                                                controller.selectedGender.value,
                                            onChanged: (value) {
                                              if (pageMode != PageMode.View) {
                                                isDirty = true;
                                                controller.genderError.value =
                                                    false;
                                                controller.selectedGender
                                                    .value = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          enabled: pageMode != PageMode.View,
                                          title: Text(
                                            "Female",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                            ),
                                          ),
                                          leading: Radio(
                                            value: "female",
                                            groupValue:
                                                controller.selectedGender.value,
                                            onChanged: (value) {
                                              if (pageMode != PageMode.View) {
                                                isDirty = true;
                                                controller.genderError.value =
                                                    false;
                                                controller.selectedGender
                                                    .value = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            controller.genderError.value
                                ? Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Text(
                                      "Gender shouldn't empty",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(height: 10),
                            TextFormField(
                              enabled: pageMode != PageMode.View,
                              decoration: InputDecoration(
                                labelText: 'Mobile',
                                border: OutlineInputBorder(),
                                prefixText: '+88',
                                counterText: '',
                              ),
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              maxLength: 11,
                              controller: controller.mobileController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) => (value != null &&
                                      value.isNotEmpty &&
                                      value.length != 11)
                                  ? "Invlid mobile number"
                                  : null,
                              onChanged: (value) {
                                isDirty = true;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              enabled: pageMode != PageMode.View,
                              decoration: InputDecoration(
                                labelText: 'Location',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              controller: controller.locationController,
                              onChanged: (value) {
                                isDirty = true;
                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getProfileImage() {
    if (userController.imagePath.value.isNotEmpty) {
      return Image.file(
        File(userController.imagePath.value),
        fit: BoxFit.cover,
        width: 120.0,
        height: 120.0,
      );
    }

    if (userController.user.value.picture != null) {
      return Image.file(
        File(userController.user.value.picture!),
        fit: BoxFit.cover,
        width: 120.0,
        height: 120.0,
      );
    }

    return Image(
      image: AssetImage(
        "assets/images/ic_user.png",
      ),
      fit: BoxFit.cover,
      width: 120.0,
      height: 120.0,
    );
  }

  Future<void> showConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Info'),
        content: new Text(
            "Do you want to ${pageMode == PageMode.Edit ? 'update' : 'add'} the user"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              userController.addOrUpdate(pageMode == PageMode.Edit);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context, bool isDirty) async {
    if (isDirty) {
      return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => new AlertDialog(
          title: new Text('Warning!'),
          content: new Text(
              'Do you want to return?\n\nAll your changes will be discarded'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: new Text('No'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: new Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      return true;
    }
  }
}
