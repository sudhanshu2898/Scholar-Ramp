import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scholarramp/services/auth.dart';

import '../config.dart';

class Recover extends StatefulWidget {
  @override
  _RecoverState createState() => _RecoverState();
}

class _RecoverState extends State<Recover> {

  var _authenticate = new Authenticate();
  var _recoveryFormKey = GlobalKey<FormState>();
  var _recoveryEmail = TextEditingController();
  final GlobalKey<ScaffoldState> _recoveryScaffoldKey = GlobalKey<ScaffoldState>();
  bool isTryingRecovery = false;

  Widget recoverButtonContent(bool value){
    if(value == true){
      return SpinKitRing(
        size: 20,
        lineWidth: 3,
        color: Colors.white,
      );
    }else{
      return Text(
        "Recover Account",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18.0,
        ),
      );
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
        key: _recoveryScaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: gradientStartColor,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: GradientText(
            text:"Recover Account",
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
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 22),
            child: Column(
              children: <Widget>[

                Form(
                  key: _recoveryFormKey,
                  child: Column(
                    children: <Widget>[

                      TextFormField(
                        controller: _recoveryEmail,
                        validator: (String value){
                          if(value.isEmpty || RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) == false){
                            return 'Please Enter a valid email';
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Recovery Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),

                      Divider(
                        height: 20,
                        color: Colors.transparent,
                      ),


                      Container(
                        height: 55.0,
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
                        child:MaterialButton(
                          onPressed: ()=>{
                            FocusScope.of(context).requestFocus(FocusNode()),
                            if(_recoveryFormKey.currentState.validate()){
                              setState((){
                                isTryingRecovery = true;
                              }),
                              _authenticate.recoverAccount(_recoveryEmail.value.text).then((value){
                                setState(() {
                                  isTryingRecovery = false;
                                });
                                if(value['status'] == 'success'){
                                  showDialog(
                                    context: context,
                                    builder: (_) => WillPopScope(
                                      child: AlertDialog(
                                        title:Text("Recovery email has been send"),
                                        content: Text("A password recovery email has been send to you. Kindly verify your email"),
                                        actions: [
                                          TextButton(
                                              onPressed:(){
                                                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                                              },
                                              child: Text("Ok")
                                          ),
                                        ],
                                        elevation: 24,
                                      ),
                                      onWillPop: () => Future.value(false),
                                    ),
                                    barrierDismissible: false,
                                  );
                                }else{
                                  _recoveryScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value['message']),));
                                }
                              }),
                            }
                          },
                          child: recoverButtonContent(isTryingRecovery),
                          color: Colors.transparent,
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
