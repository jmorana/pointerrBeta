import 'dart:async';

import 'package:pointerr/src/app.dart';
import 'package:pointerr/src/models/parkingLocation.dart';
import 'package:pointerr/src/services/firebase_storage_service.dart';
import 'package:pointerr/src/services/firestore_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';


class LocationBloc {
  final _fullAddr = BehaviorSubject<String>();
  final _parkLocationId = BehaviorSubject<String>();
  final _userId = BehaviorSubject<String>();
  final _streetNumber = BehaviorSubject<String>();
  final _street = BehaviorSubject<String>();
  final _city = BehaviorSubject<String>();
  final _state = BehaviorSubject<String>();
  final _zip = BehaviorSubject<String>();
  final _carType = BehaviorSubject<String>();
  final _radius  = BehaviorSubject<String>();
  final _locationSaved = PublishSubject<bool>();
  final _isUploading = BehaviorSubject<bool>();
  final _arrivalTime = BehaviorSubject<String>();
  final _parkAssist = BehaviorSubject<bool>();
  final _payment = BehaviorSubject<String>();

  final db = FirestoreService();
  var uuid = Uuid();
  final storageService = FirebaseStorageService();


  //Get
  Stream<String> get parkLocationId => _parkLocationId.stream;
  Stream<String> get userId => _userId.stream;
  Stream<String> get fullAddr => _fullAddr.stream;
  Stream<String> get streetNumber => _streetNumber.stream;
  Stream<String> get street => _street.stream;

  Stream<String> get city => _city.stream;
  Stream<String> get state => _state.stream;
  Stream<String> get zip => _zip.stream;
  Stream<String> get radius => _radius.stream;
  Stream<List<ParkingLocation>> fetchParkingLocations(String userId) =>
      db.fetchParkingLocations(userId);
  Stream<bool> get locationSaved => _locationSaved.stream;
  Future<ParkingLocation> fetchLocation(String userId) => db.fetchLocation(userId);
  Stream<bool> get isUploading => _isUploading.stream;
  Stream<String> get carType => _carType.stream;
  Stream<String> get arrivalTime => _arrivalTime.stream;
  Stream<bool> get parkAssist => _parkAssist.stream;
  Stream<String> get payment => _payment.stream;




  Stream<bool> get isValid => CombineLatestStream.combine3(
      streetNumber, carType, arrivalTime,  (a, b, c,) => true);

  Stream<bool> get isValidConfirm => CombineLatestStream.combine2(
      radius, payment,  (a, b) => true);
  Stream<List<ParkingLocation>> fetchAvailableParking() => db.fetchAllParkingLocations();




  //Set
  Function(String) get changeFullAddr => _fullAddr.sink.add;

  Function(String) get changeStreetNumber => _streetNumber.sink.add;
  Function(String) get changeStreet => _street.sink.add;

  Function(String) get changeCity => _city.sink.add;
  Function(String) get changeState => _state.sink.add;
  Function(String) get changeZip => _zip.sink.add;
  Function(String) get changeCarType => _carType.sink.add;
  Function(String) get changeRadius => _radius.sink.add;
  Function(String) get changeArrivalTime => _arrivalTime.sink.add;
  Function(bool) get changeParkAssist => _parkAssist.sink.add;
  Function(String) get changePayment => _payment.sink.add;





  dispose() {
    _fullAddr.close();
    _parkLocationId.close();
    _userId.close();
    _streetNumber.close();
    _street.close();
    _city.close();
    _state.close();
    _zip.close();
    _locationSaved.close();
    _isUploading.close();
    _radius.close();
    _carType.close();
    _arrivalTime.close();
    _parkAssist.close();
    _payment.close();
  }

  //Functions
  Future<void> saveParkingLocation() async {
    var parkingLocation = ParkingLocation(
      parkLocationId:  (_parkLocationId.value == null)? uuid.v4(): _parkLocationId.value,
      userId: (_userId.value == null) ? _userId.value = authBloc.userId : _userId.value,
      fullAddr: _fullAddr.value,
      streetNumber: _streetNumber.value,
      street: _street.value,

      city: _city.value,
      state: _state.value,
      zip: _zip.value,
      carType: _carType.value,
      radius: _radius.value,
      takenByCust: false,
      arrivalTime: _arrivalTime.value,
      parkAssist: _parkAssist.value.toString(),
      payment: _payment.value,
    );


    return db
        .setParkingLocation(parkingLocation)
        .then((value) => _locationSaved.sink.add(true))
        .catchError((error) => _locationSaved.sink.add(false));
  }

  Future<void> editParkingLocation(String parkId) async {
    var parkingLocation = ParkingLocation(
      parkLocationId: parkId,
      userId: (_userId.value == null) ? _userId.value = authBloc.userId : _userId.value,
      streetNumber: _streetNumber.value,
      street: _street.value,
      fullAddr: _fullAddr.value,
      city: _city.value,
      state: _state.value,
      zip: _zip.value,
      carType: _carType.value,
      radius: _radius.value,
      takenByCust: false,
      arrivalTime: _arrivalTime.value,
      parkAssist: _parkAssist.value.toString(),
      payment: _payment.value,
    );


    return db
        .setParkingLocation(parkingLocation)
        .then((value) => _locationSaved.sink.add(true))
        .catchError((error) => _locationSaved.sink.add(false));
  }






//Validators

  }

