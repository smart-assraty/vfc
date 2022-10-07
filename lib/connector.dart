import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

String server = "http://185.146.3.41";

class Connector{
  const Connector();

  Future<dynamic> getScoreBoardData() async {
    var response = await get(
      Uri.parse("$server:8000/match_result/"),
      headers: {"Content-type": "application/json"}
      );
    debugPrint(utf8.decode(response.body.codeUnits));
    return json.decode(utf8.decode(response.body.codeUnits));
  }
}