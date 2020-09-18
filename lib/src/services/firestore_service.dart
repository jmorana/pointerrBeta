import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pointerr/src/models/car.dart';


import 'package:pointerr/src/models/parkingLocation.dart';
import 'package:pointerr/src/models/application_user.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> addUser(ApplicationUser user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<ApplicationUser> fetchUser(String userId) async{
    try {
      return _db
          .collection('users')
          .doc(userId)
          .get()
          .then((snapshot) => ApplicationUser.fromFirestore(snapshot.data()));
    } catch (e){print(e);}
  }
  Future<ParkingLocation> fetchLocation(String userId){
    return _db.collection('parkingLocation').doc(userId)
        .get().then((snapshot) => ParkingLocation.fromFirestore(snapshot.data()));
  }
//TODO


  Future<void> setParkingLocation(ParkingLocation location) {
    var options = SetOptions(merge: true);
    return _db
        .collection('parkingLocation')
        .doc(location.parkLocationId)
        .set(location.toMap(), options);
  }

  Stream<List<ParkingLocation>> fetchAllParkingLocations(){
    return _db.collection('parkingLocation')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((document) => ParkingLocation.fromFirestore(document.data()))
        .toList());
  }

  Stream<List<ParkingLocation>> fetchParkingLocations(String userId) {
    return _db
        .collection('parkingLocation')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
            snapshot.map((document) => ParkingLocation.fromFirestore(document.data()))
        .toList());
  }

  Future<void> setCar(Car car) {
    return _db
        .collection('cars')
        .doc(car.carId)
        .set(car.toMap());
  }

  Stream<List<Car>> fetchCars(String userId) {
    return _db
        .collection('cars')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
        snapshot.map((document) => Car.fromFirestore(document.data()))
            .toList());
  }

 Stream<List<String>> fetchCarList(String userId) {
    return _db
        .collection('cars')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
        snapshot.map((document) => Car.fromFirestore(document.data()).year)
            .toList());
  }

}
