import 'package:flutter/material.dart';

import '../sqlite/sqlite_model.dart';
import '../sqlite/sqlite_repository.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  SqliteRepository sqliteRepository = SqliteRepository();
  var _imc = const <SqliteModel>[];

  @override
  void initState() {
    getImc();
    super.initState();
  }

  void getImc() async {
    _imc = await sqliteRepository.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Cálculos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _imc.length,
                  itemBuilder: (BuildContext bc, int index) {
                    var imc = _imc[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (DismissDirection dismissDirection) async {
                        sqliteRepository.delete(imc.id);
                        getImc();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: Card(
                          elevation: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text(
                                imc.data,
                                style: const TextStyle(fontSize: 18),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Altura: ${(imc.altura).toStringAsFixed(2)} m',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Peso: ${(imc.peso).toStringAsFixed(2)} Kg',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'IMC: ${(imc.resultado).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
