import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 29, 68, 31)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter stages MC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _entreprises = [];
  //int _counter = 0;
  final _myWordController1 = TextEditingController();
  final _myWordController2 = TextEditingController();
  final _myWordController3 = TextEditingController();
  final Map<String, dynamic> _infosEntreprise = {
    'titre': 'Entreprises',
    'selectedIndex': 0,
    'onTap': false
  };

  Future<void> _chargeEntreprises(String myWordController1, String myWordController2, String myWordController3) async {
    var url = Uri.parse(
        'https://dptinfo.iutmetz.univ-lorraine.fr/applis/flutter_api_s3/api/getByKeywords.php?mc1=${myWordController1}&mc2=${myWordController2}&mc3=${myWordController3}');
    var response = await http.get(url);
    setState(() {
      _entreprises = [];
      final donnees = jsonDecode(response.body);
      donnees.map((e) => e as Map<String, dynamic>).forEach((element) {
        _entreprises.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth < 280
            ? const Center(child: Text('Largeur minimale : 280'))
            : constraints.maxHeight < 300
            ? const Center(child: Text('Hauteur minimale : 300'))
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: 100,
                          child: (
                          Column(
                            children: [
                              TextField(
                                controller: _myWordController1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Mot-clé 1'),
                              ),
                            ],
                          )
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: (
                          Column(
                            children: [
                              TextField(
                                controller: _myWordController2,
                                decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                  labelText: 'Mot-clé 2'),
                              ),
                            ],
                          )
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: (
                          Column(
                            children: [
                              TextField(
                                controller: _myWordController3,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Mot-clé 3'),
                              ),
                            ],
                          )
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: () { },
                          child: const Text('Actualiser'),
                        ),
                     /* ],
                      ),
                      ),*/
                      //child: Column(
                        if (constraints.maxWidth <= 975 ||
                            constraints.maxHeight >= 500)
                          _entreprises.isEmpty
                              ? const CircularProgressIndicator()
                              : constraints.maxHeight < 500
                                  ? SizedBox(
                                      width: 200,
                                      height: 300,
                                      child: buildListe(
                                          context, _entreprises, _infosEntreprise),
                                    )
                                  : _buildGrilleEntreprises(
                                      constraints.maxHeight - 300)
                      //);
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildRowOrColumn(
      double hauteurMax, double largeurMax, Axis rowColumn) {
    // en ligne, l'un à côté de l'autre, donc largeur divisée par 2
    // en colonne, l'un au-dessus de l'autre, donc hauteur divisée par 2
    rowColumn == Axis.horizontal ? largeurMax /= 2 : hauteurMax /= 2;
    return Flex(
      direction: rowColumn,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildZoneAppel("ADN", hauteurMax, largeurMax),
        _buildZoneAppel("Guess my number", hauteurMax, largeurMax),
      ],
    );
  }

  Widget _buildGrilleEntreprises(double hauteur) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Nombre de résultats : ${_entreprises.length}',
          style: const TextStyle(fontSize: 18),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.all(8),
            height: hauteur,
            //color: Colors.blueGrey[100],
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _entreprises.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 7 / 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 30,
                  color: Colors.blueGrey[100],
                  padding: const EdgeInsets.all(8),
                  child: Text('${_entreprises[index]['nom']}'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListe(BuildContext context, List<Map<String, dynamic>> valeurs,
      Map<String, dynamic> typeInformation) {
    return Column(
      children: [
        Text(
          typeInformation['titre'],
          style: const TextStyle(fontSize: 18),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey[100]!),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 300,
            margin: const EdgeInsets.all(8),
            child: Material(
              child: ListView.builder(
                key: ObjectKey(valeurs[0]['code']),
                padding: const EdgeInsets.all(8),
                itemCount: valeurs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('${valeurs[index]['nom']}'),
                    tileColor: typeInformation['selectedIndex'] == index
                        ? Colors.blueGrey[100]
                        : null,
                    onTap: () {
                      setState(() {
                        typeInformation['selectedIndex'] = index;
                      });
                      typeInformation['callback'](valeurs[index]['code']!);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

    Widget _buildZoneAppel(String texte, double hauteurMax, double largeurMax) {
    //print("hauteurMax $hauteurMax");
    final seuils = [180, 120, 90, 78];
    if (hauteurMax > seuils[3]) {
      return Container(
        width: min(largeurMax, 200),
        height: min(
            150 + (hauteurMax > seuils[0] ? 32 : 0),
            hauteurMax),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: min(hauteurMax / 4, 32), horizontal: 10),
          child: _buildInterieurConteneur(texte, hauteurMax,
              seuils, largeurMax),
        ),
      );
    } else {
      return _buildInterieurConteneur(texte, hauteurMax, seuils,
          largeurMax);
    }
  }

  Column _buildInterieurConteneur(String texte,
      double hauteurMax, List<int> seuils, double largeurMax,
      ) {
    if (largeurMax < 160) {
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {  },
          child: Text(
            texte,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hauteurMax > seuils[1]) const Spacer(),
      ],
    );
  }
}

