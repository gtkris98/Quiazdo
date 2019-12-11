import 'package:flutter/material.dart';
import 'package:quizadoapp/Pages/bootstrap_page.dart';
import 'package:quizadoapp/Pages/dahboard.dart';
import 'package:quizadoapp/Pages/login.dart';
import 'package:quizadoapp/Services/Auth.dart';
import 'package:quizadoapp/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;
    final _auth = new Auth();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BootstrapPage());
        break;
      case '/login':
        return MaterialPageRoute(
          builder: (_) => Login(args),
        );
        break;
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => UserDashboardWidget(args),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
