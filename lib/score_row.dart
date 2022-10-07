import 'package:flutter/material.dart';

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

  Widget getPlayerNumber(){
    return Text(id.toString(), style: const TextStyle(fontSize: 40),);
  }

  Widget getLastName(){
    return Text(lastName, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),);
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
    return Text(jump.toString(), style: const TextStyle(fontSize: 30,),);
  }

  Widget getDribbling(){
    return Text(dribbling, style: const TextStyle(fontSize: 30,),);
  }

  Widget getAccuracy(){
    return Text(accuracy, style: const TextStyle(fontSize: 30,),);
  }

  Widget getPass(){
    return Text(pass, style: const TextStyle(fontSize: 30,),);
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