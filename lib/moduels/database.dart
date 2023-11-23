import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

// Clase para manejar operaciones en la base de datos
class DataHelper {
  // Método para obtener la base de datos
  static Future<Database> databae() async {
    final datapath = await sql.getDatabasesPath(); // Obtiene la ruta de la base de datos
    return sql.openDatabase(path.join(datapath, 'image.db'), // Abre la base de datos o la crea si no existe
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_image(id TEXT PRIMARY KEY, title TEXT, image Text, story TEXT)'); // Crea la tabla si no existe
    }, version: 1); // Versión de la base de datos
  }

  // Método para insertar datos en la base de datos
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DataHelper.databae(); // Obtiene la base de datos
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace); // Inserta los datos en la tabla
  }

  // Método para obtener datos de la base de datos
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DataHelper.databae(); // Obtiene la base de datos
    return db.query(table); // Realiza una consulta a la tabla y devuelve los datos
  }

  // Método para eliminar datos de la base de datos
static Future<void> delete(String table, String id) async {
  final db = await DataHelper.databae(); // Obtiene la base de datos
  await db.delete(table, where: 'id = ?', whereArgs: [id]); // Elimina datos de la tabla basados en el ID
}

}
