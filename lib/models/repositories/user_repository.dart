import 'package:intl/intl.dart';
import 'package:student_registration_system/models/dao/user_dao.dart';
import 'package:student_registration_system/models/dto/user.dart';
import 'package:student_registration_system/utils/general_response.dart';
import 'package:student_registration_system/utils/preference_util.dart';

// This repository provides user related information to controller
class UserRepository {
  final UserDao userDao;
  UserRepository({required this.userDao});

  Future<GeneralResponse> authenticateUser(
      String username, String password) async {
    var user = await userDao.findUserByUnsername(username);
    var generalResponse = GeneralResponse();
    generalResponse.data = user;

    // Provide status code and message beased on data
    if (user == null) {
      generalResponse.status = 404;
      generalResponse.message = "User not found with username '$username'";
    } else if (user.password != password) {
      generalResponse.status = 401;
      generalResponse.message = 'Invalid password';
    } else {
      generalResponse.status = 200;
      generalResponse.message = 'Successfully logged In';
    }

    return generalResponse;
  }

  //Find user in database using username
  Future<User?> findUser(String username) async {
    return await userDao.findUserByUnsername(username);
  }

  //Find all user in database and provide to ccontroller
  Future<List<User>> findUsers() async {
    return await userDao.findAllUsers();
  }

  //Find all user in database except the currently loggged in user
  Future<List<User>> findUsersExceptCurrent() async {
    var admin = await PreferenceUtil.getValue(PreferenceUtil.KEY_USERNAME,
        defaultValue: "");
    return await userDao.findAllUsersExceptCurrent(admin);
  }

  //Find all the users registed by admin
  Future<List<User>> findUsersByAdmin() async {
    var admin = await PreferenceUtil.getValue(PreferenceUtil.KEY_USERNAME,
        defaultValue: "");

    return await userDao.findUserByAdmin(admin);
  }

  // Add or update user. Existing user will be replaced by new data
  Future<int> addOrUpdateUser(User user) async {
    var admin = await PreferenceUtil.getValue(PreferenceUtil.KEY_USERNAME,
        defaultValue: "");

    user.registrationBy = admin ?? 'super_admin';
    user.registrationDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return await userDao.insertUser(user);
  }

  // Delete user based on provided user information
  Future<void> deleteUser(User user) async {
    return await userDao.deleteUser(user);
  }
}
