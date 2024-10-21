class WeatherModel {
  final String cityName;
  final double temperature;
  final double maxTemp;
  final double windSpeed;
  final int humidity;
  final String description;
  final String icon;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.maxTemp,
    required this.windSpeed,
    required this.humidity,
    required this.description,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: json['main']['temp'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'].toInt(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
