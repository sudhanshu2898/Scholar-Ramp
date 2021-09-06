import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scholarramp/screens/class.dart';
import 'package:scholarramp/screens/library.dart';
import 'package:scholarramp/screens/login.dart';
import 'package:scholarramp/screens/home.dart';
import 'package:scholarramp/screens/message.dart';
import 'package:scholarramp/screens/profile.dart';
import 'package:scholarramp/screens/profileUpdate.dart';
import 'package:scholarramp/screens/recover.dart';
import 'config.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    title: "$applicationName",
    theme: ThemeData(
      primaryColor: gradientEndColor,
      fontFamily: 'Nordique',
    ),
    debugShowCheckedModeBanner: false,
    initialRoute:'/login',
    routes: {
      '/login': (Context) => Login(),
      '/recover': (Context) => Recover(),
      '/home': (Context) => Home(),
      '/profile': (Context) => Profile(),
      '/profileUpdate' : (Context) => ProfileUpdate(),
      '/library': (Context) => Library(),
      '/message': (Context) => Message(),
      '/class': (Context) => Class(),
    },
  ));
}
