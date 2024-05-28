import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_webservice_2100016016/model/mobil.dart';

class MobilPage extends StatefulWidget {
  const MobilPage({Key? key}) : super(key: key);

  @override
  _MobilPageState createState() => _MobilPageState();
}

class _MobilPageState extends State<MobilPage> {
  Future<List<Mobil>> fetchMobil() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    var response = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/json",
    });

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Mobil> listMobil = [];
    for (var d in data) {
      if (d != null) {
        listMobil.add(Mobil.fromJson(d));
      }
    }
    return listMobil;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobil List'),
      ),
      body: FutureBuilder(
        future: fetchMobil(),
        builder: (context, AsyncSnapshot<List<Mobil>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Data Available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var mobil = snapshot.data![index];
                return ListTile(
                  title: Text(mobil.brand),
                  subtitle: Text(mobil.model),
                  trailing: Text(mobil.color),
                );
              },
            );
          }
        },
      ),
    );
  }
}
