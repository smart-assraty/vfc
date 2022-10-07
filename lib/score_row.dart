import 'package:flutter/material.dart';

class ScoreRow{
  late int playerNumber;
  late String photo;
  late String lastName;
  late int jump;
  late String dribbling;
  late String accuracy;
  late String pass;
  ScoreRow({required this.playerNumber, required this.photo, required this.lastName, required this.jump, required this.dribbling, required this.accuracy, required this.pass});

  factory ScoreRow.fromJson(dynamic body){
    debugPrint(body.toString());
    return ScoreRow(playerNumber: body["player_number"], photo: body["photo_url"], lastName: body["last_name"], jump: body["jump"], dribbling: body["dribbling"].toString(), accuracy: body["accuracy"].toString(), pass: body["pass"].toString());
  }

  Widget getPlayerNumber(){
    return Text(playerNumber.toString(), style: const TextStyle(fontSize: 40, color: Colors.white),);
  }

  Widget getLastName(){
    return Text(lastName, style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),);
  }

  Widget getPhoto(){
    return
    // Image(
    //   height: 50,
    //   width: 50,
    //   image: NetworkImage(photo)
    // ),
    const Icon(Icons.person, size: 60,); //TEST
  }

  Widget getJump(){
    return Text(jump.toString(), style: const TextStyle(fontSize: 30, color: Colors.white),);
  }

  Widget getDribbling(){
    return Text(dribbling, style: const TextStyle(fontSize: 30, color: Colors.white),);
  }

  Widget getAccuracy(){
    return Text(accuracy, style: const TextStyle(fontSize: 30, color: Colors.white),);
  }

  Widget getPass(){
    return Text(pass, style: const TextStyle(fontSize: 30, color: Colors.white),);
  }
}