import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scholarramp/config.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> screenWidgetList = [];
  List<Widget> notification = [];
  List<Widget> attendance = [];
  List<Widget> attendancePercentageList = [];
  bool notificationLoaded = false;
  bool attendanceLoaded = false;

  Widget screenContent(){
    if(attendance.length > 0 && notification.length > 0){
      screenWidgetList.addAll(notification);
      screenWidgetList.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.of(context).size.width,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                gradientStartColor,
                gradientEndColor
              ],
            ),
          ),
        )
      );
      screenWidgetList.addAll(attendance);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: screenWidgetList,
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

      _firestoreReference.collection('attendance').get().then((attendanceList) => {
        attendance.clear(),
        attendance.add(
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: GradientText(
              text:"Attendance",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
              colors: <Color>[
                gradientStartColor,
                gradientEndColor
              ],
            ),
          ),
        ),
        if(attendanceList.size > 0){
          attendanceList.docs.forEach((attendanceData) {
            var attendancePercentage = ((attendanceData['present']*100)/attendanceData['total']).round();
            attendancePercentageList.add(
              Container(
                child: CircularPercentIndicator(
                  radius: 80,
                  center: Text(
                    "$attendancePercentage%",
                    style: TextStyle(
                      color: gradientEndColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  percent: attendancePercentage/100,
                  lineWidth: 5,
                  circularStrokeCap: CircularStrokeCap.round,
                  animationDuration: 1250,
                  animation: true,
                  linearGradient: LinearGradient(
                    colors: <Color>[
                      gradientStartColor,
                      gradientEndColor
                    ]
                  ),
                  footer: Center(
                    child: GradientText(
                      text: attendanceData['subject'],
                      textAlign: TextAlign.center,
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
                ),
              ),
            );
          }),
          attendance.add(
            Container(
               child:GridView.count(
                 shrinkWrap: true,
                 crossAxisCount: 2,
                 children: attendancePercentageList,
                 physics: NeverScrollableScrollPhysics(),
               ),
            )
          ),
        }else{
          attendance.add(
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Unable to fetch your attendance',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        },
        setState((){}),
      });

      var _firestoreNotificationReference = FirebaseFirestore.instance.collection('notification').get().then((notificationList) => {
        if(notificationList.size > 0){
          notification.clear(),
          notification.add(
            Container(
              padding: EdgeInsets.only(top: 20,bottom: 10),
              child: GradientText(
                  text:"Notifications",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
                colors: <Color>[
                  gradientStartColor,
                  gradientEndColor
                ],
              ),
            ),
          ),

          notificationList.docs.forEach((notificationData) {
            if(notificationData['sem'] == 0 || notificationData['sem'] == userDetails['semester']){
              notification.add(
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
                  child: Text(notificationData['message']),
                ),
              );
            }
          })
        },
        setState((){})
      });

    }
  }




  @override
  Widget build(BuildContext context) {
    return screenContent();
  }
}
