import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholarramp/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:scholarramp/screens/homeScreen.dart';
import 'package:scholarramp/screens/library.dart';
import 'package:scholarramp/screens/message.dart';
import 'package:scholarramp/screens/notes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async{
    User _firebaseUser = await FirebaseAuth.instance.currentUser;
    if(_firebaseUser != null){
      DocumentSnapshot _userProfileData = await FirebaseFirestore.instance.collection('users').doc(_firebaseUser.uid).get();
      setState(() {
        userDetails['uid'] = _firebaseUser.uid;
        userDetails['name'] = _firebaseUser.displayName;
        userDetails['email'] = _firebaseUser.email;
        userDetails['photo'] = _firebaseUser.photoURL;
        userDetails['semester'] = _userProfileData['sem'];
      });
    }
  }

  Widget loadProfilePhoto(String url){
    if(url == null){
      return ClipOval(
        child: Image.asset(
          'assets/avtar.png',
          width: 35,
          height: 35,
          fit: BoxFit.cover,
        ),
      );
    }else{
      try{
        return ClipOval(
          child: Image.network(
            url,
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          ),
        );
      }catch(loadProfilePhotoException) {
        return ClipOval(
          child: Image.asset(
            'assets/avtar.png',
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          ),
        );
      }
    }
  }

  int showTabIndex = 0;
  final homeScreenTabs = [
    [HomeScreen(), applicationName],
    [Library(), "Library"],
    [Notes(), "Notes"],
    [Message(), "Chat Bot"],
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Scaffold(
        key: homeScaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: GradientText(
            text:homeScreenTabs[showTabIndex][1],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            colors: <Color>[
              gradientStartColor,
              gradientEndColor
            ],
          ),
          actions: [
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/profile');
                },
                child: loadProfilePhoto(userDetails['photo']),
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: homeScreenTabs[showTabIndex][0],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Color(0xfff6f6f6),
          height: 55,
          index:showTabIndex,
          animationDuration: Duration(
            milliseconds: 350,
          ),
          items: <Widget>[
            Icon(OMIcons.home, size: 24, color: gradientStartColor ,),
            Icon(OMIcons.libraryBooks, size: 24, color: gradientStartColor ,),
            Icon(OMIcons.notes, size: 24, color: gradientStartColor ,),
            Icon(OMIcons.chat, size: 23, color: gradientStartColor ,),
          ],
          onTap: (index) {
            setState(() {
              showTabIndex = index;
            });

          },
        ),
      )
    );
  }
}
