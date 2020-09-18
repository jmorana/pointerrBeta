import 'dart:async';
import 'dart:io';

import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();


}

class _SettingsScreenState extends State<SettingsScreen> {
  StreamSubscription _userSubscription;


  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var authBloc = Provider.of<AuthBloc>(context, listen: false);
      _userSubscription = authBloc.user.listen((user) {
        if (user == null) Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', (route) => false);
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
            child: pageBody(context, authBloc),
        );

      } else {
        return Scaffold(
          body: pageBody(context, authBloc),
            drawer: myDrawer(),
            appBar: AppBar(backgroundColor: Colors.deepPurple,
              elevation: 0.0,
              title: Text('Settings'),
              centerTitle: true,),
        );
      }
  }
  Widget pageBody(BuildContext context,AuthBloc authBloc) {
    return ListView(
        children: <Widget>[
          SizedBox(),
          ListTile(
            title: Text('                        '+ authBloc.firstName + ' ' + authBloc.lastName),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),
          SizedBox(
            height: 150.0,
            width: 20.0,
            child: Container(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: Text('     Email:         ' + authBloc.getEmail),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),
          SizedBox(),
          ListTile(
            title: Text('     Phone Number:         ' + authBloc.getPhone),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),
          SizedBox(),
          ListTile(
            title: Text('     Your Rating:         '),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),

        ]);


  }

}