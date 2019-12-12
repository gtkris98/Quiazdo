import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizadoapp/Services/Auth.dart';

//class AppDrawer extends StatefulWidget {
//  final FirebaseUser _user;
//  const AppDrawer(this._user);
//  @override
//  _AppDrawer createState() => _AppDrawer();
//}

class AppDrawer extends StatelessWidget {
  final FirebaseUser _user;
  const AppDrawer(this._user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                Text(
                  _user?.displayName.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(_user?.email.toString(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey[600])),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
