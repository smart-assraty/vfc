import 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

import 'score_board.dart';
import 'games.dart';

String server = "http://185.146.3.41";

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
    routeInformationParser: const RoutemasterParser(),
    theme: ThemeData(fontFamily: "Arial"),
  ));
}

final routes = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: TV()),
  "/score_board/:game": (route) => MaterialPage(child: OperatorBoard(game: route.pathParameters["game"]!)),
  "/jump": (route) => MaterialPage(child: JumpPage(id: route.queryParameters["id"]!, maxTries: 1,)),
  "/dribbling": (route) => MaterialPage(child: DribblePage(id: route.queryParameters["id"]!, maxTries: 3,)),
  "/pass": (route) => MaterialPage(child: PassPage(id: route.queryParameters["id"]!, maxTries: 3,)),
  "/accuracy": (route) => MaterialPage(child: AccuracyPage(id: route.queryParameters["id"]!, maxTries: 2,)),
});
