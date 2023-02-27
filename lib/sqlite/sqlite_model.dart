// ignore_for_file: unnecessary_getters_setters

class SqliteModel {
  int _id = 0;
  double _altura = 0;
  double _peso = 0;
  double _resultado = 0;
  String _data = '';

  SqliteModel(this._id, this._altura, this._peso, this._resultado, this._data);

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  double get altura => _altura;

  set altura(double altura) {
    _altura = altura;
  }

  double get peso => _peso;

  set peso(double peso) {
    _peso = peso;
  }

  double get resultado => _resultado;

  set resultado(double resultado) {
    _resultado = resultado;
  }

  String get data => _data;

  set data(String data) {
    _data = data;
  }
}
