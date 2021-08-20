import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/user_dao.dart';
import 'dto/user.dart';

part 'srs_database.g.dart';

@Database(version: 1, entities: [
  User,
])
abstract class SrsDatabase extends FloorDatabase {
  UserDao get userDao;
}
