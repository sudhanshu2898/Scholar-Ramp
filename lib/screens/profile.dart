import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scholarramp/config.dart';
import 'package:scholarramp/services/auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var _authenticate = new Authenticate();
  final GlobalKey<ScaffoldState> _profileScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User _firebaseUser = await _firebaseAuth.currentUser;
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
      return Image.asset(
        'assets/avtar.png',
        height: 100,
        width: 100,
        fit:BoxFit.cover
      );
    }else{
      try{
        return Image.network(
          url,
          height: 100,
          width: 100,
          fit:BoxFit.cover
        );
      }catch(loadProfilePhotoException) {
        return Image.asset(
            'assets/avtar.png',
            height: 100,
            width: 100,
            fit:BoxFit.cover
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Scaffold(
        key: _profileScaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: gradientStartColor,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: GradientText(
            text:"Profile",
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
              width: 90,
              padding: EdgeInsets.symmetric(vertical: 13, horizontal:8),
              child: RaisedButton.icon(
                elevation: 0,
                color: Colors.transparent,
                onPressed: (){
                  Navigator.of(context).pushNamed('/profileUpdate');
                },
                icon:Icon(OMIcons.edit, size: 16, color: gradientStartColor,),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 13,
                    color: gradientStartColor
                  ),
                ),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(
                    color: gradientStartColor,
                  )
                ),
              )
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: gradientEndColor,
                      width: 2,
                    )
                ),
                child: ClipOval(
                  child: loadProfilePhoto(userDetails['photo']),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:0, bottom: 20),
              child: Center(
                child: Text(
                  userDetails['name'] == null ? "$applicationName User" : userDetails['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black26,
            ),
            ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Text>[
                    Text(
                      'Email :',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87
                      ),
                    ),
                    Text(
                      userDetails['email'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black26,
            ),
            ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Text>[
                    Text(
                      'Semester :',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87
                      ),
                    ),
                    Text(
                      userDetails['semester'] == null ? 'N/A' : userDetails['semester'] ,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 15,
              color: Colors.black12,
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(OMIcons.exitToApp),
              onTap: (){
                _authenticate.signOut().then((value){
                  if(value == true){
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  }else{
                    _profileScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Opps!! Something went wrong.'),));
                  }
                });
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}
