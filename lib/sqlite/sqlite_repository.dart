import 'sqlite_database.dart';
import 'sqlite_model.dart';

//  CREATE TABLE imc (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           altura DOUBLE,
//           peso DOUBLE,
//           resultado DOUBLE
//   );'''

class SqliteRepository {
  Future<List<SqliteModel>> getData() async {
    List<SqliteModel> imc = [];
    var db = await SqliteDatabase().getDatabase();
    var result =
        await db.rawQuery('SELECT id, altura, peso, resultado FROM imc');
    for (var element in result) {
      imc.add(
        SqliteModel(
            int.parse(element['id'].toString()),
            double.parse(element['altura'].toString()),
            double.parse(element['peso'].toString()),
            double.parse(element['resultado'].toString())),
      );
    }
    return imc;
  }

  Future<void> save(SqliteModel sqliteModel) async {
    var db = await SqliteDatabase().getDatabase();
    await db.rawInsert(
        'INSERT INTO imc (altura, peso, resultado) values(?,?,?)',
        [sqliteModel.altura, sqliteModel.peso, sqliteModel.resultado]);
  }

  Future<void> update(SqliteModel sqliteModel) async {
    var db = await SqliteDatabase().getDatabase();
    await db.rawInsert(
        'UPDATE imc SET altura = ?, peso = ?, resultado = ? WHERE id = ?', [
      sqliteModel.altura,
      sqliteModel.peso,
      sqliteModel.resultado,
      sqliteModel.id
    ]);
  }

  Future<void> delete(int id) async {
    var db = await SqliteDatabase().getDatabase();
    await db.rawInsert('DELETE FROM imc WHERE id = ?', [id]);
  }
}
