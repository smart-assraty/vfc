import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'connector.dart';
import 'score_row.dart';

class ScoreBoard extends StatefulWidget{
  final Connector connector = const Connector();

  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => ScoreBoardState();
}

bool check = true;

class ScoreBoardState extends State<ScoreBoard>{
  String timer = "";
  late Future<int> generated;
  bool error = false;
  final channel = WebSocketChannel.connect(Uri.parse("ws://185.146.3.41:8000/match_result/"));

  @override
  Widget build(BuildContext context){
    TextEditingController controller = TextEditingController();
    return Scaffold(
     body: Column(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 10, 100, 0),
              child: FormField<bool>(builder: (state){
                return Column(
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "ID of player",
                        hintStyle: TextStyle(fontSize: 24),
                      ),
                    ),
                    (error) ? Text(state.errorText ?? "", style: TextStyle(color: Theme.of(context).errorColor,)) : const SizedBox(),
                    Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    try{
                      widget.connector.addPlayer(controller.text);
                    } catch(e){
                      debugPrint("[Error on Add Player]: $e");
                    }
                  }, 
                  child: const Text("Add Player", style: TextStyle(fontSize: 16),)
                ),
              ),
                  ],
                );
              },
              validator: (value) {
                if(error){
                  debugPrint(error.toString());
                  return "No such player or player is already on the match";
                } else {
                  debugPrint(error.toString());
                  return null;
                }
              },),
            ),
          ],
        )
      
    );
  }

  Widget table(List<DataRow> dataRows){
    return DataTable(
      dataRowHeight: 50,
      columns: const [
        DataColumn(label: Text("ID")),
        DataColumn(label: Text("Jump")),
        DataColumn(label: Text("Dribble")),
        DataColumn(label: Text("Pass")),
        DataColumn(label: Text("Accuracy")),
        DataColumn(label: Text("")),
      ], 
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
      List<ScoreRow> cells = [];
      timer = "Match #00${data["id"]} - ${DateTime.now().hour}:${DateTime.now().minute}";
      (data["players"] as Map<String, dynamic>).forEach((key, value) {
        cells.add(ScoreRow.fromJson({key: value})); 
      }); 
      for(int index = 0; index < cells.length; index++){
        dataRows.add(DataRow(
          onLongPress: () => Routemaster.of(context).push("/game_selecter/?id=${cells.elementAt(index).id}"), 
          cells: [DataCell(cells.elementAt(index).getPlayerNumber()), DataCell(cells.elementAt(index).getJump()), DataCell(cells.elementAt(index).getDribbling()), DataCell(cells.elementAt(index).getPass()), DataCell(cells.elementAt(index).getAccuracy()), DataCell(cells.elementAt(index).getPermissionButton(check))],),);
      }
      return dataRows;
    } catch (e){
      debugPrint("[Error on generate()]: $e");
      return [];
    }
  }
}