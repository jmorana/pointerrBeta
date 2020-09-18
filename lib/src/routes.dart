import 'package:pointerr/map_screen.dart';
import 'package:pointerr/src/screens/availableSpots.dart';
import 'package:pointerr/src/screens/confirmation.dart';
import 'package:pointerr/src/screens/contactHelp.dart';
import 'package:pointerr/src/screens/landing.dart';
import 'package:pointerr/src/screens/login.dart';
import 'package:pointerr/src/screens/finding_parker.dart';
import 'package:pointerr/src/screens/myCars.dart';
import 'package:pointerr/src/screens/myPayments.dart';
import 'package:pointerr/src/screens/parker.dart';
import 'package:pointerr/src/screens/settings_screen.dart';
import 'package:pointerr/src/screens/signup.dart';
import 'package:pointerr/src/screens/customerMain.dart';
import 'package:pointerr/src/widgets/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return MaterialPageRoute(builder: (context) => Landing());
      case "/signup":
        return MaterialPageRoute(builder: (context) => Signup());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/customer":
        return MaterialPageRoute(builder: (context) => CustomerMain());
      case "/parker":
        return MaterialPageRoute(builder: (context) => Parker());
      case "/orders":
        return MaterialPageRoute(builder: (context) => Orders());
      case "/availableSpots":
        return MaterialPageRoute(builder: (context) => AvailableSpots());
      case "/confirmation":
        return MaterialPageRoute(builder: (context) => Confirmation());
      case "/myCars":
        return MaterialPageRoute(builder: (context) => MyCars());
      case "/settingsScreen":
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      case "/contactHelp":
        return MaterialPageRoute(builder: (context) => ContactHelp());
      case "/myPayments":
        return MaterialPageRoute(builder: (context) => MyPayments());
      case "/map_screen":
        return MaterialPageRoute(builder: (context) => MapScreen());
      case "/finding_parker":
        return MaterialPageRoute(builder: (context) => FindingParker());
      default:
        //var routeArray = settings.name.split('/');
        //if (settings.name.contains('/editparkinglocation/')){
          //return MaterialPageRoute(builder: (context) => EditParkingLocation(userId: routeArray[2],));
        //}
        return MaterialPageRoute(builder: (context) => Login());
    }
  }

  static CupertinoPageRoute cupertinoRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return CupertinoPageRoute(builder: (context) => Landing());
      case "/signup":
        return CupertinoPageRoute(builder: (context) => Signup());
      case "/login":
        return CupertinoPageRoute(builder: (context) => Login());
      case "/customer":
        return CupertinoPageRoute(builder: (context) => CustomerMain());
      case "/parker":
        return CupertinoPageRoute(builder: (context) => Parker());
      case "/orders":
        return CupertinoPageRoute(builder: (context) => Orders());
      case "/availableSpots":
        return CupertinoPageRoute(builder: (context) => AvailableSpots());
      case "/confirmation":
        return CupertinoPageRoute(builder: (context) => Confirmation());
      case "/myCars":
        return CupertinoPageRoute(builder: (context) => MyCars());
      case "/settingsScreen":
        return CupertinoPageRoute(builder: (context) => SettingsScreen());
      case "/contactHelp":
        return CupertinoPageRoute(builder: (context) => ContactHelp());
      case "/myPayments":
        return CupertinoPageRoute(builder: (context) => MyPayments());
      case "/map_screen":
        return CupertinoPageRoute(builder: (context) => MapScreen());
      case "/finding_parker":
        return CupertinoPageRoute(builder: (context) => FindingParker());
      default:
      //var routeArray = settings.name.split('/');
        //if (settings.name.contains('/editparkinglocation/')){
          //return CupertinoPageRoute(builder: (context) => EditParkingLocation(userId: routeArray[2],));
        //}
        return CupertinoPageRoute(builder: (context) => Login());
    }
  }
}
