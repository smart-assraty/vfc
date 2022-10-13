import 'package:flutter/material.dart';

import 'connector.dart';
import 'main.dart';

class ScoreRow{
  String id;
  String? photo;
  String lastName;
  int jump;
  String jumpProgress;
  String dribbling;
  String dribblingProgress;
  String accuracy;
  String accuracyProgress;
  String pass;
  String passProgress;
  ScoreRow({
    required this.id, 
    required this.photo, 
    required this.lastName, 
    required this.jump,
    required this.jumpProgress, 
    required this.dribbling,
    required this.dribblingProgress,
    required this.accuracy,
    required this.accuracyProgress,
    required this.pass,
    required this.passProgress,
  });

  final connector = const Connector();

  factory ScoreRow.fromJson(Map<String, Map<String, dynamic>> body){
    return ScoreRow(
      id: body.keys.first, 
      photo: body.values.first["photo_url"], 
      lastName: body.values.first["last_name"], 
      jump: body.values.first["jump"],
      jumpProgress: body.values.first["jump_progress"],
      dribbling: body.values.first["dribbling"].toString(),
      dribblingProgress: body.values.first["dribbling_progress"],
      accuracy: body.values.first["accuracy"].toString(),
      accuracyProgress: body.values.first["accuracy_progress"],
      pass: body.values.first["pass"].toString(),
      passProgress: body.values.first["pass_progress"],
    );
  }

  Widget getPlayerNumber(Color? color){
    return Text(id.toString(), style: TextStyle(fontSize: 30, color: color),);
  }

  Widget getLastName(Color? color){
    return Text(lastName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color),);
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
    return Text("$jump см", style: TextStyle(fontSize: 24, color: color),);
  }

  Widget getJumpProgress(Color? color){
    return Text(jumpProgress, style: TextStyle(fontSize: 24, color: color),);
  }

  Widget getDribbling(Color? color){
    return Text("$dribbling секунд", style: TextStyle(fontSize: 24, color: color),);
  }

  Widget getDribblingProgress(Color? color){
    return Text(dribblingProgress, style: TextStyle(fontSize: 24, color: color),);
  }

  Widget getAccuracy(Color? color){
    return Text("$accuracy попадании", style: TextStyle(fontSize: 24, color: color),);
  }

  Widget getAccuracyProgress(Color? color){
    return Text(accuracyProgress, style: TextStyle(fontSize: 24, color: color),);
  }

  Widget getPass(Color? color){
    return Text("$pass попадании", style: TextStyle(fontSize: 24, color: color),);
  }

  Widget getPassProgress(Color? color){
    return Text(passProgress, style: TextStyle(fontSize: 24, color: color),);
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