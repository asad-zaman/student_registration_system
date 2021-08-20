import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_registration_system/controllers/home_controller.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/views/user_page.dart';

class HomePage extends StatelessWidget {
  final homeController = HomeController();
  final User user;

  HomePage({required this.user});

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
          'Home',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: GetX<HomeController>(
        init: homeController,
        builder: (controller) {
          return controller.userItems.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 60),
                  itemCount: controller.userItems.length,
                  itemBuilder: (context, index) {
                    //Use slidable to handle right to left swipe for different actions like edit, delete based on logged in user's access permission
                    return Slidable(
                      enabled: user.userType == 0,
                      actionExtentRatio: 0.15,
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        Container(
                          height: 65,
                          margin: EdgeInsets.only(top: 11),
                          child: IconSlideAction(
                            caption: 'Edit',
                            icon: Icons.edit,
                            color: Colors.blue,
                            onTap: () async {
                              //Navigate to user edit page and update the list based on updation result
                              var result = await Get.to(
                                () => UserPage(
                                  user: controller.userItems[index],
                                  pageMode: PageMode.Edit,
                                ),
                              );
                              if (result != null && result)
                                homeController.fetchUsers();
                            },
                          ),
                        ),
                        Container(
                          height: 65,
                          margin: EdgeInsets.only(top: 11),
                          child: IconSlideAction(
                            caption: 'Delete',
                            icon: Icons.delete,
                            color: Colors.red,
                            onTap: () => showConfirmation(context,
                                index), //User confirmation before deletion
                          ),
                        ),
                      ],
                      child: Card(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: InkWell(
                          onTap: () => Get.to(
                            () => UserPage(
                              user: controller.userItems[index],
                              pageMode: PageMode.View,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Material(
                                  elevation: 4.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child:
                                        (controller.userItems[index].picture !=
                                                    null &&
                                                controller.userItems[index]
                                                    .picture!.isNotEmpty)
                                            ? Image.file(
                                                File(controller
                                                    .userItems[index].picture!),
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
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${controller.userItems[index].firstname} ${controller.userItems[index].lastname}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${controller.userItems[index].userType == 0 ? 'Admin' : 'Student'}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Nothing to show\n\nPlease add some users',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
      //Floating buttion to add new user depends on logged in user's access permission
      floatingActionButton: user.userType == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                var result = await Get.to(() => UserPage());
                if (result != null && result) homeController.fetchUsers();
              },
              label: Row(
                children: [
                  Icon(Icons.add_circle),
                  SizedBox(width: 10),
                  Text(
                    'New User',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(),
    );
  }

  Future<void> showConfirmation(BuildContext context, int index) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Info'),
        content: new Text("Do you want to delete the user"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              homeController.deleteUser(index);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
}
