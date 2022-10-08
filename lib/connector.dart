import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

String server = "http://185.146.3.41";

class Connector{
  const Connector();

  Future<dynamic> addPlayer(String id) async {
    try{
      var response = await post(Uri.parse("$server:8000/add_player/?id=$id"));
      debugPrint(response.body);
      return response.statusCode;
    } catch(e){
      debugPrint("[Error on addPlayer]: $e");
    }
  }

  Future<dynamic> resetGame() async {
    try{
      var response = await get(Uri.parse("http://185.146.3.41:8000/start_new_match"));
      return response.body;
    } catch (e){
      debugPrint("$e");
    }
  }
}