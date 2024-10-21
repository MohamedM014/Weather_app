// services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = 'c77f1e5fd20b09bfc10ccfadf8d6f029'; // Replace with your OpenWeatherMap API key
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather?q=Cairo,EG&appid=c77f1e5fd20b09bfc10ccfadf8d6f029&units=metric';

  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = '$baseUrl?q=$cityName,eg&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
