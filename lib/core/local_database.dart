import 'package:calendar/models/event_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();

  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableEvents (
      ${EventFields.id} $idType,
      ${EventFields.name} $textType,
      ${EventFields.location} $textType,
      ${EventFields.selectAllday} $textType,
      ${EventFields.description} $textType,
      ${EventFields.color} $integerType,
      ${EventFields.time} $textType
    )
    ''');
  }

  Future<Event> create(Event event) async {
    final db = await instance.database;

    final id = await db.insert(tableEvents, event.toJson());
    return event.copy(id: id);
  }

  Future<Event?> readEvent(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableEvents,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;

    const orderBy = '${EventFields.time} ASC';
    final result = await db.query(tableEvents, orderBy: orderBy);

    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<int> update(Event event) async {
    final db = await instance.database;

    return db.update(
      tableEvents,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(
      tableEvents,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

const String tableEvents = 'events';

class EventFields {
  static final List<String> values = [
    id, name, selectAllday, location,  description, color, time
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String location = 'location';
  static const String selectAllday = 'selectAllday';
  static const String description = 'description';
  static const String color = 'color';
  static const String time = 'time';

  

 

  
}
