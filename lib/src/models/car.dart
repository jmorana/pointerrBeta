
class Car {
  final String carId;
  final String userId;
  final String year;
  final String make;
  final String model;
  final String licensePlate;

  Car({this.carId, this.userId, this.year, this.make, this.model, this.licensePlate,});

  Map<String,dynamic> toMap(){
    return {
      'carId' : carId,
      'userId' : userId,
      'year': year,
      'make': make,
      'model': model,
      'licensePlate' : licensePlate,
    };
  }

  Car.fromFirestore(Map<String,dynamic> firestore)
      : carId = firestore['carId'],
        userId = firestore['userId'],
        year = firestore['year'],
        make = firestore['make'],
        model = firestore['model'],
        licensePlate = firestore['licensePlate'];
}