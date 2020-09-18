

import 'dart:async';
import 'dart:io';

import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/styles/decode_polylines.dart';
import 'package:pointerr/src/styles/directional_api_data.dart';
import 'package:pointerr/src/styles/directional_api_serializer.dart';
import 'package:pointerr/src/styles/map_screen_mixin.dart';
import 'package:pointerr/src/styles/map_style_json.dart';
import 'package:pointerr/src/widgets/button.dart';
import 'package:pointerr/src/widgets/dropdown_button.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../app.dart';


class Confirmation extends StatefulWidget {



  @override
  _ComfirmationState createState() => _ComfirmationState();


}

class _ComfirmationState extends State<Confirmation> with MapScreenMixins{
  StreamSubscription _userSubscription;
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  static double currentLat = 40.7630;
  static double currentLong = -73.9076;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  BitmapDescriptor sourceMapMarkerIcon;
  BitmapDescriptor destinationMapMarkerIcon;
  DirectionApiResult directionApiResult;
  GetDirectionalApiData _getDirectionalApiData = GetDirectionalApiData();
  bool isDataAvailable = false;
  bool isCameraIdle = false;
  String rad = " ";
  bool pointerrS = false;
  bool pointerrVIP = false;



  @override
  void initState() {
    getPermission();
    setCustomMapPins();
    getMapData();
    Future.delayed(Duration.zero, () {
      var authBloc = Provider.of<AuthBloc>(context, listen: false);
      _userSubscription = authBloc.user.listen((user) {
        if (user == null) Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', (route) => false);
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
          LatLng(currentLat, currentLong), LatLng(destinationLat, destinationLong));
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
          position: LatLng(destinationLat, destinationLong),
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

  Widget checkbox(
      {String title, bool initValue, Function(bool boolValue) onChanged}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(value: initValue, onChanged: (b) => onChanged(b)),
          Text(title),
        ]);
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
    await getBytesFromAsset('assets/images/man_marker.png', 100).then((pic) {
      sourceMapMarkerIcon = BitmapDescriptor.fromBytes(pic);
    });
    await getBytesFromAsset('assets/images/car_marker.png', 100).then((pic) {
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

  void confirmParkingSpot(){

    //update radius and payment
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
          title: Text('Confirm Spot'),
          centerTitle: true,),
          body: pageBody(context, authBloc)
      );
  }
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc){
    List<String> payments = List();
    payments.add('pay 1');
    payments.add('pay 2');
    payments.add('Apple pay');
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
          SizedBox(),
          checkbox(
              title: "  Pointerr S        0.5 Miles      FREE",
              initValue: pointerrS,
              onChanged: (sts) => setState(() {
                pointerrS = sts;
                if(pointerrS == true)  rad = '0.5'; else rad = '0.25';
                print(rad);
                locationBloc.changeRadius(rad);
              })),
          checkbox(
              title: "Pointerr VIP    0.25 Miles      FREE",
              initValue: pointerrVIP,
              onChanged: (sts) => setState((){
                pointerrVIP = sts;
                if(pointerrVIP == true)  rad = '0.5'; else rad = '0.25';
                print(rad);
                locationBloc.changeRadius(rad);

              })),
          /*FlatButton(
              child: Text("Comfirm Spot"),
              onPressed: () {
                print("S is ${pointerrS ? 'checked' : 'unchecked'}");
                print("VIP is ${pointerrVIP ? 'checked' : 'unchecked'}");
                if(pointerrVIP == pointerrS) print('no good radius');
                if(pointerrS == true)  rad = '0.5'; else rad = '0.25';
                print(rad);
                locationBloc.changeRadius(rad);
                locationBloc.editParkingLocation();

              }
              ),*/



          StreamBuilder<String>(
              stream: locationBloc.payment,
              builder: (context, snapshot) {
                return AppDropdownButton(
                  hintText: 'Payment Option',
                  items: payments,
                  value: snapshot.data,
                  materialIcon: FontAwesomeIcons.moneyBill,
                  cupertinoIcon: FontAwesomeIcons.moneyBill,
                  onChanged: locationBloc.changePayment,
                );
              }
          ),
          StreamBuilder<bool>(
              stream: locationBloc.isValidConfirm,
              builder: (context, snapshot) {
                return AppButton(
                  buttonType: (snapshot.data == true) ?
                  ButtonType.DarkBlue
                      : ButtonType.Disabled,
                  buttonText: 'Confirm Spot',
                  onPressed: () {
                    print("S is ${pointerrS ? 'checked' : 'unchecked'}");
                    print("VIP is ${pointerrVIP ? 'checked' : 'unchecked'}");
                    if(pointerrVIP == pointerrS) print('no good radius');
                    locationBloc.saveParkingLocation();
                    Navigator.pushNamed(context, '/finding_parker');

                  },

                );
              })
        ]
    );

  }
}