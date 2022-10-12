import 'package:flutter/material.dart';
import 'connector.dart';

import 'main.dart';

class ScoreRow{
  String id;
  String? photo;
  String lastName;
  int jump;
  String dribbling;
  String accuracy;
  String pass;
  ScoreRow({required this.id, required this.photo, required this.lastName, required this.jump, required this.dribbling, required this.accuracy, required this.pass});

  final connector = const Connector();

  factory ScoreRow.fromJson(Map<String, Map<String, dynamic>> body){
    return ScoreRow(id: body.keys.first, photo: body.values.first["photo_url"], lastName: body.values.first["last_name"], jump: body.values.first["jump"], dribbling: body.values.first["dribbling"].toString(), accuracy: body.values.first["accuracy"].toString(), pass: body.values.first["pass"].toString());
  }

  Widget getPlayerNumber(Color? color){
    return Text(id.toString(), style: TextStyle(fontSize: 40, color: color),);
  }

  Widget getLastName(Color? color){
    return Text(lastName, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: color),);
  }

  Widget getPhoto(){
    return Center(
      child: Image(
        height: double.maxFinite,   
        width: 100, 
        image: NetworkImage("$server/vfc-backend/${photo!}"),
      ),
    );
  }

  Widget getJump(Color? color){
    return Text(jump.toString(), style: TextStyle(fontSize: 30, color: color),);
  }

  Widget getDribbling(Color? color){
    return Text(dribbling, style: TextStyle(fontSize: 30, color: color),);
  }

  Widget getAccuracy(Color? color){
    return Text(accuracy, style: TextStyle(fontSize: 30, color: color),);
  }

  Widget getPass(Color? color){
    return Text(pass, style: TextStyle(fontSize: 30, color: color),);
  }

  Widget getDeleteButton(){
    return OutlinedButton(
        onPressed: () {
          connector.deletePlayer(id);
        },
        child: const Center(child: Text("X", style: TextStyle(fontSize: 40, color: Colors.red),)),
      );
  }
}