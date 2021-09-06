import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scholarramp/config.dart';
import 'package:scholarramp/services/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var _authenticate = new Authenticate();
  var _loginFormKey = GlobalKey<FormState>();
  var _loginEmail = TextEditingController();
  var _loginPassword = TextEditingController();
  final GlobalKey<ScaffoldState> _loginScaffoldKey = GlobalKey<ScaffoldState>();
  bool isTryingLogin = false;

  Widget loginButtonContent(bool value){
    if(value == true){
      return SpinKitRing(
        size: 20,
        lineWidth: 3,
        color: Colors.white,
      );
    }else{
      return Text(
        "Login",
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
        key: _loginScaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 22),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/scholarramp.png',
                      height: 70,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top:10, bottom: 35),
                    child: GradientText(
                      text:"Welcome to $applicationName",
                      style: TextStyle(
                        color: gradientEndColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: <Color>[
                        gradientStartColor,
                        gradientEndColor
                      ],
                    ),
                  ),

                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: <Widget>[

                        TextFormField(
                          controller: _loginEmail,
                          validator: (String value){
                            if(value.isEmpty || RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) == false){
                              return 'Please Enter a valid email';
                            }else{
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),

                        Divider(
                          height: 20,
                          color: Colors.transparent,
                        ),

                        TextFormField(
                          controller: _loginPassword,
                          validator: (String value){
                            if(value.isEmpty){
                              return 'Please Enter password';
                            }else{
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
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
                              if(_loginFormKey.currentState.validate()){
                                setState((){
                                  isTryingLogin = true;
                                }),
                                _authenticate.signIn(_loginEmail.value.text, _loginPassword.value.text).then((value){
                                  setState(() {
                                    isTryingLogin = false;
                                  });
                                  if(value['status'] == 'success'){
                                    Navigator.of(context).pushReplacementNamed('/home');
                                  }else{
                                    _loginScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value['message']),));
                                  }
                                }),
                              }
                            },
                            child: loginButtonContent(isTryingLogin),
                            color: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child:Row(
                        children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(left:80 ,right:10.0),
                                child: Divider(
                                  color: customLightBlack,
                                  height: 20,
                                )),
                          ),
                          Text(
                            'Or',
                            style: TextStyle(
                              color: customLightBlack,
                            ),
                          ),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(left:10.0, right:80),
                                child: Divider(
                                  color: customLightBlack,
                                  height: 20,
                                )),
                          ),
                        ]
                    ),
                  ),

                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child:OutlineButton(
                      borderSide: BorderSide(color: gradientEndColor),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 14.0,
                          color:gradientEndColor,
                          fontWeight:FontWeight.bold,
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).pushNamed('/recover');
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
