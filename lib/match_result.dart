import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:routemaster/routemaster.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'connector.dart';
import 'score_row.dart';

class MatchResult extends StatefulWidget{
  final Connector connector = const Connector();

  const MatchResult({super.key});

  @override
  State<MatchResult> createState() => MatchResultState();
}

bool check = true;

class MatchResultState extends State<MatchResult>{
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
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: const [Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
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
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "0000000000",
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () async {
                  var response = await post(Uri.parse("$server:8000/add_player/?id=${controller.text}"));
                  debugPrint("${response.body} ${response.statusCode}");
                  if(response.statusCode == 200){
                    setState(() {
                      dynamic theJson = json.decode(response.body);
                      cells.add(ScoreRow(playerNumber: theJson["player_number"], photo: null, lastName: "", jump: 0, dribbling: "0", accuracy: "0", pass: "0"));
                      dataRows.add(DataRow(
          onLongPress: () => showDialog(context: context, builder: (context){
            return Card(
              child: Row(
                children: [
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/jump/?id=${cells.last.playerNumber}"), child: const Text("Jump")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/dribble/?id=${cells.last.playerNumber}"), child: const Text("Dribble")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/pass/?id=${cells.last.playerNumber}"), child: const Text("Pass")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/accuracy/?id=${cells.last.playerNumber}"), child: const Text("Accuracy")),
                ],
              ),
            );
          }),
          cells: [DataCell(cells.last.getPlayerNumber()), DataCell(cells.last.getJump()), DataCell(cells.last.getDribbling()), DataCell(cells.last.getAccuracy()), DataCell(cells.last.getPass()), DataCell(cells.last.getPermissionButton(check))],),);
                    });
                  }
                }, 
                child: const Text("Add Player")
              ),
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
        DataColumn(label: Text("")),
        DataColumn(label: Text("")),
        DataColumn(label: Text("")),
        DataColumn(label: Text("")),
        DataColumn(label: Text("")),
        DataColumn(label: Text("")),
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
      for(int index = 0; index < (data["players"] as Map<String, dynamic>).length; index++){
        cells.add(ScoreRow.fromJson((data["players"] as Map<String, dynamic>).entries.elementAt(index).value));
      }
      for(int index = 0; index < cells.length; index++){
        dataRows.add(DataRow(
          onLongPress: () => showDialog(context: context, builder: (context){
            return Card(
              child: Row(
                children: [
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/jump/?id=${cells.elementAt(index).playerNumber}"), child: const Text("Jump")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/dribble/?id=${cells.elementAt(index).playerNumber}"), child: const Text("Dribble")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/pass/?id=${cells.elementAt(index).playerNumber}"), child: const Text("Pass")),
                  OutlinedButton(onPressed: () => Routemaster.of(context).push("/accuracy/?id=${cells.elementAt(index).playerNumber}"), child: const Text("Accuracy")),
                ],
              ),
            );
          }),
          cells: [DataCell(cells.elementAt(index).getPlayerNumber()), DataCell(cells.elementAt(index).getJump()), DataCell(cells.elementAt(index).getDribbling()), DataCell(cells.elementAt(index).getAccuracy()), DataCell(cells.elementAt(index).getPass()), DataCell(cells.elementAt(index).getPermissionButton(check))],),);
      }
      return 0;
    } catch (e){
      debugPrint("catch");
      debugPrint("Error: $e");
      return 1;
    }
  }
}