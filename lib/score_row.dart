import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScoreRow extends StatelessWidget{
  late int playerNumber;
  late String photo;
  late String lastName;
  late int jump;
  late String dribbling;
  late String accuracy;
  late String pass;
  ScoreRow({super.key, required this.playerNumber, required this.photo, required this.lastName, required this.jump, required this.dribbling, required this.accuracy, required this.pass});

  factory ScoreRow.fromJson(dynamic body){
    return ScoreRow(playerNumber: body["player_number"], photo: body["photo"], lastName: body["lastName"], jump: body["jump"], dribbling: body["dribbling"], accuracy: body["accuracy"], pass: body["pass"]);
  }

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          SizedBox(
          height: 50,
          width: 50,  
          child: Text(playerNumber.toString()),
          ),
          Image(
            height: 50,
            width: 50,
            image: NetworkImage(photo)
          ),
          Text(
            lastName,
            style: const TextStyle(fontSize: 24),
          ),
          SizedBox(
          height: 50,
          width: 50,  
          child: Text(jump.toString()),
          ),
          SizedBox(
          height: 50,
          width: 100,  
          child: Text(dribbling),
          ),
          SizedBox(
          height: 50,
          width: 80,  
          child: Text(accuracy),
          ),
          SizedBox(
          height: 50,
          width: 80,  
          child: Text(pass),
          ),
        ],
      ),
    );
  }
}