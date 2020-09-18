import 'dart:async';

import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/screens/customerMain.dart';
import 'package:pointerr/src/widgets/myDrawer.dart';
import 'package:pointerr/src/widgets/navbar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class Parker extends StatefulWidget {


  @override
  _ParkerState createState() => _ParkerState();
}

class _ParkerState extends State<Parker> {
  StreamSubscription _userSubscription;

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      var authBloc = Provider.of<AuthBloc>(context,listen: false);
      _userSubscription = authBloc.user.listen((user) {
        if (user == null) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return <Widget> [
            myDrawer(),
            AppNavbar.cupertinoNavBar(title: 'Parker Name',context: context),
            ];
          },
          body: CustomerMain(),
        ),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
                  return <Widget> [
                    myDrawer()
                  ];
                },
                body: CustomerMain(),)
            )
        );

    }
  }
}