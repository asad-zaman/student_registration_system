import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_registration_system/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  //This key handle forms state and validation
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formState,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/ic_app_icon.png",
                          width: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Student Registration \nSystem',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 10,
                          margin: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login',
                                  style: GoogleFonts.roboto(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    initialValue: controller.userName.value,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? "Incorrect username"
                                            : null,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onChanged: controller.updateUserName,
                                  ),
                                ),
                                SizedBox(height: 10),
                                //Obserable controller to refresh the underlaying view automatically based on obserable's state
                                GetX<LoginController>(
                                  init: LoginController(),
                                  builder: (loginController) {
                                    return Container(
                                      child: TextFormField(
                                        obscureText: loginController
                                            .passwordVisible.value,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        initialValue:
                                            loginController.userPassword.value,
                                        validator: (value) =>
                                            (value == null || value.isEmpty)
                                                ? "Incorrect password"
                                                : null,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black87,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              loginController
                                                      .passwordVisible.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed:
                                                loginController.togglePassword,
                                          ),
                                        ),
                                        onChanged:
                                            loginController.updateUserPassword,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Obx(
                                      () {
                                        return MaterialButton(
                                          height: 48,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              controller.communicatingWithServer
                                                      .value
                                                  ? Container(
                                                      height: 25,
                                                      width: 25,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : SizedBox(),
                                              SizedBox(width: 10),
                                              Text(
                                                "Login",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          color: Colors.blue[600],
                                          onPressed: () {
                                            if (formState.currentState !=
                                                    null &&
                                                formState.currentState!
                                                    .validate() &&
                                                !controller
                                                    .communicatingWithServer
                                                    .value) {
                                              controller.handleLogin();
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
