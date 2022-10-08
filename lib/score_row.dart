import 'package:flutter/material.dart';
import 'connector.dart';

class ScoreRow{
  late String id;
  late String? photo;
  late String lastName;
  late int jump;
  late String dribbling;
  late String accuracy;
  late String pass;
  ScoreRow({required this.id, required this.photo, required this.lastName, required this.jump, required this.dribbling, required this.accuracy, required this.pass});

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
        image: NetworkImage("$server/VFC-backend/${photo!}"),
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

  Widget getPermissionButton(bool check){
    return Container(
        height: 40,
        width: 60,
        decoration: BoxDecoration(
          border: (check) ? const Border(
            bottom: BorderSide(color: Colors.black),
            top: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
          )
        : const Border(
            bottom: BorderSide(color: Colors.grey),
            top: BorderSide(color: Colors.grey),
            right: BorderSide(color: Colors.grey),
            left: BorderSide(color: Colors.grey),
          )
        ),
        child: const Center(child: Text("-")),
      );
  }
}