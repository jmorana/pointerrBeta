import 'dart:async';

import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:pointerr/src/styles/base.dart';
import 'package:pointerr/src/styles/text.dart';
import 'package:pointerr/src/widgets/alerts.dart';
import 'package:pointerr/src/widgets/button.dart';
import 'package:pointerr/src/widgets/social_button.dart';
import 'package:pointerr/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class Signup extends StatefulWidget{
  

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  StreamSubscription _userSubscription;
  StreamSubscription _errorMessageSubscription;
  List<GlobalKey<FormState>> _formKey = [];



  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context,listen: false);
    _userSubscription = authBloc.user.listen((user) {
      if (user != null) Navigator.pushReplacementNamed(context, '/landing');
    });

     _errorMessageSubscription = authBloc.errorMessage.listen((errorMessage) {
      if (errorMessage != '' ) {
        AppAlerts.showErrorDialog(Platform.isIOS, context, errorMessage).then((_) => authBloc.clearErrorMessage());
      } 
     });

    _formKey = new List<GlobalKey<FormState>>.generate(7,
            (i) => new GlobalKey<FormState>(debugLabel: ' _formKey'));
    super.initState();
  }

   @override
  void dispose() {
    _userSubscription.cancel();
    _errorMessageSubscription.cancel();
    _formKey.clear();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    if (Platform.isIOS){
      return CupertinoPageScaffold(
        child: pageBody(context,authBloc),
      );
    } else {
      return Scaffold(
        body: pageBody(context,authBloc),
      );
    }
  }

  Widget pageBody(BuildContext context,AuthBloc authBloc) {
    return ListView(
      //physics: NeverScrollableScrollPhysics(),
      addRepaintBoundaries: true,
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .15,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/back1.png'),
                  fit: BoxFit.fill)),
        ),
        Padding(
          padding: BaseStyles.listPadding,
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'POINTERR',
                style: TextStyles.subtitle,
              )),
        ),
        Container(
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/ic_launcher.PNG')),
          ),
        ),
     StreamBuilder<String>(
          key: _formKey[0],
          stream: authBloc.email,
          builder: (context, snapshot) {
            return AppTextField(  
              isIOS: Platform.isIOS,
              hintText: 'Email',
              cupertinoIcon: CupertinoIcons.mail_solid,
              materialIcon: Icons.email,
              textInputType: TextInputType.emailAddress,
              errorText: snapshot.error,
              onChanged: authBloc.changeEmail,
            );
          }
        ),
        StreamBuilder<String>(
            key: _formKey[1],
          stream: authBloc.password,
          builder: (context, snapshot) {
            return AppTextField( 
              isIOS: Platform.isIOS,
              hintText: 'Password',
              cupertinoIcon: CupertinoIcons.padlock_solid,
              materialIcon: Icons.lock,
              obscureText: true,
              errorText: snapshot.error,
              onChanged: authBloc.changePassword,
            );
          }
        ),
        StreamBuilder<String>(
            key: _formKey[2],
            stream: authBloc.password2,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Re-enter Password',
                cupertinoIcon: CupertinoIcons.padlock_solid,
                materialIcon: Icons.lock,
                obscureText: true,
                errorText: snapshot.error,
                onChanged: authBloc.changePassword,
              );
            }
        ),
        StreamBuilder<String>(
            key: _formKey[3],
            stream: authBloc.fName,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'First Name',
                cupertinoIcon: CupertinoIcons.profile_circled,
                materialIcon: Icons.person,
                textInputType: TextInputType.text,
                errorText: snapshot.error,
                onChanged: authBloc.changefName,
              );
            }
        ),
        StreamBuilder<String>(
            key: _formKey[4],
            stream: authBloc.lName,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Last Name',
                cupertinoIcon: CupertinoIcons.profile_circled,
                materialIcon: Icons.person,
                textInputType: TextInputType.text,
                errorText: snapshot.error,
                onChanged: authBloc.changelName,
              );
            }
        ),
        StreamBuilder<String>(
            key: _formKey[5],
            stream: authBloc.phoneNumber,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Phone Number',
                cupertinoIcon: CupertinoIcons.phone,
                materialIcon: Icons.phone,
                textInputType: TextInputType.text,
                errorText: snapshot.error,
                onChanged: authBloc.changePhoneNumber,
              );

            }
        ),
        StreamBuilder<bool>(
            key: _formKey[6],
          stream: authBloc.isValidSignup,
          builder: (context, snapshot) {
            return AppButton(buttonText: 'Signup',buttonType: (snapshot.hasData == true) ? ButtonType.LightBlue : ButtonType.Disabled, onPressed: authBloc.signupEmail,);
          }
        ),
        SizedBox(height: 6.0,),
        Center(child: Text('Or',style: TextStyles.suggestion),),
        SizedBox(height: 6.0,),
        Padding(
          padding: BaseStyles.listPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppSocialButton(socialType: SocialType.Facebook,),
              SizedBox(width:15.0),
              AppSocialButton(socialType: SocialType.Google),
          ],),
        ),
        Padding( 
          padding: BaseStyles.listPadding,
          child: RichText( 
            textAlign: TextAlign.center,
            text: TextSpan(  
              text: 'Already Have an Account? ',
              style: TextStyles.body, 
              children: [ 
                TextSpan(  
                  text: 'Login',
                  style: TextStyles.link,
                  recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushNamed(context, '/login')
                )
              ]
            )
          ),
        )
      ],
    );
  }
}