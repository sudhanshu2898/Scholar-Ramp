import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scholarramp/screens/class.dart';
import 'package:scholarramp/tabs/library.dart';
import 'package:scholarramp/screens/login.dart';
import 'package:scholarramp/screens/home.dart';
import 'package:scholarramp/tabs/message.dart';
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
      '/login': (context) => Login(),
      '/recover': (context) => Recover(),
      '/home': (context) => Home(),
      '/profile': (context) => Profile(),
      '/profileUpdate' : (context) => ProfileUpdate(),
      '/library': (context) => LibraryTab(),
      '/message': (context) => MessageTab(),
      '/class': (context) => Class(),
    },
  ));
}
