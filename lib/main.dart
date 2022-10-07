import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'connector.dart';
import 'score_row.dart';
import 'score_board.dart';
import 'games.dart';

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
    theme: ThemeData(fontFamily: "Arial"),
  ));
}

final routes = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: TV()),
  "/score_board": (_) => const MaterialPage(child: ScoreBoard()),
  "/game_selecter": (route) => MaterialPage(child: GameSelecter(id: route.queryParameters["id"]!)),
  "/jump": (route) => MaterialPage(child: JumpPage(id: route.queryParameters["id"]!)),
  "/dribble": (route) => MaterialPage(child: DribblePage(id: route.queryParameters["id"]!)),
  "/pass": (route) => MaterialPage(child: PassPage(id: route.queryParameters["id"]!)),
  "/accuracy": (route) => MaterialPage(child: AccuracyPage(id: route.queryParameters["id"]!)),
});

class TV extends StatefulWidget{
  final Connector connector = const Connector();
  const TV({super.key});

  @override
  State<TV> createState() => TVState();
}

class TVState extends State<TV>{
  List<ScoreRow> cells = [];
  String timer = "";

  final channel = WebSocketChannel.connect(Uri.parse("ws://185.146.3.41:8000/match_result/"));

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
                child: retail()
              )
            ),
          ],
        )
      )
    );
  }

  TextStyle tableHeaderStyle = const TextStyle(color: Colors.white, fontSize: 20);
  Widget table(List<DataRow> dataRows){
    return DataTable(
      dataRowHeight: 70,
      columns: [
        DataColumn(label: Text("#", style: tableHeaderStyle)),
        DataColumn(label: Text(" ", style: tableHeaderStyle)),
        DataColumn(label: Text("Last Name", style: tableHeaderStyle)),
        DataColumn(label: Text("Jump", style: tableHeaderStyle)),
        DataColumn(label: Text("Dribbling", style: tableHeaderStyle)),
        DataColumn(label: Text("Accuracy", style: tableHeaderStyle)),
        DataColumn(label: Text("Pass", style: tableHeaderStyle)),
      ], 
      dividerThickness: 10,
      rows: dataRows
    );
  }

  Widget retail(){
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          //debugPrint(snapshot.data);
          return table(generate(json.decode(utf8.decode(snapshot.data.toString().codeUnits))));
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      });
  } 

  List<DataRow> generate(Map<String, dynamic> data){
    try{
      List<DataRow> dataRows = [];
      timer = "Match #00${data["id"]} - ${DateTime.now().hour}:${DateTime.now().minute}";

      (data["players"] as Map<String, dynamic>).forEach((key, value) {
        cells.add(ScoreRow.fromJson({key: value})); 
      }); 
      
      for(int index = 0; index < cells.length; index++){
        dataRows.add(DataRow(
          onLongPress: () => Routemaster.of(context).push("/game_selecter/?id=${cells.elementAt(index).id}"),
          cells: [DataCell(cells.elementAt(index).getPlayerNumber()), DataCell(cells.elementAt(index).getPhoto()), DataCell(cells.elementAt(index).getLastName()), DataCell(cells.elementAt(index).getJump()), DataCell(cells.elementAt(index).getDribbling()), DataCell(cells.elementAt(index).getAccuracy()), DataCell(cells.elementAt(index).getPass())],),);
      }
      return dataRows;
    } catch (e){
      debugPrint("[Error on generate()]: $e");
      return [];
    }
  }
}