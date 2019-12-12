import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:quizadoapp/Pages/current_weather.dart';
import 'package:quizadoapp/Services/Auth.dart';
import 'package:quizadoapp/Pages/login.dart';
import 'package:quizadoapp/Widgets/app_drawer.dart';

import '../widgets/error_alert.dart';

class UserDashboardWidget extends StatefulWidget {
  final BaseAuth auth;
  const UserDashboardWidget(this.auth);
  @override
  State<StatefulWidget> createState() => new UserDashboard();
}

class UserDashboard extends State<UserDashboardWidget> {
  FirebaseUser user;
  String userName = 'User';
  Image logo = Image.asset('assets/logo.png');
  @override
  void initState() {
    widget.auth.getCurrentUser().then((FirebaseUser firebaseUser) {
      setState(() {
        user = firebaseUser;
        userName = user.displayName;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text(
            'Weather',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        drawer: _createDrawer(),
        body: new DefaultTabController(
            length: 6,
            child: new Scaffold(
              appBar: _createAppBar(),
              body: _createTabsBody(),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  _createAppBar() {
    return AppBar(
      title: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(
              child: Text('Today'),
            ),
            Tab(
              child: Text('Tomorrow'),
            ),
            Tab(
              child: Text('10 Days'),
            ),
            Tab(
              child: Text('30 Days'),
            ),
            Tab(
              child: Text('Countries'),
            ),
            Tab(
              child: Text('Cities'),
            )
          ]),
    );
  }

  _createTabsBody() {
    return TabBarView(
      children: <Widget>[
        Container(
          child: Center(
            child: CurrentWeather(),
          ),
        ),
        Container(
          child: Center(
            child: Text('Tab 2'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Tab 3'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Tab 4'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Tab 5'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Tab 6'),
          ),
        ),
      ],
    );
  }

  _createDrawer() {
    return Drawer(
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
                    child: logo,
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(user?.email.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
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
            title: Text(
              'Item 2',
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                letterSpacing: 1.1,
                fontSize: 15,
              ),
            ),
            onTap: () {
              widget.auth.signOut().then((_) {
                Navigator.of(context).pushReplacementNamed('/login');
              }).catchError((e) {
                print(e);
                new ErrorAlert(e.code, e.message, "Ok").showErrorAlert(context);
              });
            },
            leading: Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }
}
