import 'package:flutter/material.dart';
import 'package:imc_flutter_app/pages/records_page.dart';

import '../sqlite/sqlite_model.dart';
import '../sqlite/sqlite_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();

  double imc = 0;
  double altura = 0;
  double peso = 0;

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

  void calcular() {
    imc = peso / (altura * altura);
  }

  @override
  void dispose() {
    pesoController.dispose();
    alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Calculadora de  IMC do Zimba")),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset("lib/images/imc.png"),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Calcule agora seu IMC",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: pesoController,
                      onChanged: (value) {},
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(hintText: "Digite seu peso"),
                    )),
                const SizedBox(
                  height: 50,
                ),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: alturaController,
                      onChanged: (value) {},
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(hintText: "Digite sua altura"),
                    )),
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextButton(
                    onPressed: () async {
                      if (pesoController.text.trim().isEmpty ||
                          pesoController.text.trim() == 0.toString()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("O peso deve ser preenchido")));
                        return;
                      }

                      if (alturaController.text.trim().isEmpty ||
                          alturaController.text.trim() == 0.toString()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("A altura deve ser preenchida")));
                        return;
                      }

                      setState(() {
                        try {
                          peso = double.parse(
                              pesoController.text.replaceAll(",", ".").trim());
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text('IMC App'),
                                  content: const Text(
                                      'Favor informar um peso válido'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ok'))
                                  ],
                                );
                              });
                          return;
                        }

                        try {
                          altura = double.parse(alturaController.text
                              .replaceAll(",", ".")
                              .trim());
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text('IMC App'),
                                  content: const Text(
                                      'Favor informar uma altura válida'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ok'))
                                  ],
                                );
                              });
                          return;
                        }

                        calcular();

                        showDialog(
                            context: context,
                            builder: (BuildContext bc) {
                              return AlertDialog(
                                title: Text(
                                    "Seu IMC é: \n${imc.toStringAsFixed(2)}"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RecordsPage()));
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                      });
                      await sqliteRepository
                          .save(SqliteModel(0, altura, peso, imc));
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey)),
                    child: const Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        context: context,
                        builder: (BuildContext bc) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Image.asset("lib/images/tabela-imc.png"),
                              ],
                            ),
                          );
                        });
                  },
                  child: const Text(
                    "Entenda seu IMC",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecordsPage()));
                  },
                  child: const Text(
                    "Histórico",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
