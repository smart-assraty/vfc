import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'connector.dart';
import 'match_result.dart';

class JumpPage extends StatefulWidget{
  final String id;
  const JumpPage({super.key, required this.id});

  @override
  State<JumpPage> createState() => JumpPageState();
}

class JumpPageState extends State<JumpPage>{
  TextEditingController controller = TextEditingController();
  int triesInt = 2;
  String tries = "1/5";
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Try $tries"),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: controller,
                  ),
                )
              ],
            ),
          ),
          OutlinedButton(onPressed:() async {
            if(tries != "5/5"){
              var response = await post(Uri.parse("$server:8000/jump_result/"),
                headers: {"Content-type": "application/json"},
                body: json.encode({
                  "player_id": int.parse(widget.id),
                  "jump_height": int.parse(controller.text),
                })
              );
              debugPrint(response.body);
              setState(() {
                tries = "$triesInt/5";
                controller.text = "";
                triesInt++;
              });
            } else {
                setState(() {
                  Routemaster.of(context).push("/score_board");
                  check = false;
                });
            }
          },
          child: const Text("Done")),
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
  int triesInt = 2;
  String tries = "1/5";
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
          const Text("Dribbling"),
          Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Try $tries"),
              SizedBox(
                width: 250,
              child: Column(children: [
                TextFormField(
                  controller: controllerOne,
                ),
                TextFormField(
                  controller: controllerTwo,
                ),
              ],)

              ),
            ],
          ),
          ),
          OutlinedButton(onPressed:() async {
            try{
              if(tries != "5/5"){
                var response = await post(Uri.parse("$server:8000/dribbling_result/"),
                  headers: {"Content-type": "application/json"},
                  body: json.encode({
                  "player_id": int.parse(widget.id),
                  "time": int.parse(controllerOne.text),
                  "cone": int.parse(controllerTwo.text),
                  })
                );
                debugPrint(response.body);
                setState(() {
                  tries = "$triesInt/5";
                  controllerOne.text = "";
                  controllerTwo.text = "";
                  triesInt++;
                });
              } else {
                  setState(() {
                    Routemaster.of(context).push("/score_board");
                    check = false;
                  });
              }
            } catch(e){
              debugPrint("$e");
            }
          },
          child: const Text("Done")),
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
  int triesInt = 2;
  String tries = "1/5";
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Try $tries"),
                SizedBox(
                  width: 250,
                child: TextFormField(
                  controller: controller,
                ),
                ),
              ],
            ),
          ),
          OutlinedButton(onPressed:() async {
            if(tries != "5/5"){
              var response = await post(Uri.parse("$server:8000/accuracy_result/"),
                headers: {"Content-type": "application/json"},
                body: json.encode({
                "player_id": int.parse(widget.id),
                "hits": int.parse(controller.text),
              })
              );
              debugPrint(response.body);
              setState(() {
                tries = "$triesInt/5";
                controller.text = "";
                triesInt++;
              });
            } else {
                setState(() {
                  Routemaster.of(context).push("/score_board");
                  check = false;
                });
            }
          },
          child: const Text("Done")),
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
  int triesInt = 2;
  String tries = "1/5";
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Try $tries"),
                SizedBox(
                  width: 250,
                child: TextFormField(
                  controller: controller,
                ),
                ),
              ],
            ),
          ),
          OutlinedButton(onPressed:()async {
            if(tries != "5/5"){
              var response = await post(Uri.parse("$server:8000/pass_result/"),
                headers: {"Content-type": "application/json"},
                body: json.encode({
                "player_id": int.parse(widget.id),
                "hits": int.parse(controller.text),
              })
              );
              debugPrint(response.body);
              setState(() {
                tries = "$triesInt/5";
                controller.text = "";
                triesInt++;
              });
            } else {
                setState(() {
                  Routemaster.of(context).push("/score_board");
                  check = false;
                });
            }
          },
          child: const Text("Done")),
        ],
      ),
    );
  }
}