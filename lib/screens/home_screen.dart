import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/widgets/weather_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WeatherModel? _weatherData;
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather('Cairo');
  }

  Future<void> _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final data = await _weatherService.fetchWeather(cityName);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      _showSnackbar('Failed to get the weather');
    } finally {
      setState(() {
        _isLoading = false; // End loading
      });
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3), // Snackbar duration
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: () => _fetchWeather('Cairo'),
            icon: Icon(Icons.refresh), // Refresh button
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _weatherData == null
                ? Center(child: Text("No weather data available"))
                : Column(
                    children: [
                      _buildWeatherHeader(),
                      SizedBox(height: 40),
                      _buildWeatherOverview(_weatherData!),
                      SizedBox(height: 40),
                      _buildWeatherStats(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _weatherData!.cityName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        SizedBox(height: 8),
        Text(
          "${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][DateTime.now().weekday - 1]}, ${DateTime.now().day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][DateTime.now().month - 1]}",
          style: TextStyle(color: Colors.black.withOpacity(.5)),
        ),
      ],
    );
  }

  Widget _buildWeatherOverview(WeatherModel weatherData) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF9aaff2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          right: 30,
          top: 30,
          child: Text(
            '${weatherData.temperature.toStringAsFixed(1)}°C',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 92, color: const Color(0xFFa6c2ea)),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Image.network(
            'https://openweathermap.org/img/wn/${weatherData.icon}@2x.png',
            height: 120,
            width: 120,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 30,
          child: Text(
            weatherData.description,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        WeatherCard(
          icon: "assets/weather/image.png",
          label: 'Wind Speed',
          value: '${_weatherData!.windSpeed} m/s',
        ),
        WeatherCard(
          icon: "assets/weather/humidity.png",
          label: 'Humidity',
          value: '${_weatherData!.humidity}%',
        ),
        WeatherCard(
          icon: "assets/weather/temp2.jpg",
          label: 'Max Temp',
          value: '${_weatherData!.maxTemp.toStringAsFixed(1)}°C',
        ),
      ],
    );
  }
}
