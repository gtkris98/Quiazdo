import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quizadoapp/Pages/dahboard.dart';
import 'package:quizadoapp/widgets/loading_animation.dart';
import 'package:quizadoapp/Pages/login.dart';

import '../Services/Auth.dart';


enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class BootstrapPage extends StatefulWidget {
  final BaseAuth auth = new Auth();
  @override
  State<StatefulWidget> createState() => new _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> with TickerProviderStateMixin {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      widget.auth.getCurrentUser().then((user) {
        setState(() {
          if (user != null) {
            _userId = user?.uid;
            _isEmailVerified = user?.isEmailVerified;
          }
          authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        });
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
//    return buildWaitingScreen();
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return LoadingAnimation();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return Login(widget.auth);
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null && _isEmailVerified) {
          return new UserDashboardWidget(widget.auth);
        } else
          return LoadingAnimation();
        break;
      default:
        return LoadingAnimation();
    }
  }
}