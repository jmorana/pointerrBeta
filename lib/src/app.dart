import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/blocs/location_bloc.dart';
import 'package:pointerr/src/routes.dart';
import 'package:pointerr/src/screens/landing.dart';
import 'package:pointerr/src/screens/login.dart';
import 'package:pointerr/src/services/firestore_service.dart';
import 'package:pointerr/src/services/geolocator_service.dart';
import 'package:pointerr/src/styles/colors.dart';
import 'package:pointerr/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import 'blocs/car_bloc.dart';

final authBloc = AuthBloc();
final locationBloc = LocationBloc();
final carBloc = CarBloc();
final firestoreService = FirestoreService();
final locatorService = GeoLocatorService();
double destinationLat = 0.0;
double destinationLong = 0.0;
final List<String> carDropdown = List();


class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();

}

class _AppState extends State<App> {


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider(create: (context) => authBloc),
        Provider(create: (context) => locationBloc),
        Provider(create: (context) => carBloc),
        FutureProvider(create: (context) => authBloc.isLoggedIn()),
        //fetch for dropdown!
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(create: (context) {
          ImageConfiguration configuration = createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(configuration, 'assets/images/ic_launcher.PNG');
        }),
      ],
      child: PlatformApp());
  }

  @override
  void dispose() {
    authBloc.dispose();
    locationBloc.dispose();
    super.dispose();
  }
}

class PlatformApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var isLoggedIn = Provider.of<bool>(context);

    if (Platform.isIOS) {
      return CupertinoApp(
        home: (isLoggedIn == null) ? loadingScreen(true) : (isLoggedIn == true ) ? Landing() : Login(),
        onGenerateRoute: Routes.cupertinoRoutes,
        theme: CupertinoThemeData(  
          primaryColor: AppColors.straw,
          scaffoldBackgroundColor: Colors.white,
          textTheme: CupertinoTextThemeData(  
            tabLabelTextStyle: TextStyles.suggestion
          )
        )
      ); 
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: (isLoggedIn == null) ? loadingScreen(false) : (isLoggedIn == true ) ? Landing() : Login(),
        onGenerateRoute: Routes.materialRoutes,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity
        )
      );
    }
  }

  Widget loadingScreen(bool isIOS){
    return (isIOS)
    ? CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator(),),)
    : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

}
