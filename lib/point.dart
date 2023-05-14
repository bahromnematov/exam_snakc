import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

final Widget gameStartChild = Container(
  width: 320,
  height: 320,
  padding: EdgeInsets.all(32),
  child: Center(
    child: Lottie.asset('assets/lottie/start.json'),
  ),
);

final Widget gameRunningChild = Container(
  width: 15.5,
  height: 15.5,
  decoration: BoxDecoration(
    color: Color(0xFFFF0000),
    shape: BoxShape.rectangle,
  ),
);

final Widget newSnakePointInGame = Container(
  width: 15.5,
  height: 15.5,
  decoration: new BoxDecoration(
    color: const Color(0xFF0080FF),
    border: new Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(2),
  ),
);

class Point {
  double x;
  double y;

  Point(this.x, this.y);
}
