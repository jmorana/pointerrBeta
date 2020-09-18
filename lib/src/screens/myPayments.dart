import 'dart:async';
import 'dart:io';

import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../map_screen.dart';
import '../app.dart';

class MyPayments extends StatefulWidget {

  @override
  _MyPaymentsState createState() => _MyPaymentsState();


}

class _MyPaymentsState extends State<MyPayments> {
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
            title: Text('Payment Options'),
            centerTitle: true,),
          body: pageBody(context, authBloc)
      );
    }
  }

  Widget pageBody(BuildContext context,AuthBloc authBloc) {
    return ListView(
        children: <Widget>[
          SizedBox(),
          ListTile(
            title: Text(' Payment options coming soon!'),
            onTap: ()
            {
              // Update the state of the app.
            },
          ),
          //MapScreen(),


        ]
    );

  }
}