import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

String server = "http://185.146.3.41";

class Connector{
  const Connector();

  Future<dynamic> getScoreBoardData() async {
    var response = await get(Uri.parse("$server/"));
    debugPrint(response.body);
    return json.decode(response.body);
  }
}