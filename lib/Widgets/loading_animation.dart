import 'dart:math';
import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 5000),
        upperBound: pi * 2);
    rotationController.forward();
    rotationController.addListener(() {
      setState(() {
        if (rotationController.status == AnimationStatus.completed) {
          rotationController.repeat();
        }
      });
    });
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
          child: new Container(
            height: 40.0,
            width: 40.0,
            child: Image.asset('assets/logo-main.png'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildWaitingScreen();
  }
}
