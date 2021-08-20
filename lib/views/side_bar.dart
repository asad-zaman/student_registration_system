import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_registration_system/controllers/side_bar_controller.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/views/change_password_page.dart';
import 'package:student_registration_system/views/user_page.dart';

class SideBar extends StatelessWidget {
  final sidebarController = SideBarController();

  SideBar({required User user}) {
    sidebarController.user.value = user;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * .85;

    return GetX<SideBarController>(
      init: sidebarController,
      builder: (controller) {
        return AnimatedPositioned(
          duration: controller.animationDuration,
          top: 0,
          bottom: 0,
          left: controller.isSideBarOpened.value ? 0 : -(sidebarWidth - 45),
          right: controller.isSideBarOpened.value
              ? screenWidth - sidebarWidth
              : screenWidth - 45,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Container(
                        height: 230,
                        child: createHeader(context, controller),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Material(
                                color: Colors.lightBlue,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ChangePasswordPage(
                                        user: sidebarController.user.value,
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.change_circle_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    title: Text(
                                      'Change password',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Text(
                              'Logout',
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          onPressed: () => showLogoutConfirmation(context),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.95),
                child: GestureDetector(
                  onTap: controller.onIconPressed,
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: controller.animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Show logged in user's information here. Also add facility to edit the profile
  Widget createHeader(
      BuildContext context, SideBarController sidebarController) {
    return GetBuilder<SideBarController>(
        init: sidebarController,
        builder: (controller) {
          return DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(color: Colors.white),
                ),
              ),
              accountName: Text(
                "${controller.user.value.firstname} ${controller.user.value.lastname}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              accountEmail: Text(
                "${controller.user.value.userType == 0 ? 'Admin' : 'Student'}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              currentAccountPicture: Material(
                elevation: 4.0,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: (controller.user.value.picture != null &&
                        controller.user.value.picture!.isNotEmpty)
                    ? Image.file(
                        File(controller.user.value.picture!),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                    : Image(
                        image: AssetImage(
                          "assets/images/ic_user.png",
                        ),
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 50.0,
                      ),
              ),
              otherAccountsPictures: [
                GestureDetector(
                  onTap: () async {
                    var result = await Get.to(
                      () => UserPage(
                        user: controller.user.value,
                        pageMode: PageMode.Edit,
                        isProfileUpdateOnly: true,
                      ),
                    );

                    if (result != null && result) controller.update();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[800],
                    child: Icon(
                      Icons.edit,
                      size: 25,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  //Ask user confirmation before logout from the application
  Future<void> showLogoutConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Warning!'),
        content: new Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: sidebarController.doLogout,
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
}

//Custom shape menu button using bezier curve
class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
