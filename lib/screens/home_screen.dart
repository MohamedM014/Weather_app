import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      await Provider.of<WeatherService>(context, listen: false).fetchWeather(cityName);
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
      duration: const Duration(seconds: 3), // Snackbar duration
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherService>(context).weatherData;
    final forecastData = Provider.of<WeatherService>(context).forecastData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: () => _fetchWeather('Cairo'), // Refresh button
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : weatherData == null
                  ? const Center(child: Text("No weather data available"))
                  : Column(
                      children: [
                        _buildWeatherHeader(weatherData),
                        const SizedBox(height: 40),
                        _buildWeatherOverview(weatherData),
                        const SizedBox(height: 40),
                        _buildWeatherStats(weatherData),
                        const SizedBox(height: 40),
                        _buildForecast(forecastData!), // Adding the 5-day forecast
                      ],
                    ),
        ),
      ),
    );
  }

  // Weather Header
  Widget _buildWeatherHeader(WeatherModel weatherData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weatherData.cityName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          "${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][DateTime.now().weekday - 1]}, ${DateTime.now().day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][DateTime.now().month - 1]}",
          style: TextStyle(color: Colors.black.withOpacity(.5)),
        ),
      ],
    );
  }

  // Displays current weather overview
  Widget _buildWeatherOverview(WeatherModel weatherData) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF9aaff2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 92, color: Color(0xFFa6c2ea)),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Image.network(
            'https://openweathermap.org/img/wn/${weatherData.icon}.png',
            height: 120,
            width: 120,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 30,
          child: Text(
            weatherData.description,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Weather stats like wind speed, humidity, max temperature
  Widget _buildWeatherStats(WeatherModel weatherData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        WeatherCard(
          label: 'Wind Speed',
          value: '${weatherData.windSpeed.toStringAsFixed(1)} km/h',
          iconUrl: 'https://openweathermap.org/img/wn/01d.png', // Replace with actual wind speed icon if needed
        ),
        WeatherCard(
          label: 'Humidity',
          value: '${weatherData.humidity}%',
          iconUrl: 'https://openweathermap.org/img/wn/01d.png', // Replace with actual humidity icon if needed
        ),
        WeatherCard(
          label: 'Max Temp',
          value: '${weatherData.maxTemp.toStringAsFixed(1)}°C',
          iconUrl: 'https://openweathermap.org/img/wn/01d.png', // Replace with actual max temperature icon if needed
        ),
      ],
    );
  }

  // Displays the 5-day forecast
  Widget _buildForecast(List<WeatherModel> forecastData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Next Days Forecast", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecastData.length,
            itemBuilder: (context, index) {
              final data = forecastData[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/${data.icon}.png',
                      height: 40,
                      width: 40,
                    ),
                    Text(data.description, style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
                    Text('${data.temperature.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Custom WeatherCard widget for displaying weather stats
class WeatherCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconUrl;

  const WeatherCard({
    super.key,
    required this.label,
    required this.value,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(iconUrl, height: 30, width: 30),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
