import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scholarramp/config.dart';
import 'package:scholarramp/screens/notesViewer.dart';

class NotesTab extends StatefulWidget {
  @override
  _NotesTabState createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {

  List<Widget> notes = [];

  Widget screenContent(){
    if(notes.length > 0){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: notes,
        ),
      );
    }else{
      return Center(
        child: Container(
          padding: EdgeInsets.only(top:50),
          child:SpinKitRing(
            size: 20,
            lineWidth: 3,
            color: gradientEndColor,
          ),
        ),
      );
    }
  }

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


      FirebaseStorage.instance.ref().child('notes/${_userProfileData['sem']}/').listAll().then((folderList){
        folderList.prefixes.forEach((Reference folder){
          FirebaseStorage.instance.ref("${folder.fullPath}/").listAll().then((filesList){
            setState(() {
              notes.add(
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20,),
                    child: GradientText(
                      text: folder.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: <Color>[
                        gradientStartColor,
                        gradientEndColor
                      ],
                    ),
                  )
              );
            });

            if(filesList.items.length > 0){
              filesList.items.forEach((noteFile)  {
                setState(() {
                notes.add(
                  ListTile(
                    title: Text(
                      noteFile.name,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    leading: Icon(OMIcons.pictureAsPdf),
                    trailing: Icon(OMIcons.openInNew),
                    onTap: (){
                      noteFile.getDownloadURL().then((noteDownloadURL){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotesViewer(title: noteFile.name, url: noteDownloadURL,)));
                      });
                    },
                  ),
                );
                });
              });
            }else{
              setState(() {
                notes.add(
                  ListTile(
                    title: Text(
                      "No Notes in ${folder.name}",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              });
            }
          });
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return screenContent();
  }
}
