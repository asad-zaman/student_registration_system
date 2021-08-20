import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/views/home_page.dart';
import 'package:student_registration_system/views/side_bar.dart';

class SideBarLayout extends StatelessWidget {
  final User user;

  SideBarLayout({required this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: [
            HomePage(
              user: user,
            ),
            SideBar(
              user: user,
            ),
          ],
        ),
      ),
    );
  }

  //Handle back buttion press and ask for confirmation from user
  Future<bool> onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Warning!'),
        content: new Text('Do you want to exit?'),
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
  }
}
