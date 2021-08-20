import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:student_registration_system/models/database_provider.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/models/repositories/user_repository.dart';
import 'package:student_registration_system/utils/preference_util.dart';
import 'package:student_registration_system/views/login_page.dart';
import 'package:student_registration_system/views/side_bar_layout.dart';

class SplashController extends GetxController {
  late UserRepository userRepository;

  @override
  void onInit() {
    super.onInit();
    DatabaseProvider.srsDatabase.then((value) {
      userRepository = UserRepository(userDao: value.userDao);
      moveToNextScreen();
    });
  }

  void moveToNextScreen() async {
    await Future.wait([
      Future.delayed(Duration(seconds: 5)),
      addedDefaultAdminUser(),
    ]);

    var isLoggedIn = await PreferenceUtil.getValue(PreferenceUtil.KEY_LOGGED_IN,
        defaultValue: false);

    // If user already logged in then no need to login again, navigate to home page
    if (isLoggedIn != null && isLoggedIn) {
      var username = await PreferenceUtil.getValue(PreferenceUtil.KEY_USERNAME,
          defaultValue: 'admin');

      var user = await userRepository.findUser(username);
      if (user != null)
        Get.offAll(() => SideBarLayout(user: user));
      else
        Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  // Added default admin user at the very first time to continue the operation
  Future<void> addedDefaultAdminUser() async {
    var user = await userRepository.findUser('admin');

    if (user == null) {
      await userRepository.addOrUpdateUser(
        User(
          username: 'admin',
          password: 'admin',
          mobile: '01717346656',
          firstname: 'Md.',
          lastname: 'Asaduzzaman',
          gender: 'male',
          location: 'Dhaka',
          registrationBy: 'super_admin',
          registrationDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          userType: 0,
        ),
      );
    }
  }
}
