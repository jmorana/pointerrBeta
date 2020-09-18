import 'dart:async';

import 'package:pointerr/src/app.dart';
import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/styles/decode_polylines.dart';
import 'package:pointerr/src/styles/directional_api_data.dart';
import 'package:pointerr/src/styles/directional_api_serializer.dart';
import 'package:pointerr/src/styles/map_screen_mixin.dart';
import 'package:pointerr/src/styles/map_style_json.dart';
import '../app.dart';
import 'package:pointerr/src/services/geolocator_service.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:provider/provider.dart';


class FindingParker extends StatefulWidget {
  final geoService = GeoLocatorService();



  @override
  _FindingParkerState createState() => _FindingParkerState();


}

class _FindingParkerState extends State<FindingParker> with MapScreenMixins{
  StreamSubscription _userSubscription;
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  static double currentLat = 0.0;
  static double currentLong = 0.0;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  BitmapDescriptor sourceMapMarkerIcon;
  BitmapDescriptor destinationMapMarkerIcon;
  DirectionApiResult directionApiResult;
  GetDirectionalApiData _getDirectionalApiData = GetDirectionalApiData();
  bool isDataAvailable = false;
  bool isCameraIdle = false;


  @override
  void initState() {
    getPermission();
    setCustomMapPins();
    getMapData();
    Future.delayed(Duration.zero, (){
      var authBloc = Provider.of<AuthBloc>(context,listen: false);
      _userSubscription = authBloc.user.listen((user) {
        if (user == null) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      });
    });
    super.initState();
  }

  getMapData() {
    getCurrentLocation().then((value) async {
      print("Location data => $value");
      currentLat = value.latitude;
      currentLong = value.longitude;
      directionApiResult = await _getDirectionalApiData.fetch(
          LatLng(currentLat, currentLong), LatLng(12.11, 77.33));
      print(directionApiResult);
      _markers.add(
        Marker(
          markerId: MarkerId("source"),
          position: LatLng(value.latitude, value.longitude),
          icon: sourceMapMarkerIcon,
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("destination"),
          position: LatLng(12.11, 77.33),
          icon: destinationMapMarkerIcon,
        ),
      );
      _polylines.add(Polyline(
        polylineId: PolylineId("polyValue"),
        color: Colors.blue,
        width: 5,
        consumeTapEvents: true,
        onTap: () {},
        points: decodePolyline(
            directionApiResult.routes[0].overviewPolyline.points.toString()),
      ));

      setState(() {
        isDataAvailable = true;
      });
    });
  }

  checkUpdate(CameraUpdate cameraUpdate, GoogleMapController c) async {
    c.animateCamera(cameraUpdate);
    mapController.animateCamera(cameraUpdate);
    LatLngBounds boundStart = await c.getVisibleRegion();
    LatLngBounds boundEnd = await c.getVisibleRegion();
    if (boundStart.southwest.latitude == -90 ||
        boundEnd.southwest.latitude == -90) {
      checkUpdate(cameraUpdate, c);
    }
  }

  boundMap(LatLng south, LatLng north) async {
    LatLngBounds bound = LatLngBounds(southwest: south, northeast: north);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bound, 50);
    this.mapController.animateCamera(cameraUpdate).then((void v) {
      checkUpdate(cameraUpdate, this.mapController);
    });
    setState(() {
      isCameraIdle = true;
    });
  }

  void setCustomMapPins() async {
    await getBytesFromAsset('assets/images/man_marker.png', 150).then((pic) {
      sourceMapMarkerIcon = BitmapDescriptor.fromBytes(pic);
    });
    await getBytesFromAsset('assets/images/car_marker.png', 150).then((pic) {
      destinationMapMarkerIcon = BitmapDescriptor.fromBytes(pic);
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(currentLat, currentLong),
    zoom: 12,
    tilt: 80,
    bearing: 30,
  );


  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {




    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          child: pageBody(context, authBloc),

      );

    } else {
      return Scaffold(
        appBar: AppBar( backgroundColor: Colors.deepPurple,
          elevation: 0.0,
          title: Text('Finding a Parker'),
          centerTitle: true,),
        body: pageBody(context, authBloc),

        drawer: myDrawer(),
      );

    }
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc){

    return ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: true,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                getMapData();
                _controller.complete(controller);
                controller.setMapStyle(mapJson);
              },

            ),
          ),
          SizedBox(),
          Text('Looking for a parker in your neigborhood!'),
        ]
    );

  }
}