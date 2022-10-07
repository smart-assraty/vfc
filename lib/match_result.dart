import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:routemaster/routemaster.dart';

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
  bool error = false;

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
        toolbarHeight: 90,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("operator 1"),
            Image(image: AssetImage("visa.png"), height: 90,)
          ],
        ),
      ), 
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
                    (state.hasError) ? Text(state.errorText ?? "", style: TextStyle(color: Theme.of(context).errorColor,)) : const SizedBox(),
                    Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () async {
                    var response = await widget.connector.addPlayer(controller.text);
                    if(response == 200){
                    } else {
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
      )
    );
  }

  List<DataRow> dataRows = [];

  Widget table(){
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
          cells: [DataCell(cells.elementAt(index).getPlayerNumber()), DataCell(cells.elementAt(index).getJump()), DataCell(cells.elementAt(index).getDribbling()), DataCell(cells.elementAt(index).getPass()), DataCell(cells.elementAt(index).getAccuracy()), DataCell(cells.elementAt(index).getPermissionButton(check))],),);
      }
      return 0;
    } catch (e){
      debugPrint("catch");
      debugPrint("Error: $e");
      return 1;
    }
  }
}