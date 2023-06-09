import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  List<Inscrit> inscrits = [];
  String selectedClasse;

  Future<List<Inscrit>> fetchInscrits({String classe}) async {
    final queryParams = classe != null ? '?classe=$classe' : '';
    final url = Uri.parse('http://your-api-url/api/inscription$queryParams');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Inscrit> inscrits = [];
      for (var item in jsonData) {
        inscrits.add(Inscrit.fromJson(item));
      }
      return inscrits;
    } else {
      throw Exception('Failed to fetch inscrits');
    }
  }

  void fetchAndSetInscrits({String classe}) {
    fetchInscrits(classe: classe)
        .then((data) => setState(() {
              inscrits = data;
            }))
        .catchError((error) => print(error));
  }

  @override
  void initState() {
    fetchAndSetInscrits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des inscrits'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedClasse,
            hint: Text('Sélectionnez une classe'),
            items: <String>['L1 MAE', 'L2 MAE', 'L3 MAE']
                .map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedClasse = value;
              });
              fetchAndSetInscrits(classe: value);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inscrits.length,
              itemBuilder: (ctx, index) {
                final inscrit = inscrits[index];
                return ListTile(
                  title: Text('${inscrit.nom} ${inscrit.prenom}'),
                  subtitle: Text(inscrit.classe),
                  trailing: Text(inscrit.matricule),
                  onTap: () {
                    // Gérer le tap sur un étudiant inscrit
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Inscrit {
  final String nom;
  final String prenom;
  final String classe;
  final String matricule;
  final String email;

  Inscrit({this.nom, this.prenom, this.classe, this.matricule, this.email});

  factory Inscrit.fromJson(Map<String, dynamic> json) {
    return Inscrit(
      nom: json['nom'],
      prenom: json['prenom'],
      classe: json['classe'],
      matricule: json['matricule'],
      email: json['email'],
    );
  }
}
