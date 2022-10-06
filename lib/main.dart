import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'connector.dart';
import 'score_row.dart';

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
    theme: ThemeData(fontFamily: "Arial"),
  ));
}

final routes = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: ScoreBoard()),
});

//TEST
dynamic theJson = json.encode({
  "id": 85,
  "status": "active",
  "players": {
    "1056": {
      "last_name": "Brandon",
      "player_number": 17,
      "photo_url": "$server/url.png",
      "jump": 72,
      "dribbling": "00:15",
      "accuracy": "6/7",
      "pass": "7/10"
    },
    "1057": {
      "last_name": "Joe",
      "player_number": 77,
      "photo_url": "$server/url.png",
      "jump": 89,
      "dribbling": "00:13",
      "accuracy": "5/7",
      "pass": "8/10"
    },
    "1055": {
      "last_name": "Gray",
      "player_number": 12,
      "photo_url": "$server/url.png",
      "jump": 77,
      "dribbling": "00:11",
      "accuracy": "6/7",
      "pass": "5/10"
    },
    "1060": {
      "last_name": "Don",
      "player_number": 2,
      "photo_url": "$server/url.png",
      "jump": 80,
      "dribbling": "00:12",
      "accuracy": "7/7",
      "pass": "8/10"
    }
  }
});
//TEST

class ScoreBoard extends StatefulWidget{
  final Connector connector = const Connector();
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => ScoreBoardState();
}

class ScoreBoardState extends State<ScoreBoard>{
  List<ScoreRow> cells = [];
  late String timer;
  
  //TEST
  @override
  void initState() {
    super.initState();
    timer = "Match #00${json.decode(theJson)["id"]} - ${DateTime.now().hour}:${DateTime.now().minute}";
    for(int index = 0; index < 4; index++){
      cells.add(ScoreRow.fromJson((json.decode(theJson)["players"] as Map<String, dynamic>).entries.elementAt(index).value));
    }
  }
  //TEST

  @override
  Widget build(BuildContext context){
    return Scaffold(
     body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
          Color.fromARGB(255, 26, 31, 113),
          Color.fromARGB(255, 34, 84, 164),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.9]),
        ),
        child: Column(
          children: [
            const Center(child: Image(image: AssetImage("visa.png"), height: 170, width: 300,)),
            Center(
              child: Text(
                timer,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: table() //TEST change to retail()
              )
            ),
          ],
        )
      )
    );
  }

  Widget table(){
    return DataTable(
      dataRowHeight: 70,
      columns: const [
        DataColumn(label: Text("#", style: TextStyle(color: Colors.grey),)),
        DataColumn(label: Text("")),
        DataColumn(label: Text("Last Name", style: TextStyle(color: Colors.grey))),
        DataColumn(label: Text("Jump", style: TextStyle(color: Colors.grey))),
        DataColumn(label: Text("Dribbling", style: TextStyle(color: Colors.grey))),
        DataColumn(label: Text("Accuracy", style: TextStyle(color: Colors.grey))),
        DataColumn(label: Text("Pass", style: TextStyle(color: Colors.grey))),
      ], 
      rows: [
        DataRow(cells: [DataCell(cells.elementAt(0).getPlayerNumber()), DataCell(cells.elementAt(0).getPhoto()), DataCell(cells.elementAt(0).getLastName()), DataCell(cells.elementAt(0).getJump()), DataCell(cells.elementAt(0).getDribbling()), DataCell(cells.elementAt(0).getAccuracy()), DataCell(cells.elementAt(0).getPass())],),
        DataRow(cells: [DataCell(cells.elementAt(1).getPlayerNumber()), DataCell(cells.elementAt(1).getPhoto()), DataCell(cells.elementAt(1).getLastName()), DataCell(cells.elementAt(1).getJump()), DataCell(cells.elementAt(1).getDribbling()), DataCell(cells.elementAt(1).getAccuracy()), DataCell(cells.elementAt(1).getPass())],),
        DataRow(cells: [DataCell(cells.elementAt(2).getPlayerNumber()), DataCell(cells.elementAt(2).getPhoto()), DataCell(cells.elementAt(2).getLastName()), DataCell(cells.elementAt(2).getJump()), DataCell(cells.elementAt(2).getDribbling()), DataCell(cells.elementAt(2).getAccuracy()), DataCell(cells.elementAt(2).getPass())],),
        DataRow(cells: [DataCell(cells.elementAt(3).getPlayerNumber()), DataCell(cells.elementAt(3).getPhoto()), DataCell(cells.elementAt(3).getLastName()), DataCell(cells.elementAt(3).getJump()), DataCell(cells.elementAt(3).getDribbling()), DataCell(cells.elementAt(3).getAccuracy()), DataCell(cells.elementAt(3).getPass())],),
      ]
    );
  }

  Widget retail(){
    return TimerBuilder.periodic(
      const Duration(seconds: 2),
      builder: (context){
        return FutureBuilder(
          future: generate(),
          builder: (context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
              return table();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
      }
    );
  } 

  Future<void> generate() async {
    var data = await widget.connector.getScoreBoardData();
    timer = "Match #00${json.decode(data)["id"]} - ${DateTime.now().hour}:${DateTime.now().minute}";
    for(int index = 0; index < 4; index++){
      cells.add(ScoreRow.fromJson((json.decode(data)["players"] as Map<String, dynamic>).entries.elementAt(index).value));
    }
  }
}