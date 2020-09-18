import 'dart:async';
import 'dart:io';

import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app.dart';

class ContactHelp extends StatefulWidget {

  @override
  _ContactHelpState createState() => _ContactHelpState();


}

class _ContactHelpState extends State<ContactHelp> {
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
          child: pageBody(context, authBloc)
      );

    } else {
      return Scaffold(
          drawer: myDrawer(),
          appBar: AppBar(backgroundColor: Colors.deepPurple,
            elevation: 0.0,
            title: Text('Contact/Help'),
            centerTitle: true,),
          body: pageBody(context, authBloc)
      );
    }
  }
  
  Widget pageBody(BuildContext context, AuthBloc authBloc){
    return ListView(
        children: <Widget>[

          SizedBox(),
          ListTile(
            title: Text(' For any questions or help please contact us at:'),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),
          SizedBox(),
          ListTile(
            title: Text('     Email:      support@pointerr.com         '),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),
          SizedBox(),
          ListTile(
            title: Text('     Phone Number:   (800)123-4567        '),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),

        ]
    );
  }
}