import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:charcode/charcode.dart';
import 'package:quizadoapp/Services/WeatherUtil.dart';
import 'package:weather/weather.dart';


class CurrentWeather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CurrentWeather();
}

class _CurrentWeather extends State<CurrentWeather> {

  Weather _weather;
  WeatherUtil _weatherUtil = new WeatherUtil();
  LocationData currentLocation;
  var location = new Location();
  Image clearSkyGif = Image.asset('assets/clear-sky-day.gif');
  int $deg = 0x00B0;

  @override
  void initState() {
    _getCurrentLocation().then((LocationData ld) {
      setState(() {
        if(ld != null){
          currentLocation = ld;
          _getCurrentWeather();
        }
        else{
          currentLocation = null;
        }
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(clearSkyGif.image, context);
  }

  @override
  Widget build(BuildContext context) {

    return _generateWidget();
  }

  Future<LocationData> _getCurrentLocation() async {
    LocationData currentLocation1;
    try {
      currentLocation1 = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation1 = null;
    }
    return currentLocation1;
  }

  void _getCurrentWeather() {
    _weatherUtil.getCurrentWeather(currentLocation).then((Weather w){
      setState(() {
        _weather = w;
      });
    });
  }

  Widget _generateWidget(){
    if(currentLocation != null && _weather != null){
      return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                expandedHeight: 400.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    _weather.areaName + " - " + _weather.temperature.celsius.toStringAsFixed(0) + String.fromCharCode($deg) + 'C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: 'DancingScript',
                      letterSpacing: 2.0,
                      fontFeatures: [FontFeature.oldstyleFigures()],
                    ),
                  ),
                  background:
                  Image.asset('assets/snow.gif', fit: BoxFit.fill),
                ),
              ),
            ];
          },
          body: Center(
            child: Text(
                currentLocation?.latitude.toString() + ', ' + currentLocation?.longitude.toString()
            ),
          )
      );
    }
    else{
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "This app need Location permission to function",
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20),
              ),
              textColor: Theme.of(context).primaryColor,
              color: Colors.white,
              splashColor: Colors.red,
              onPressed: () {
                _getCurrentLocation().then((LocationData ld) {
                  setState(() {
                    if(ld != null){
                      currentLocation = ld;
                      _getCurrentWeather();
                    }
                    else{
                      currentLocation = null;
                    }
                  });
                });
              },
              child: Text(
                'Give Location Permission',
                style: TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      );
    }
  }
}
