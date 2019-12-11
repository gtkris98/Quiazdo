import 'package:flutter/material.dart';
import 'package:quizadoapp/route_generator.dart';

import 'Pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizado',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.grey[600],
        ),
        // This colors the [InputOutlineBorder] when it is selected
        primaryColor: Colors.blue[200],
        primaryColorDark: Colors.blue[500],
        textSelectionHandleColor: Colors.green[500],

      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}


