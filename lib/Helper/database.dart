import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationCacheDirectory();
    var path = join(directory.path, 'database_crud');
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String user =
        "CREATE TABLE user(userId INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL, password TEXT NOT NULL);";
    await database.execute(user);

    String tugas =
        "CREATE TABLE tugas(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT NOT NULL, note TEXT, tanggal DATE, waktuMulai DATETIME, waktuSelesai DATETIME, warna INTEGER, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(userId) ON DELETE CASCADE);";
    await database.execute(tugas);

    String mapel =
        "CREATE TABLE mapel(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT NOT NULL, hari TEXT, pengajar TEXT, ruang TEXT, waktuMulai DATETIME, waktuSelesai DATETIME, warna INTEGER, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(userId) ON DELETE CASCADE);";
    await database.execute(mapel);
  }
}
