
import 'package:pointerr/src/app.dart';
import 'package:pointerr/src/blocs/location_bloc.dart';
import 'package:pointerr/src/models/parkingLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pointerr/src/blocs/auth_bloc.dart';


import 'package:provider/provider.dart';

import 'myDrawer.dart';

class Orders extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var locationBloc = Provider.of<LocationBloc>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(locationBloc, context, authBloc.userId),
      );
    } else {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepPurple,
          elevation: 0.0,
          title: Text('Your Orders'),
          centerTitle: true,),
        drawer: myDrawer(),
        body: pageBody(locationBloc, context, authBloc.userId),
      );
    }
  }

  Widget pageBody(LocationBloc location, BuildContext context, String userId) {
    return StreamBuilder<List<ParkingLocation>>(
        stream: location.fetchParkingLocations(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return (Platform.isIOS)
              ? CupertinoActivityIndicator()
              : CircularProgressIndicator();


          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var location1 = snapshot.data[index];
                return ListTile(
                  title: Text(' ' + 'Date              ' +
                      (location1.radius == '0.5'
                          ? 'Pointerr S   '
                          : 'Pointerr VIP') + '               price'),
                  onTap: () {},
                );
              }
          );
        }
    );
  }
}
