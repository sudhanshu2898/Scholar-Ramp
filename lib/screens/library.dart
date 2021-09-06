import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scholarramp/config.dart';
import 'package:intl/intl.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {

  List<Widget> books = [];
  bool issuedBooksHeading = false;
  bool returnedBookHeading = false;

  Widget screenContent(){
    if(books.length > 0){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: books,
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
      var _firestoreReference = FirebaseFirestore.instance.collection('users').doc(_firebaseUser.uid);
      var _userProfileData = await _firestoreReference.get();
      setState(() {
        userDetails['uid'] = _firebaseUser.uid;
        userDetails['name'] = _firebaseUser.displayName;
        userDetails['email'] = _firebaseUser.email;
        userDetails['photo'] = _firebaseUser.photoURL;
        userDetails['semester'] = _userProfileData['sem'];
      });
      
      _firestoreReference.collection('library').get().then((bookList) => {
        if(bookList.size > 0){
          bookList.docs.forEach((bookData) {
            setState(() {
              if(bookData['returned'] == false){
                if(issuedBooksHeading == false){
                  issuedBooksHeading = true;
                  books.add(
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: GradientText(
                        text: "Books Issued to ${userDetails['name']}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: <Color>[
                          gradientStartColor,
                          gradientEndColor
                        ],
                      ),
                    )
                  );
                }
                var bookDate = bookData['reissue'].toDate();
                final DateFormat bookDateFormatter = DateFormat('dd-LLL-yyyy');
                books.add(
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: gradientStartColor,
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child:Text(
                            bookData['book'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        Container(
                          child: Text(
                            "ReIssue By: ${bookDateFormatter.format(bookDate)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                );
              }
            });
          }),
          bookList.docs.forEach((bookData) {
            setState(() {
              if(bookData['returned'] == true){
                if(returnedBookHeading == false){
                  returnedBookHeading = true;
                  books.add(
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 40),
                      child: GradientText(
                        text: "Previous Books",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: <Color>[
                          gradientStartColor,
                          gradientEndColor
                        ],
                      ),
                    )
                  );
                }
                var bookDate = bookData['reissue'].toDate();
                final DateFormat bookDateFormatter = DateFormat('dd-LLL-yyyy');
                books.add(
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: gradientStartColor,
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child:Text(
                              bookData['book'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Divider(
                            height: 10,
                            color: Colors.transparent,
                          ),
                          Container(
                            child: Text(
                              "Returned By: ${bookDateFormatter.format(bookDate)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                );
              }
            });
          })
        }else{
          setState((){
            books.add(
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:EdgeInsets.symmetric(vertical: 50) ,
                        child: Icon(
                          OMIcons.book,
                          color: gradientStartColor,
                          size: 80,
                        )
                      ),
                      Text(
                        'You have not issued any book yet',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                        ),
                      )
                    ],
                  ),
                )
            );
          }),
        },
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return screenContent();
  }
}
