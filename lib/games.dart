import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'main.dart';

class JumpPage extends StatefulWidget{
  final String id;
  final int maxTries;
  int currentTry = 1;
  JumpPage({super.key, required this.id, required this.maxTries});

  @override
  State<JumpPage> createState() => JumpPageState();
}

class JumpPageState extends State<JumpPage>{
  TextEditingController controller = TextEditingController();
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    String tries = "${widget.currentTry}/${widget.maxTries}";
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          Text("Jump $tries"),
          Center(
            child: SizedBox(
              width: 250,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jump score",
                ),
              ),
            )  
          ),
          OutlinedButton(
            onPressed:() async {
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
  final int maxTries;
  int currentTry = 1;
  DribblePage({super.key, required this.id, required this.maxTries});

  @override
  State<DribblePage> createState() => DribblePageState();
}

class DribblePageState extends State<DribblePage>{
  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    String tries = "${widget.currentTry}/${widget.maxTries}";
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          Text("Dribble $tries"),
          Center(
          child: SizedBox(
                width: 250,
              child: Column(children: [
                TextFormField(
                  controller: controllerOne,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Hits",
                  ),
                ),
                TextFormField(
                  controller: controllerTwo,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Cones",
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
                var response = await post(Uri.parse("$server:8000/dribbling_result/"),
                  headers: {"Content-type": "application/json"},
                  body: json.encode({
                  "player_id": int.parse(widget.id),
                  "time": int.parse(controllerOne.text),
                  "cone": int.parse(controllerTwo.text),
                  })
                );
              if(tries != "3/3"){
                  var theJson = json.decode(response.body);
                  setState(() {
                    tries = utf8.decode(theJson["message"].toString().codeUnits);
                    controllerOne.text = "";
                    controllerTwo.text = "";
                    widget.currentTry++;
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
  final int maxTries;
  int currentTry = 1;
  AccuracyPage({super.key, required this.id, required this.maxTries});

  @override
  State<AccuracyPage> createState() => AccuracyPageState();
}

class AccuracyPageState extends State<AccuracyPage>{
  TextEditingController controller = TextEditingController();
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    String tries = "${widget.currentTry}/${widget.maxTries}";
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          Text("Accuracy $tries"),
          Center(
            child: Center(
              child: SizedBox(
                width: 250,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Accuracy score",
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
              if(tries != "2/2"){
                setState(() {
                  tries = utf8.decode(theJson["message"].toString().codeUnits);
                  controller.text = "";
                  widget.currentTry++;
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
  final int maxTries;
  int currentTry = 1;
  PassPage({super.key, required this.id, required this.maxTries});

  @override
  State<PassPage> createState() => PassPageState();
}

class PassPageState extends State<PassPage>{
  TextEditingController controller = TextEditingController();
  bool clicked = false;
  @override
  Widget build(BuildContext context){
    String tries = "${widget.currentTry}/${widget.maxTries}";
    return Scaffold(
      appBar: AppBar(
        title: const Text("operator 1"),
        actions: [
          Text(widget.id),
          const Image(image: AssetImage("visa.png"), height: 170, width: 300,)],),
      body: Column(
        children: [
          Text("Pass $tries"),
          Center(
            child: SizedBox(
                  width: 250,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Pass score",
                  ),
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
              if(tries != "3/3"){
                setState(() {
                  tries = utf8.decode(theJson["message"].toString().codeUnits);
                  controller.text = "";
                  widget.currentTry++;
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