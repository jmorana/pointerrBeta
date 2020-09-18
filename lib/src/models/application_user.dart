

import 'car.dart';

class ApplicationUser {
  final String userId;
  final String email;
  final bool isParker;
  final String fName;
  final String lName;
  final String phoneNumber;
  final List<Car> cars;

  ApplicationUser({this.email, this.userId, this.isParker, this.fName, this.lName, this.phoneNumber, this.cars});

  Map<String,dynamic> toMap(){
    return {
      'userId': userId,
      'email': email,
      'isParker': isParker,
      'fName' : fName,
      'lName' : lName,
      'phoneNumber' : phoneNumber,
      'cars' : cars,
    };
  }

  ApplicationUser.fromFirestore(Map<String,dynamic> firestore)
    : userId = firestore['userId'],
      email = firestore['email'],
      isParker = firestore['isParker'],
      fName = firestore['fName'],
      lName = firestore['lName'],
      phoneNumber = firestore['phoneNumber'],
      cars = firestore['cars'];
}