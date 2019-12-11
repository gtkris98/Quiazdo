import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:quizadoapp/Services/Auth.dart';
import 'package:quizadoapp/Pages/login.dart';

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
  @override
  void initState() {
    widget.auth.getCurrentUser().then((FirebaseUser firebaseUser){
      setState(() {
        user = firebaseUser;
        userName = user.displayName;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 6,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: _createAppBar(),
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome! ' + userName,
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    splashColor: Colors.red[100],
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: (){
                      widget.auth.signOut().then((_){
                        Navigator.of(context).pushReplacementNamed('/login');
                      }).catchError((e){
                        print(e);
                        new ErrorAlert(e.code, e.message, "Ok").showErrorAlert(context);
                      });
                    },
                  )
                ],
              )
          ),
        ),
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

  _createAppBar(){
    return AppBar(
      centerTitle: true,
      leading: Icon(Icons.cloud),
      title: Text('Weather',style: TextStyle(fontSize: 16.0),),
      bottom: PreferredSize(
          child: TabBar(
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
          preferredSize: Size.fromHeight(30.0)),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(Icons.account_circle),
        ),
      ],
    );
  }

  _createTabsBody(){
    return TabBarView(
      children: <Widget>[
        Container(
          child: Center(
            child: Text('Tab 1'),
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
}
