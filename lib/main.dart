import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';
import 'connector.dart';
import 'score_row.dart';

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
    theme: ThemeData(fontFamily: "Arial"),
  ));
}

final routes = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: ScoreBoard()),
});

class ScoreBoard extends StatefulWidget{
  final Connector connector = const Connector();
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => ScoreBoardState();
}

String timer = "Match #0085 - 15:47";

class ScoreBoardState extends State<ScoreBoard>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        const Center(child: Image(image: AssetImage("visa.png"))),
        Center(child: Text(
          timer,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),),
        FutureBuilder(
          future: widget.connector.getScoreBoardData(),
          builder: (context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
              return ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index){
                  return ScoreRow.fromJson(snapshot.data);
              });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        )
      ],
    );
    
  }
}