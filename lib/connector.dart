import 'package:http/http.dart';
import 'dart:convert';

class Connector{
  const Connector();
  final String server = "http://185.125.88.30";

  Future<dynamic> getScoreBoardData() async {
    var response = await get(Uri.parse("$server/"));
    return json.decode(response.body);
  }
}