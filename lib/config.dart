import 'dart:math';

import 'package:flutter/material.dart';

//all strings value here
const String applicationName = "Scholar Ramp";

//All Global Keys to be declared here
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

//all colors here
const gradientStartColor = Color(0xff66E093);
const gradientEndColor = Color(0xff08B1A9);
const customColorLight = Color(0xffe8f5fd);
const customLightBlack = Colors.black87;

Map userDetails = {
  'uid':null,
  'name':'user',
  'email':'email',
  'photo':null,
  'semester':null,
};



Color getRandomColor(){
  var randomColors = [
    Colors.deepOrange,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.deepPurpleAccent,
    Colors.pink,
    Colors.amber,
    Color(0xff1778F2),
    Color(0xff4285F4),
  ];
  Random random = new Random();
  int returnIndex = random.nextInt(randomColors.length);
  return randomColors[returnIndex];
}
