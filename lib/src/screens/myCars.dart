import 'dart:async';
import 'dart:io';

import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/models/car.dart';
import 'package:pointerr/src/widgets/button.dart';
import 'package:pointerr/src/widgets/dropdown_button.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:pointerr/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../app.dart';

class MyCars extends StatefulWidget {

  @override
  _MyCarState createState() => _MyCarState();


}

class _MyCarState extends State<MyCars> {
  StreamSubscription _userSubscription;
  



  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      var authBloc = Provider.of<AuthBloc>(context,listen: false);
      _userSubscription = authBloc.user.listen((user) {
        if (user == null) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          child: pageBody(context, authBloc)
      );

    } else {
      return Scaffold(
        drawer: myDrawer(),
          appBar: AppBar( backgroundColor: Colors.deepPurple,
          elevation: 0.0,
            title: Text('My Cars'),
            centerTitle: true,),
          body: pageBody(context, authBloc)
      );
    }
  }
  
  Widget pageBody(BuildContext context, AuthBloc authBloc){
    List<String> carMake = List();
    carMake.add('Mazda');
    carMake.add('Honda');
    carMake.add('Jeep');
    carMake.add('Rolls-Royce');
    carMake.add('Pontiac');
    carMake.add('Jaguar');
    carMake.add('Mercury');
    carMake.add('Alfa Romeo');
    carMake.add('Kia');
    carMake.add('Mercedes');
    carMake.add('Mitsubishi');
    carMake.add('Toyota');
    carMake.add('Buick');
    carMake.add('Maserati');
    carMake.add('Ford');
    carMake.add('Subaru');
    carMake.add('Chrysler');
    carMake.add('Hyundai');
    carMake.add('Porsche');
    carMake.add('Audi');
    carMake.add('Ferrari');
    carMake.add('Cadillac');
    carMake.add('Volvo');
    carMake.add('Dodge');
    carMake.add('Chevrolet');
    carMake.add('Nissan');
    carMake.add('Acura');
    carMake.add('BMW');
    carMake.add('Volkswagen');
    carMake.add('Range Rover');
    carMake.add('Land Rover');
    carMake.sort();

    List<String> carModel = List();
    carModel.add('Sedan');
    carModel.add('SUV');
    carModel.add('Truck');
    carModel.add('Crossover');


    List<String> carYear = List();
    carYear.add('1991');
    carYear.add('1992');
    carYear.add('1993');
    carYear.add('1994');
    carYear.add('1995');
    carYear.add('1996');
    carYear.add('1997');
    carYear.add('1998');
    carYear.add('1999');
    carYear.add('2000');
    carYear.add('2001');
    carYear.add('2002');
    carYear.add('2003');
    carYear.add('2004');
    carYear.add('2005');
    carYear.add('2006');
    carYear.add('2007');
    carYear.add('2008');
    carYear.add('2009');
    carYear.add('2010');
    carYear.add('2011');
    carYear.add('2012');
    carYear.add('2013');
    carYear.add('2014');
    carYear.add('2015');
    carYear.add('2016');
    carYear.add('2017');
    carYear.add('2018');
    carYear.add('2019');
    carYear.add('2020');
    return ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          StreamBuilder<String>(
              stream: carBloc.carYear,
              builder: (context, snapshot) {
                return AppDropdownButton(
                  hintText: 'Year',
                  items: carYear,
                  value: snapshot.data,
                  materialIcon: FontAwesomeIcons.car,
                  cupertinoIcon: FontAwesomeIcons.car,
                  onChanged: carBloc.changeCarYear,
                );
              }),
          StreamBuilder<String>(
              stream: carBloc.carMake,
              builder: (context, snapshot) {
                return AppDropdownButton(
                  hintText: 'Make',
                  items: carMake,
                  value: snapshot.data,
                  materialIcon: FontAwesomeIcons.car,
                  cupertinoIcon: FontAwesomeIcons.car,
                  onChanged: carBloc.changeCarMake,
                );
              }),
          StreamBuilder<String>(
              stream: carBloc.carModel,
              builder: (context, snapshot) {
                return AppDropdownButton(
                  hintText: 'Model',
                  items: carModel,
                  value: snapshot.data,
                  materialIcon: FontAwesomeIcons.car,
                  cupertinoIcon: FontAwesomeIcons.car,
                  onChanged: carBloc.changeCarModel,
                );
              }),
          StreamBuilder<String>(
              stream: carBloc.carLicense,
              builder: (context, snapshot) {
                return AppTextField(
                  hintText: 'License Plate',
                  cupertinoIcon: FontAwesomeIcons.searchLocation,
                  materialIcon: FontAwesomeIcons.searchLocation,
                  isIOS: Platform.isIOS,
                  errorText: snapshot.error,
                  onChanged: carBloc.changeCarLicense,
                );
              }),
          StreamBuilder<bool>(
              stream: carBloc.isValid,
              builder: (context, snapshot) {
                return AppButton(
                  buttonType: (snapshot.data == true) ?
                  ButtonType.DarkBlue
                      : ButtonType.Disabled,
                  buttonText: 'Add to My Cars List',
                  onPressed: () => (carBloc.saveUsersCar()),

                );
              }),
          SizedBox(),
          ListTile(
            title: Text(' Year          Model          Type           License Plate'),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),
          SizedBox(),
          StreamBuilder<List<Car>>(
              stream: carBloc.fetchMyCars(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return (Platform.isIOS)
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator();

                return ListView.builder(
                  //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      var car = snapshot.data[index];
                      //add to car Dropdown
                      /*if(carDropdown.contains(car.year + ' ' + car.make)){}
                        else{

                        print(carDropdown[index]);
                      }*/


                      return ListTile(
                          title: Text(' ' + car.year + '      ' + car.make + '       ' + car.model + '         ' + car.licensePlate),

                          onTap: (){}

                      );
                    });

              }

          )

        ]);
  }

}
