
import 'file:///C:/Users/josep/AndroidStudioProjects/mobilefarmersmarket1/lib/src/services/place_service.dart';
import 'package:pointerr/src/services/geolocator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AvailableSpots extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeoLocatorService();

      return FutureProvider(
        create: (context) => placesProvider,
        child: Scaffold(
          body: (currentPosition != null)
              ? Consumer<List<Place>>(
            builder: (_, places, __) {
              return (places != null)
                  ? Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          zoom: 16.0),
                      zoomGesturesEnabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                ],
              )
                  : Center(child: CircularProgressIndicator());
            },
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    void _launchMapsUrl(double lat, double lng) async {
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
