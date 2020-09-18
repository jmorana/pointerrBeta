import 'dart:async';

import 'package:pointerr/src/app.dart';
import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/styles/decode_polylines.dart';
import 'package:pointerr/src/styles/directional_api_data.dart';
import 'package:pointerr/src/styles/directional_api_serializer.dart';
import 'package:pointerr/src/styles/map_screen_mixin.dart';
import 'package:pointerr/src/styles/map_style_json.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import '../app.dart';
import 'file:///C:/Users/josep/AndroidStudioProjects/mobilefarmersmarket1/lib/src/services/place_service.dart';
import 'package:pointerr/src/widgets/button.dart';
import 'package:pointerr/src/widgets/dropdown_button.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class CustomerMain extends StatefulWidget {



  @override
  _CustomerMainState createState() => _CustomerMainState();


}

class _CustomerMainState extends State<CustomerMain> with MapScreenMixins{
  StreamSubscription _userSubscription;
  GoogleMapController mapController;
  GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: "AIzaSyCxADIpos0ADPIpuNEnjbSpdxmx6pgzeVQ");
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
  final _controllerText = TextEditingController();
  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';
  List<GlobalKey<FormState>> _formKey = [];
  bool parkAssistBool = false;


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

    _formKey = new List<GlobalKey<FormState>>.generate(4,
            (i) => new GlobalKey<FormState>(debugLabel: ' _formKey'));
    super.initState();
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

  getMapData() {
    getCurrentLocation().then((value) async {
      print("Location data => $value");
      currentLat = value.latitude;
      currentLong = value.longitude;
      directionApiResult = await _getDirectionalApiData.fetch(
          LatLng(currentLat, currentLong), LatLng(currentLat - 0.001, currentLong - 0.009));
      print(directionApiResult);
      _markers.add(
        Marker(
          markerId: MarkerId("source"),
          position: LatLng(value.latitude, value.longitude),
          icon: sourceMapMarkerIcon,
        ),
      );
      /*_markers.add(
        Marker(
          markerId: MarkerId("destination"),
          position: LatLng(currentLat - 0.001, currentLong - 0.009),
          icon: destinationMapMarkerIcon,
        ),
      );*/
      _polylines.add(Polyline(
        polylineId: PolylineId("polyValue"),
        color: Colors.deepPurple,
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
    _controllerText.clear();
    _formKey.clear();
    super.dispose();
  }

  void requestParkingLocation(double long, double lat){
    //locationBloc.saveParkingLocation();
    Navigator.pushNamed(context, '/confirmation');
    print(lat.toString() + ' ' + long.toString());
  }

  @override
  Widget build(BuildContext context) {

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context, authBloc)

      );

    } else {
      return Scaffold(
        appBar: AppBar( backgroundColor: Colors.deepPurple,
          elevation: 0.0,
          title: Text('Request a Parking Location'),
          centerTitle: true,),
        body: pageBody(context, authBloc),

        drawer: myDrawer(),
      );

    }
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc){
    List<String> carList = List();
    carList.add('ADD A CAR IN YOUR CARS');

    List<String> timeList = List();
    timeList.add('1');
    timeList.add('2');
    timeList.add('3');
    timeList.add('4');
    List<String> parkAssist = List();
    parkAssist.add('yes');
    parkAssist.add('no');
    //carBloc.fetchMyCars().forEach((car) {carList.add(car.toString());});
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
        TextField(
          controller: _controllerText,
          readOnly: true,
          onTap: () async {
            // generate a new token here
            final sessionToken = Uuid().v4();
            Prediction result = await PlacesAutocomplete.show(
              context: context,
              apiKey: "AIzaSyCxADIpos0ADPIpuNEnjbSpdxmx6pgzeVQ",
              mode: Mode.fullscreen,
              language: "en",
              components: [Component(Component.country, "usa")],
            );
            // This will change the text displayed in the TextField
            if (result != null) {
              final placeDetails = await PlaceApiProvider(sessionToken)
                  .getPlaceDetailFromId(result.placeId);
              setState(() async {
                _controllerText.text = result.description;
                _streetNumber = placeDetails.streetNumber;
                _street = placeDetails.street;
                _city = placeDetails.city;
                _zipCode = placeDetails.zipCode;
                PlacesDetailsResponse detail =
                await _places.getDetailsByPlaceId(result.placeId);
                double latitude = detail.result.geometry.location.lat;
                double longitude = detail.result.geometry.location.lng;
                String address = result.description;
                destinationLat = latitude;
                destinationLong = longitude;
                _markers.add(
                  Marker(
                    markerId: MarkerId("destination"),
                    position: LatLng(latitude, longitude),
                    icon: destinationMapMarkerIcon,
                  ),

                );
                locationBloc.changeFullAddr(address);
                locationBloc.changeStreetNumber(_streetNumber);
                locationBloc.changeStreet(_street);
                locationBloc.changeCity(_city);
                locationBloc.changeZip(_zipCode);
              });

              //put marker on map


            }


          },
          decoration: InputDecoration(
            icon: Container(
              width: 10,
              height: 10,
              child: Icon(
                Icons.home,
                color: Colors.teal,
              ),
            ),
            hintText: "Enter your address",
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 80.0, top: 16.0),
          ),
        ),
        SizedBox(height: 20.0),
        StreamBuilder<String>(
            key: _formKey[0],
            stream: locationBloc.carType,
            builder: (context, snapshot) {
              return AppDropdownButton(
                hintText: 'Car Type',
                items: (carDropdown.isNotEmpty)? carDropdown:carList,
                value: snapshot.data,
                materialIcon: FontAwesomeIcons.car,
                cupertinoIcon: FontAwesomeIcons.car,
                onChanged: locationBloc.changeCarType,
              );
            }),

        /*StreamBuilder<String>(
                stream: locationBloc.radius,
                builder: (context, snapshot) {
                  return AppDropdownButton(
                    hintText: 'Radius',
                    items: radList,
                    value: snapshot.data,
                    materialIcon: FontAwesomeIcons.mapMarker,
                    cupertinoIcon: FontAwesomeIcons.mapMarker,
                    onChanged: locationBloc.changeRadius,
                  );
                }
            ),*/
        StreamBuilder<String>(
            key: _formKey[1],
            stream: locationBloc.arrivalTime,
            builder: (context, snapshot) {
              return AppDropdownButton(
                hintText: 'Arrival Time',
                items: timeList,
                value: snapshot.data,
                materialIcon: FontAwesomeIcons.clock,
                cupertinoIcon: FontAwesomeIcons.clock,
                onChanged: locationBloc.changeArrivalTime,
              );
            }
        ),
        /*StreamBuilder<String>(
                key: _formKey[2],
                stream: locationBloc.parkAssist,
                builder: (context, snapshot) {
                  return AppDropdownButton(
                    hintText: 'Parallel Park Assist',
                    items: parkAssist,
                    value: snapshot.data,
                    materialIcon: FontAwesomeIcons.question,
                    cupertinoIcon: FontAwesomeIcons.question,
                    onChanged: locationBloc.changeParkAssist,
                  );
                }
            ),*/
        checkbox(
            title: "Parallel Park Assist",
            initValue: parkAssistBool,
            onChanged: (sts) => setState(() {
              parkAssistBool = sts;
              locationBloc.changeParkAssist(parkAssistBool);
            } )),
        StreamBuilder<bool>(
            key: _formKey[3],
            stream: locationBloc.isValid,
            builder: (context, snapshot) {
              return AppButton(
                buttonType: (snapshot.data == true) ?
                ButtonType.DarkBlue
                    : ButtonType.DarkGray,
                buttonText: 'Request Parking Location',
                onPressed: () => requestParkingLocation(destinationLong, destinationLat),


              );
            }),



      ],
    );
  }


}