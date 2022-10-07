import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

String server = "http://185.146.3.41";

class Connector{
  const Connector();

  Future<dynamic> getScoreBoardData() async {
    try{
      var response = await get(
        Uri.parse("$server:8000/match_result/"),
        headers: {"Content-type": "application/json"}
        );
      debugPrint(utf8.decode(response.body.codeUnits));
      return json.decode(utf8.decode(response.body.codeUnits));
    } catch(e){
      debugPrint("[Error on getScoreBoadr]: $e");
    }
  }

  Future<dynamic> addPlayer(String id) async {
    try{
      var response = await post(Uri.parse("$server:8000/add_player/?id=$id"));
      debugPrint(response.body);
      return response.statusCode;
    } catch(e){
      debugPrint("[Error on addPlayer]: $e");
    }
  }
}