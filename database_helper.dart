import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'students.db';
  static const String tableName = 'estudiante';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            correo TEXT,
            fechaIngreso DATE,
            edad INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertEstudiante(Estudiante estudiante) async {
    final db = await database;
    await db.insert(tableName, estudiante.toMap());
  }

  Future<List<Estudiante>> getEstudiantes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Estudiante(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        correo: maps[i]['correo'],
        fechaIngreso: maps[i]['fechaIngreso'],
        edad: maps[i]['edad'],
      );
    });
  }

  Future<void> updateEstudiante(Estudiante estudiante) async {
    final db = await database;
    await db.update(
      tableName,
      estudiante.toMap(),
      where: 'id = ?',
      whereArgs: [estudiante.id],
    );
  }

  Future<void> deleteEstudiante(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Estudiante {
  final int? id;
  final String nombre;
  final String correo;
  final String fechaIngreso;
  final int edad;

  Estudiante({
    this.id,
    required this.nombre,
    required this.correo,
    required this.fechaIngreso,
    required this.edad,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
      'fechaIngreso': fechaIngreso,
      'edad': edad,
    };
  }
}
