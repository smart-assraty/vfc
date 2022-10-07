import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter/material.dart';

import 'connector.dart';
import 'score_row.dart';
import 'match_result.dart';
import 'junk.dart';

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
  "/score_board": (_) => const MaterialPage(child: MatchResult()),
  "/jump": (route) => MaterialPage(child: JumpPage(id: route.queryParameters["id"]!)),
  "/dribble": (route) => MaterialPage(child: DribblePage(id: route.queryParameters["id"]!)),
  "/pass": (route) => MaterialPage(child: PassPage(id: route.queryParameters["id"]!)),
  "/accuracy": (route) => MaterialPage(child: AccuracyPage(id: route.queryParameters["id"]!)),
});

class ScoreBoard extends StatefulWidget{
  final Connector connector = const Connector();
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => ScoreBoardState();
}

class ScoreBoardState extends State<ScoreBoard>{
  List<ScoreRow> cells = [];
  String timer = "";
  late Future<int> generated;

  @override
  void initState() {
    generated = generate();
    super.initState();
  }

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

  List<DataRow> dataRows = [];

  Widget table(){
    return DataTable(
      dataRowHeight: 70,
      columns: const [
        DataColumn(label: Text("#")),
        DataColumn(label: Text("")),
        DataColumn(label: Text("Last Name")),
        DataColumn(label: Text("Jump")),
        DataColumn(label: Text("Dribbling")),
        DataColumn(label: Text("Accuracy")),
        DataColumn(label: Text("Pass")),
      ], 
      rows: dataRows
    );
  }

  Widget retail(){
    return TimerBuilder.periodic(
      const Duration(seconds: 2),
      builder: (context){
        return FutureBuilder(
          future: generated,
          builder: (context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
              return table();
            } else {
              if(cells.isNotEmpty){
                return table();
              }
              return const SizedBox();
            }
          });
      }
    );
  } 

  Future<int> generate() async {
    try{
      var data = await widget.connector.getScoreBoardData();
      timer = "Match #00${data["id"]} - ${DateTime.now().hour}:${DateTime.now().minute}";

      (data["players"] as Map<String, dynamic>).forEach((key, value) {
        cells.add(ScoreRow.fromJson({key: value})); 
      }); 
      
      for(int index = 0; index < cells.length; index++){
        dataRows.add(DataRow(
          onLongPress: () => showDialog(context: context, builder: (context){
            return Card(
              child: Row(
                children: [
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/jump/?id=${cells.elementAt(index).id}"), child: const Text("Jump")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/dribble/?id=${cells.elementAt(index).id}"), child: const Text("Dribble")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/pass/?id=${cells.elementAt(index).id}"), child: const Text("Pass")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/accuracy/?id=${cells.elementAt(index).id}"), child: const Text("Accuracy")),
                ],
              ),
            );
          }),
          cells: [DataCell(cells.elementAt(index).getPlayerNumber()), DataCell(cells.elementAt(index).getPhoto()), DataCell(cells.elementAt(index).getLastName()), DataCell(cells.elementAt(index).getJump()), DataCell(cells.elementAt(index).getDribbling()), DataCell(cells.elementAt(index).getAccuracy()), DataCell(cells.elementAt(index).getPass())],),);
      }
      return 0;
    } catch (e){
      debugPrint("catch");
      debugPrint("Error: $e");
      return 1;
    }
  }
}