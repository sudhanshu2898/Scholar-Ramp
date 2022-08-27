import 'dart:io';

import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scholarramp/config.dart';
import 'package:scholarramp/services/auth.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {

  var _authenticate = new Authenticate();
  var _profileUpdateFormKey = GlobalKey<FormState>();
  var _profileUpdateName = TextEditingController();
  bool isTryingProfileUpdate = false;
  bool hasProfilePhotoChanged = false;
  File profileAvtarImage;
  var profileAvtarImageURL = null;

  final GlobalKey<ScaffoldState> _profileUpdateScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User _firebaseUser = await _firebaseAuth.currentUser;
    if(_firebaseUser != null){
      setState(() {
        userDetails['uid'] = _firebaseUser.uid;
        userDetails['name'] = _firebaseUser.displayName;
        userDetails['email'] = _firebaseUser.email;
        userDetails['photo'] = _firebaseUser.photoURL;

        _profileUpdateName.text = userDetails['name'] == null ? "$applicationName User" : userDetails['name'];
      });
    }
  }

  Widget updateProfileButtonContent(bool value){
    if(value == true){
      return SpinKitRing(
        size: 20,
        lineWidth: 3,
        color: Colors.white,
      );
    }else{
      return Text(
        "Update Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18.0,
        ),
      );
    }
  }

  Future<bool> pickProfilePicture() async{
    var profileUserAvtarPicker = ImagePicker();
    final profileUserAvtarPicked = await profileUserAvtarPicker.getImage(source: ImageSource.gallery);
    try{
      setState((){
        hasProfilePhotoChanged = true;
        profileAvtarImage = File(profileUserAvtarPicked.path);
        profileAvtarImageURL = profileUserAvtarPicked.path;
      });
    }catch(e){}
  }

  Widget loadProfilePhoto(){
    if(hasProfilePhotoChanged == true){
      try{
        return Image.file (
            profileAvtarImage,
            height: 100,
            width: 100,
            fit:BoxFit.cover
        );
      }catch(e){
        print(e);
        _profileUpdateScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Opps!! Something went wong'),));
        return Image.asset(
            'assets/avtar.png',
            height: 100,
            width: 100,
            fit:BoxFit.cover
        );
      }
    }else{
      if(userDetails['photo'] == null){
        return Image.asset(
            'assets/avtar.png',
            height: 100,
            width: 100,
            fit:BoxFit.cover
        );
      }else{
        try{
          return Image.network(
              userDetails['photo'],
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _profileUpdateScaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: gradientStartColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: GradientText(
          text:"Update Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          colors: <Color>[
            gradientStartColor,
            gradientEndColor
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: 102,
                width: 102,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: gradientEndColor,
                    width: 2,
                  )
                ),
                child: Stack(
                  children: <Widget>[
                    ClipOval(
                      child: loadProfilePhoto(),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: FloatingActionButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: gradientEndColor,
                              width: 2,
                            )
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          child: Icon(OMIcons.cameraAlt, color: gradientEndColor, size:18),
                          onPressed: pickProfilePicture,
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top:20),
              child: Form(
                key: _profileUpdateFormKey,
                child: TextFormField(
                  controller: _profileUpdateName,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please Enter Name';
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Display Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    colors: [gradientStartColor, gradientEndColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradientStartColor,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: MaterialButton(
                  onPressed: ()=>{
                    FocusScope.of(context).requestFocus(FocusNode()),
                    if(_profileUpdateFormKey.currentState.validate()){
                      setState((){
                        isTryingProfileUpdate = true;
                      }),
                      if(hasProfilePhotoChanged){
                        _authenticate.uploadProfilePhoto(profileAvtarImage, profileAvtarImageURL, userDetails['uid']).then((value){
                          if(value == true){
                            _authenticate.updateProfileName(_profileUpdateName.value.text).then((value){
                              setState(() {
                                isTryingProfileUpdate = false;
                              });
                              if(value == true){
                                Navigator.of(context).pop();
                              }else{
                                _profileUpdateScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Failed to Update Profile'),));
                              }
                            });
                          }else{
                            setState(() {
                              isTryingProfileUpdate = false;
                            });
                            _profileUpdateScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Failed to Update Profile'),));
                          }
                        }),
                      }else{
                        _authenticate.updateProfileName(_profileUpdateName.value.text).then((value){
                          setState(() {
                            isTryingProfileUpdate = false;
                          });
                          if(value == true){
                            Navigator.of(context).pop();
                          }else{
                            _profileUpdateScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Failed to Update Profile'),));
                          }
                        }),
                      }
                    }
                  },
                  child: updateProfileButtonContent(isTryingProfileUpdate),
                  color: Colors.transparent,
                  elevation: 0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
