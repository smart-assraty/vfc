import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'main.dart';

class Connector{
  const Connector();

    Future<dynamic> getScoreBoardData() async {
    try{
      var response = await get(
        Uri.parse("$server:8000/match_result/"),
        headers: {"Content-type": "application/json"}
        );
      //debugPrint(utf8.decode(response.body.codeUnits));
      return json.decode(utf8.decode(response.body.codeUnits));
    } catch(e){
      debugPrint("[Error on getScoreBoard]: $e");
    }
  }

  Future<dynamic> addPlayer(String id) async {
    try{
      var response = await post(Uri.parse("$server:8000/add_player/?id=$id"));
      debugPrint("[Add Player Response]:${response.body}");
      return response.statusCode;
    } catch(e){
      debugPrint("[Error on addPlayer]: $e");
    }
  }

  Future<void> deletePlayer(String id) async{
    try{
      var response = await post(Uri.parse("$server:8000/delete_player/?id=$id"));
      debugPrint("[Delete Player Response]:${response.body}");
    } catch(e){
      debugPrint("[Error on deletePlayer]: $e");
    }
  }

  Future<dynamic> resetGame() async {
    try{
      var response = await get(Uri.parse("$server:8000/start_new_match/"));
      return response.body;
    } catch (e){
      debugPrint("$e");
    }
  }
}