import 'package:flutter/foundation.dart';

class ParkingLocation{
  final String parkLocationId;
  final String userId;
  final String fullAddr;
  final String streetNumber;
  final String street;
  final String city;
  final String radius;
  final String carType;
  final String zip;
  final bool takenByCust;
  final String note;
  final String state;
  final String arrivalTime;
  final String parkAssist;
  final String payment;

  ParkingLocation({
    @required this.takenByCust,
    @required this.parkLocationId,
    @required this.fullAddr,
    this.city,
    this.note = "",
    @required this.zip,
    @required this.streetNumber,
    @required this.street,
    this.radius,
    @required this.userId,
    @required this.state,
    @required this.carType,
    @required this.arrivalTime,
    this.parkAssist,
    this.payment,
  });

  Map<String, dynamic> toMap() {
    return {
      'parkLocationId' : parkLocationId,
      'userId' : userId,
      'fullAddr' : fullAddr,
      'streetNumber' : streetNumber,
      'street' : street,
      'city' : city,
      'state': state,
      'takenByCust': takenByCust,
      'zip':zip,
      'note':note,
      'carType':carType,
      'radius':radius,
      'arrivalTime' :arrivalTime,
      'parkAssist' :parkAssist,
      'payment' :payment,
    };
  }

  ParkingLocation.fromFirestore(Map<String, dynamic> firestore)
    : parkLocationId = firestore['parkLocationId'],
        userId = firestore['userId'],
      fullAddr = firestore['fullAddr'],
      streetNumber = firestore['streetNumber'],
      street = firestore['street'],
      city = firestore['city'],
      state = firestore['state'],
      takenByCust = firestore['takenByCust'],
      zip = firestore['zip'],
      note = firestore['note'],
      carType = firestore['carType'],
      radius = firestore['radius'],
      arrivalTime = firestore['arrivalTime'],
      parkAssist = firestore['parkAssist'],
      payment = firestore['payment'];
}