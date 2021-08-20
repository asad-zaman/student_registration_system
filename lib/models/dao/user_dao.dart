import 'package:floor/floor.dart';
import 'package:student_registration_system/models/dto/user.dart';

@dao
abstract class UserDao {
  //Single insertion operation, replace in case of duplication
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertUser(User user);

  //Find all users in the table
  @Query('SELECT * FROM User')
  Future<List<User>> findAllUsers();

  //Find all users in the table except login user
  @Query('SELECT * FROM User WHERE username != :username')
  Future<List<User>> findAllUsersExceptCurrent(String username);

  //Find all the users in the table by username
  @Query('SELECT * FROM User WHERE username =:username')
  Future<User?> findUserByUnsername(String username);

  //Find all the users by registered admin
  @Query('SELECT * FROM User WHERE registrationBy =:registrationBy')
  Future<List<User>> findUserByAdmin(String registrationBy);

  //Find user based on mobile number
  @Query('SELECT * FROM User WHERE mobileNo =:mobile')
  Future<User?> findUserByMobile(String mobile);

  //Delete user based on username
  @Query('DELETE FROM User WHERE username =:username')
  Future<void> deleteUserByUnsername(String username);

  @delete
  Future<void> deleteUser(User user);
}
