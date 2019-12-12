import 'dart:convert';

import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

class WeatherUtil{

  static const String _apiKey = "cb43536ad53ccd2294b9c3f757f13627";
  static const String FORECAST = 'forecast';
  static const String WEATHER = 'weather';

  Future<Weather> getCurrentWeather(LocationData location) async{
    //TODO: Implement this class
    Map<String, dynamic> currentWeather = await _requestOpenWeatherAPIUsingLocation(WEATHER, location);
    return Weather(currentWeather);
  }

  Future<Map<String, dynamic>> _requestOpenWeatherAPIUsingLocation(String tag, LocationData location) async {

      String url = 'http://api.openweathermap.org/data/2.5/' +
          '$tag?' +
          'lat=${location.latitude}&' +
          'lon=${location.longitude}&' +
          'appid=$_apiKey';

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonBody = json.decode(response.body);
        return jsonBody;
      }

      else {
        throw OpenWeatherAPIException("OpenWeather API Exception: ${response.body}");
      }

  }

}