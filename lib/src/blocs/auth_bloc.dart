
import 'dart:async';

import 'package:pointerr/src/models/car.dart';
import 'package:pointerr/src/models/application_user.dart';
import 'package:pointerr/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthBloc {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _password2 = BehaviorSubject<String>();
  final _fName = BehaviorSubject<String>();
  final _lName = BehaviorSubject<String>();
  final _phoneNumber = BehaviorSubject<String>();
  final _cars = BehaviorSubject<List<Car>>();
  final _isParker = BehaviorSubject<bool>();
  final _user = BehaviorSubject<ApplicationUser>();
  final _errorMessage = BehaviorSubject<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  //Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get password2 => _password2.stream.transform(validatePassword2);
  Stream<bool> get isParker => _isParker.stream;
  Stream<String> get fName => _fName.stream;
  Stream<String> get lName => _lName.stream;
  Stream<String> get phoneNumber => _phoneNumber.stream.transform(validatePhone);
  Stream<bool> get isValidSignup => CombineLatestStream.combine5(email, password, fName, lName, phoneNumber,  (email,password,fName,lName,phone)=> true);
  Stream<bool> get isValidLogin => CombineLatestStream.combine2(email, password,  (email,password,)=> true);

  Stream<ApplicationUser> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  String get userId => _user.value.userId;
  Stream<List<Car>> get cars => _cars.stream;
  String get firstName => _user.value.fName;
  String get lastName => _user.value.lName;
  String get getEmail => _user.value.email;
  String get getPhone => _user.value.phoneNumber;
  String get getPass1 => _password.value.toString();



  //Set Data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changePassword2 => _password2.sink.add;
  Function(String) get changefName => _fName.sink.add;
  Function(String) get changelName => _lName.sink.add;
  Function(String) get changePhoneNumber => _phoneNumber.sink.add;
  Function(bool) get changeIsParker => _isParker.sink.add;
 // Function(Car) get changeCar => _cars.sink.add;

  dispose(){
    _email.close();
    _password.close();
    _password2.close();
    _user.close();
    _errorMessage.close();
    _isParker.close();
    _fName.close();
    _lName.close();
    _cars.close();
    _phoneNumber.close();
  }

  //Transformers
  final validateEmail = StreamTransformer<String,String>.fromHandlers(handleData: (email, sink){
    if (regExpEmail.hasMatch(email.trim())){
      sink.add(email.trim());
    }else {
      sink.addError('Must Be Valid Email Address');
    }
  });

    final validatePassword = StreamTransformer<String,String>.fromHandlers(handleData: (password, sink){
    if (password.length >= 8){
      sink.add(password.trim());
    }else {
      sink.addError('8 Character Minimum');
    }
  });

  final validatePassword2 = StreamTransformer<String,String>.fromHandlers(handleData: (password2, sink){
    if (password2.length >= 8){
      sink.add(password2.trim());
    }else {
      sink.addError('8 Character Minimum');
    }
  });

  final validatePhone = StreamTransformer<String,String>.fromHandlers(handleData: (phone, sink){
    if (phone.length == 10){
      sink.add(phone.trim());
    }else {
      sink.addError('Must be a valid phone number');
    }
  });

  final validateLicensePlate = StreamTransformer<String,String>.fromHandlers(handleData: (licensePlate, sink){
    if (licensePlate.length != 7){
      sink.add(licensePlate.trim());
    }else {
      sink.addError('Must Be Valid License Plate');
    }
  });



  //Functions
  signupEmail() async{
    try{
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: _email.value.trim(), password: _password.value.trim());
      var user = ApplicationUser(userId: authResult.user.uid, email: _email.value.trim(), isParker: false, fName: _fName.value.trim(), lName: _lName.value.trim(), phoneNumber: _phoneNumber.value.trim());
      await _firestoreService.addUser(user);
      _user.sink.add(user);
    } on PlatformException catch (error){
      print(error);
      _errorMessage.sink.add(error.message);
    }
  }

    loginEmail() async{
    try{
      UserCredential authResult =await _auth.signInWithEmailAndPassword(email: _email.value.trim(), password: _password.value.trim());
      var user = await _firestoreService.fetchUser(authResult.user.uid);
      _user.sink.add(user);
    } on PlatformException catch (error){
      print(error);
      _errorMessage.sink.add(error.message);
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      var firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return false;

      var user = await _firestoreService.fetchUser(firebaseUser.uid);
      if (user == null) return false;

    _user.sink.add(user);
    return true;
    } catch (error){
      print(error);
      return false;
    }
  }

  logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  clearErrorMessage(){
    _errorMessage.sink.add('');
  }

}