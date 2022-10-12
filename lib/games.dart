import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'main.dart';

class JumpPage extends StatefulWidget{
  final String id;
  const JumpPage({super.key, required this.id});

  @override
  State<JumpPage> createState() => JumpPageState();
}

class JumpPageState extends State<JumpPage>{
  TextEditingController controller = TextEditingController();
  String tries = "1/1";
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          const Text("Jump"),
          Center(
            child: Center(
              child: 
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                    hintText: "Jump score",
                  ),
                  ),
                )
              
            ),
          ),
          OutlinedButton(onPressed:() async {
            if(!clicked){
              setState(() {
                clicked = true;
              });
              var response = await post(Uri.parse("$server:8000/jump_result/"),
                headers: {"Content-type": "application/json"},
                body: json.encode({
                  "player_id": int.parse(widget.id),
                  "jump_height": int.parse(controller.text),
                })
              );
              var theJson = json.decode(response.body);
              setState(() {
                tries = utf8.decode(theJson["message"].toString().codeUnits);
                debugPrint(tries.codeUnits.toString());
                controller.text = "";
                Routemaster.of(context).push("/score_board");
              });
            } else {
              null;
            }
          },
          child: (clicked) ? const CircularProgressIndicator() : const Text("Done")),
        ],
      ),
    );
  }
}

class DribblePage extends StatefulWidget{
  final String id;
  const DribblePage({super.key, required this.id});

  @override
  State<DribblePage> createState() => DribblePageState();
}

class DribblePageState extends State<DribblePage>{
  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();
  String tries = "1/3";
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          const Text("Dribble"),
          Center(
          child: SizedBox(
                width: 250,
              child: Column(children: [
                TextFormField(
                  controller: controllerOne,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Hits",
                  ),
                ),
                TextFormField(
                  controller: controllerTwo,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Cones",
                  ),
                ),
              ],)
              ),
            
          ),
          OutlinedButton(onPressed:() async {
            if(!clicked){
              setState(() {
                clicked = true;
              });
              try{
              if(tries != "3/3"  || tries != "Исчерпано количество попыток!"){
                  var response = await post(Uri.parse("$server:8000/dribbling_result/"),
                    headers: {"Content-type": "application/json"},
                    body: json.encode({
                    "player_id": int.parse(widget.id),
                    "time": int.parse(controllerOne.text),
                    "cone": int.parse(controllerTwo.text),
                    })
                  );
                  var theJson = json.decode(response.body);
                  setState(() {
                    tries = utf8.decode(theJson["message"].toString().codeUnits);
                    controllerOne.text = "";
                    controllerTwo.text = "";
                    clicked = false;
                  });
                } else {
                    setState(() {
                      clicked = true;
                      Routemaster.of(context).push("/score_board");
                    });
                }
              } catch(e){
                debugPrint("[Error on Done]: $e");
              }
            } else {
              null;
            }
          },
          child: (clicked) ? const CircularProgressIndicator() : const Text("Done")),
        ],
      ),
    );
  }
}

class AccuracyPage extends StatefulWidget{
  final String id;
  const AccuracyPage({super.key, required this.id});

  @override
  State<AccuracyPage> createState() => AccuracyPageState();
}

class AccuracyPageState extends State<AccuracyPage>{
  TextEditingController controller = TextEditingController();
  String tries = "1/2";
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          const Text("Accuracy"),
          Center(
            child: Center(
              child: SizedBox(
                width: 250,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Accuracy score",
                  ),
                ),
                ),
            ),
          ),
          OutlinedButton(onPressed:() async {
            if(!clicked){
              setState(() {
                clicked = true;
              });
              var response = await post(Uri.parse("$server:8000/accuracy_result/"),
                headers: {"Content-type": "application/json"},
                body: json.encode({
                "player_id": int.parse(widget.id),
                "hits": int.parse(controller.text),
              })
              );
              var theJson = json.decode(response.body);
              if(tries != "2/2" || tries != "Исчерпано количество попыток!"){
                setState(() {
                  tries = utf8.decode(theJson["message"].toString().codeUnits);
                  controller.text = "";
                  clicked = false;
                });
              } else {
                  setState(() {
                    clicked = true;
                    Routemaster.of(context).push("/score_board");
                    clicked = false;
                  });
              } 
            } else {
              null;
            }
          },
          child: (clicked) ? const CircularProgressIndicator() : const Text("Done")),
        ],
      ),
    );
  }
}

class PassPage extends StatefulWidget{
  final String id;
  const PassPage({super.key, required this.id});

  @override
  State<PassPage> createState() => PassPageState();
}

class PassPageState extends State<PassPage>{
  TextEditingController controller = TextEditingController();
  String tries = "1/3";
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          const Text("Pass"),
          Center(
            child: SizedBox(
                  width: 250,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                ),
                ),
          ),
          OutlinedButton(onPressed:() async {
            if(!clicked){
              setState(() {
                clicked = true;
              });
              var response = await post(Uri.parse("$server:8000/pass_result/"),
                headers: {"Content-type": "application/json"},
                body: json.encode({
                "player_id": int.parse(widget.id),
                "hits": int.parse(controller.text),
              })
              );
              var theJson = json.decode(response.body);
              if(tries != "3/3"  || tries != "Исчерпано количество попыток!"){
                setState(() {
                  tries = utf8.decode(theJson["message"].toString().codeUnits);
                  controller.text = "";
                  clicked = false;
                });
              } else {
                  setState(() {
                    clicked = true;
                    Routemaster.of(context).push("/score_board");
                  });
              }
            } else {
              null;
            }
          },
          child: (clicked) ? const CircularProgressIndicator() : const Text("Done")),
        ],
      ),
    );
  }
}