import 'package:pointerr/src/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Landing extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS){
      return CupertinoPageScaffold(  
        child: pageBody(context),
      );
    } else {
      return Scaffold(body:pageBody(context));
    }
  }

  Widget pageBody(BuildContext context){
    return Column(  
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AppButton(  
          buttonText: 'Customer Page',
          buttonType: ButtonType.LightBlue,
          onPressed: () => Navigator.pushNamed(context, '/customer'),
        ),
        AppButton(
          buttonText: 'Parker Page',
          buttonType: ButtonType.LightBlue,
          onPressed: () => Navigator.pushNamed(context, '/parker'),
        ),

      ],
    );
  }
}