import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'connector.dart';

class GameSelecter extends StatelessWidget{
  final String id;
  final connector = const Connector();
  const GameSelecter({super.key, required this.id});

  @override
  Widget build(BuildContext context){
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(onPressed: () {
            Routemaster.of(context).push("/jump/?id=$id");
          },
          child: const SizedBox(height: 50, width: 150, child: Center(child: Text("Jump")))
          ),
          OutlinedButton(onPressed: () {
            Routemaster.of(context).push("/dribble/?id=$id");
          },
           child: const SizedBox(height: 50, width: 150, child: Center(child: Text("Dribble")))),
          OutlinedButton(onPressed: () {
            Routemaster.of(context).push("/pass/?id=$id"); 
          },
          child: const SizedBox(height: 50, width: 150, child: Center(child: Text("Pass")))),
          OutlinedButton(onPressed: () {
            Routemaster.of(context).push("/accuracy/?id=$id"); 
          }, 
          child: const SizedBox(height: 50, width: 150, child: Center(child: Text("Accuracy")))),
        ],
      ),
    );
  }
}

class JumpPage extends StatefulWidget{
  final String id;
  const JumpPage({super.key, required this.id});

  @override
  State<JumpPage> createState() => JumpPageState();
}

class JumpPageState extends State<JumpPage>{
  TextEditingController controller = TextEditingController();
  String tries = "";
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
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
          ),
          OutlinedButton(onPressed:() async {
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
  String tries = "";
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
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: controllerTwo,
                  keyboardType: TextInputType.number,
                ),
              ],)

              ),
            ],
          ),
          ),
          OutlinedButton(onPressed:() async {
            try{
            if(tries != "3/3"){
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
                });
              } else {
                  setState(() {
                    Routemaster.of(context).push("/score_board");
                  });
              }
            } catch(e){
              debugPrint("[Error on Done]: $e");
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
  String tries = "";
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
                  keyboardType: TextInputType.number,
                ),
                ),
              ],
            ),
          ),
          OutlinedButton(onPressed:() async {
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
              });
            } else {
                setState(() {
                  Routemaster.of(context).push("/score_board");
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
  String tries = "";
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
                  keyboardType: TextInputType.number,
                ),
                ),
              ],
            ),
          ),
          OutlinedButton(onPressed:() async {
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
              });
            } else {
                setState(() {
                  Routemaster.of(context).push("/score_board");
                });
            }
          },
          child: const Text("Done")),
        ],
      ),
    );
  }
}