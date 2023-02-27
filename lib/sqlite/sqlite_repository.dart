import 'sqlite_database.dart';
import 'sqlite_model.dart';

//  CREATE TABLE imc (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           altura REAL,
//           peso REAL,
//           resultado REAL,
//           data STRING
//   );'''

class SqliteRepository {
  Future<List<SqliteModel>> getData() async {
    List<SqliteModel> imc = [];
    var db = await SqliteDatabase().getDatabase();
    var result =
        await db.rawQuery('SELECT id, altura, peso, resultado, data FROM imc');
    for (var element in result) {
      imc.add(
        SqliteModel(
            int.parse(element['id'].toString()),
            double.parse(element['altura'].toString()),
            double.parse(element['peso'].toString()),
            double.parse(element['resultado'].toString()),
            element['data'].toString()),
      );
    }
    return imc;
  }

  Future<void> save(SqliteModel sqliteModel) async {
    var db = await SqliteDatabase().getDatabase();
    await db.rawInsert(
        'INSERT INTO imc (altura, peso, resultado, data) values(?,?,?,?)', [
      sqliteModel.altura,
      sqliteModel.peso,
      sqliteModel.resultado,
      sqliteModel.data
    ]);
  }

  Future<void> update(SqliteModel sqliteModel) async {
    var db = await SqliteDatabase().getDatabase();
    await db.rawInsert(
        'UPDATE imc SET altura = ?, peso = ?, resultado = ?, data = ? WHERE id = ?',
        [
          sqliteModel.altura,
          sqliteModel.peso,
          sqliteModel.resultado,
          sqliteModel.id,
          sqliteModel.data,
        ]);
  }

  Future<void> delete(int id) async {
    var db = await SqliteDatabase().getDatabase();
    await db.rawInsert('DELETE FROM imc WHERE id = ?', [id]);
  }
}
