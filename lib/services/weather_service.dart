import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';

class WeatherService with ChangeNotifier {
  final String _apiKey = 'c77f1e5fd20b09bfc10ccfadf8d6f029';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherModel? _weatherData;
  List<WeatherModel>? _forecastData;
  bool _isLoading = false;

  WeatherModel? get weatherData => _weatherData;
  List<WeatherModel>? get forecastData => _forecastData;
  bool get isLoading => _isLoading;

  // Fetch current weather data
  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    notifyListeners();

    final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _weatherData = WeatherModel.fromJson(jsonData);
      await fetchFiveDayForecast(cityName); // Fetch forecast after current weather
    } else {
      _weatherData = null;
      _forecastData = null; // Reset forecast data
      throw Exception('Failed to load weather data');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch 5-day forecast
  Future<void> fetchFiveDayForecast(String cityName) async {
    final url = '$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _forecastData = [];
      for (var item in jsonData['list']) {
        _forecastData!.add(WeatherModel.fromJson(item));
      }
    } else {
      throw Exception('Failed to load forecast data');
    }

    notifyListeners();
  }
}
