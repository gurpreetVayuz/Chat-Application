import 'package:chatapplication/model/messageModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE messages(id INTEGER PRIMARY KEY AUTOINCREMENT, sender TEXT, content TEXT, timestamp INTEGER)',
        );
      },
    );
  }
  

  Future<void> insertMessage(MessageModel messageModel) async {
    final db = await database;
    await db?.insert('messages', messageModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MessageModel>> messages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('messages');
    return List.generate(maps.length, (i) {
      return MessageModel(
        id: maps[i]['id'],
        sender: maps[i]['sender'],
        content: maps[i]['content'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }
}
