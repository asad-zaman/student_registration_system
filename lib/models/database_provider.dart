import 'package:student_registration_system/models/srs_database.dart';

class DatabaseProvider {
  static SrsDatabase? floorSrsDatabase;

  static Future<SrsDatabase> get srsDatabase async {
    if (floorSrsDatabase == null) {
      floorSrsDatabase =
          await $FloorSrsDatabase.databaseBuilder('srs_database.db').build();
    }

    return floorSrsDatabase!;
  }
}
