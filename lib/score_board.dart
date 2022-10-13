import 'package:flutter/material.dart';

import 'connector.dart';
import 'table_generator.dart';

class TV extends StatefulWidget{
  final TableGenerator tableGenerator = const TableGenerator();
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
                child: widget.tableGenerator.retail(true, context, timer, "jump"),
              )
            ),
          ],
        )
      )
    );
  }
}

class OperatorBoard extends StatefulWidget{
  final String game;
  final Connector connector = const Connector();
  final TableGenerator tableGenerator = const TableGenerator();

  const OperatorBoard({super.key, required this.game});

  @override
  State<OperatorBoard> createState() => OperatorBoardState();
}

class OperatorBoardState extends State<OperatorBoard>{
  String timer = "";
  bool error = false;

  @override
  Widget build(BuildContext context){
    TextEditingController controller = TextEditingController();
    return Scaffold(
     body: 
     Column(
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: widget.tableGenerator.retail(false, context, timer, widget.game),
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
          ),
    );
  }
}