import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authenticate{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<Map> signIn(String email, String password) async{
    var returnValue = Map();
    try{
      UserCredential  _userCredential  = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      returnValue.putIfAbsent('status', () => 'success');
    }catch(signInException){
      returnValue.putIfAbsent('status', () => 'failed');
      switch(signInException.code){
        case 'user-not-found':{
          returnValue.putIfAbsent('message', () => 'Please Enter correct email address.');
        }
        break;
        case 'wrong-password':{
          returnValue.putIfAbsent('message', () => 'Please Enter correct password.');
        }
        break;
        default:{
          returnValue.putIfAbsent('message', () => 'Opps!! Something went Wrong.');
        }
        break;
      }
    }
    return Future.value(returnValue);
  }

  Future<bool> signOut() async{
    try{
      await _firebaseAuth.signOut();
      return Future.value(true);
    }catch(signOutException){
      return Future.value(false);
    }
  }

  Future<bool> uploadProfilePhoto(file, String fileURL, String userId) async{
    try{
      var imageExtention = fileURL.split('.').last;
      await _firebaseStorage.ref('profile/$userId.$imageExtention').putFile(file);
      await _firebaseStorage.ref('profile/$userId.$imageExtention').getDownloadURL().then((value){
        FirebaseAuth.instance.currentUser.updateProfile(photoURL: value);
      });
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    }
  }

  Future<bool> updateProfileName(String name) async{
    try{
      await FirebaseAuth.instance.currentUser.updateProfile(displayName: name);
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    }
  }

  Future<Map> recoverAccount(String email) async{
    var returnValue = Map();
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      returnValue.putIfAbsent("status", () => "success");
    }catch(e){
      returnValue.putIfAbsent("status", () => "failed");
      switch(e.code){
        case 'user-not-found':{
          returnValue.putIfAbsent('message', () => 'Please Enter correct email address.');
        }
        break;
        default:{
          returnValue.putIfAbsent('message', () => 'Opps!! Something went Wrong.');
        }
        break;
      }
    }
    return Future.value(returnValue);
  }

}