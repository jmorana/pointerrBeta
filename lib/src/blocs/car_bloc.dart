import 'package:pointerr/src/models/car.dart';
import 'package:pointerr/src/services/firebase_storage_service.dart';
import 'package:pointerr/src/services/firestore_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../app.dart';

class CarBloc {
  final _carId = BehaviorSubject<String>();
  final _userId = BehaviorSubject<String>();

  final _carYear = BehaviorSubject<String>();
  final _carModel = BehaviorSubject<String>();
  final _carMake = BehaviorSubject<String>();
  final _carLicense = BehaviorSubject<String>();
  final _carSaved = BehaviorSubject<bool>();



  final db = FirestoreService();
  var uuid = Uuid();
  final storageService = FirebaseStorageService();

  //Get
  Stream<String> get carId => _carId.stream;
  Stream<String> get userId => _userId.stream;
  Stream<String> get carYear => _carYear.stream;
  Stream<String> get carModel => _carModel.stream;

  Stream<String> get carMake => _carMake.stream;
  Stream<String> get carLicense => _carLicense.stream;
  Stream<bool> get carSaved => _carSaved.stream;






  Stream<bool> get isValid => CombineLatestStream.combine4(
      carYear, carModel, carMake, carLicense,  (a, b, c, d,) => true);

  Stream<List<Car>> fetchMyCars() => db.fetchCars(authBloc.userId);





  //Set

  Function(String) get changeCarYear => _carYear.sink.add;
  Function(String) get changeCarModel => _carModel.sink.add;

  Function(String) get changeCarMake => _carMake.sink.add;
  Function(String) get changeCarLicense => _carLicense.sink.add;






  dispose() {
    _carYear.close();
    _carModel.close();
    _carMake.close();
    _carLicense.close();
    _carSaved.close();
    _userId.close();
    _carId.close();

  }

  //Functions
  Future<void> saveUsersCar() async {
    var car = Car(
      carId: uuid.v4(),
      userId: (_userId.value == null) ? _userId.value = authBloc.userId : _userId.value,
      model: _carModel.value,
      make: _carMake.value,

      year : _carYear.value,
      licensePlate: _carLicense.value,

    );
    print("done");
    carDropdown.add( car.year + ' ' + car.make);


    return db
        .setCar(car)
        .then((value) => _carSaved.sink.add(true))
        .catchError((error) => _carSaved.sink.add(false));
  }






//Validators

}

