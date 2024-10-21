import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/screens/home_screen.dart';
import 'package:weather/services/weather_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherService>( // Specify the type argument
      create: (_) => WeatherService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      ),
    );
  }
}
