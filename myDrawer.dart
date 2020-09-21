import 'package:pointerr/src/blocs/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class myDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[

          DrawerHeader(
            child: Text(authBloc.firstName + ' ' + authBloc.lastName,
                textAlign: TextAlign.center,
                ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: Text('Pointerr'),
            leading: Icon(Icons.control_point),
            onTap: ()
            {
              // Update the state of the app.
              Navigator.pop(context);
              Navigator.pushNamed(context, '/customer');

            },
          ),
          ListTile(
            title: Text('Your Orders'),
            leading: Icon(Icons.reorder),
            onTap: ()
            {
              // Update the state of the app.
              Navigator.pop(context);
              Navigator.pushNamed(context, '/orders');

            },
          ),
          ListTile(
            title: Text('Your Cars'),
            leading: Icon(Icons.directions_car),
            onTap: () {
              // Update the state of the app.

              Navigator.pop(context);
              Navigator.pushNamed(context, '/myCars');
            },
          ),
          ListTile(
            title: Text('Payment Options'),
            leading: Icon(Icons.attach_money),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pop(context);
              Navigator.pushNamed(context, '/myPayments');
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settingsScreen');
            },
          ),
          ListTile(
            title: Text('Contact/Help'),
            leading: Icon(Icons.help),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contactHelp');
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              // Update the state of the app.
              authBloc.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),

    );
  }

}