import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:timer_builder/timer_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

import 'connector.dart';
import 'score_row.dart';
import 'score_board.dart';
import 'games.dart';

String server = "http://185.146.3.41";

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
  "/score_board/:game": (route) => MaterialPage(child: ScoreBoard(game: route.pathParameters["game"]!)),
  "/jump": (route) => MaterialPage(child: JumpPage(id: route.queryParameters["id"]!,)),
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
  String timer = "";

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
            const Image(image: AssetImage("visa.png"), height: 120),
            Center(
              child: Text(
                timer,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(
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
    return DataTable2(
      dataRowHeight: 100,
      columns: [
        DataColumn2(fixedWidth: 100, label: Text("#", style: tableHeaderStyle)),
        //DataColumn2(fixedWidth: 120, label: Text(" ", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.L, label: Text("Last Name", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Jump", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Dribbling", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Accuracy", style: tableHeaderStyle)),
        DataColumn2(size: ColumnSize.S, label: Text("Pass", style: tableHeaderStyle)),
      ], 
      dividerThickness: 10,
      rows: dataRows
    );
  }

  Widget retail(){
    return TimerBuilder.periodic(const Duration(seconds: 3), builder: (context){
      return FutureBuilder(
        future: generate(),
        builder: (context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            return table(snapshot.data);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        });
    });
  }

  Future<List<DataRow>> generate()async{
    try{
      var response = await widget.connector.getScoreBoardData();
      Map<String, dynamic> data = response;
      List<DataRow> dataRows = [];
      List<ScoreRow> cells = [];
      timer = "Match #00${data["id"]} - ${DateTime.now().hour}:${DateTime.now().minute}";

      if(response["players"] != null){
        (data["players"] as Map<String, dynamic>).forEach((key, value) {
          cells.add(ScoreRow.fromJson({key: value})); 
        }); 
      }
      
      for(int index = 0; index < cells.length; index++){
        dataRows.add(DataRow(
          onLongPress: () => Routemaster.of(context).push("/game_selecter/?id=${cells.elementAt(index).id}"),
          cells: [
            DataCell(cells.elementAt(index).getPlayerNumber(Colors.white)), 
            //DataCell(cells.elementAt(index).getPhoto()), 
            DataCell(cells.elementAt(index).getLastName(Colors.white)), 
            DataCell(cells.elementAt(index).getJump(Colors.white)), 
            DataCell(cells.elementAt(index).getDribbling(Colors.white)), 
            DataCell(cells.elementAt(index).getAccuracy(Colors.white)), 
            DataCell(cells.elementAt(index).getPass(Colors.white))],),);
      }
      return dataRows;
    } catch (e){
      debugPrint("[Error on generate()]: $e");
      return [];
    }
  }
}