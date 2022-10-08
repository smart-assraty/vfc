import 'package:timer_builder/timer_builder.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

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
  bool error = false;

  @override
  Widget build(BuildContext context){
    TextEditingController controller = TextEditingController();
    return Scaffold(
     body: SingleChildScrollView(
      child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(onPressed: () {
                  showDialog(context: context, builder: (context){
                    return Card(
                      child: Center(child: ElevatedButton(onPressed: () {
                        widget.connector.resetGame();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Are you sure about that?"),)),
                    );
                  });
                }, 
                child: const SizedBox(height: 50, width: 100, child: Center(child: Text("Reset Game"))),),
              ),
              Center(
                child: Text(
                  timer,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
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
     ),
    );
  }

  Widget table(List<DataRow> dataRows){
    return DataTable(
      dataRowHeight: 50,
      columns: const [
        DataColumn(label: Text("ID")),
        DataColumn(label: Text("Last Name")),
        //DataColumn(label: Text("Jump")),
        DataColumn(label: Text("Dribble")),
        DataColumn(label: Text("Pass")),
        DataColumn(label: Text("Accuracy")),
        DataColumn(label: Text("")),
      ], 
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

  Future<List<DataRow>> generate() async {
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
            DataCell(cells.elementAt(index).getPlayerNumber(null)), 
            DataCell(cells.elementAt(index).getLastName(null)), 
            //DataCell(cells.elementAt(index).getJump(null)), 
            DataCell(cells.elementAt(index).getDribbling(null)), 
            DataCell(cells.elementAt(index).getPass(null)), 
            DataCell(cells.elementAt(index).getAccuracy(null)), 
            DataCell(cells.elementAt(index).getPermissionButton(check))],),);
      }
      return dataRows;
    } catch (e){
      debugPrint("[Error on generate()]: $e");
      return [];
    }
  }
}