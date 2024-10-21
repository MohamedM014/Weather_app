class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final double windSpeed;
  final int humidity;
  final double maxTemp;
  final String icon;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.maxTemp,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'] - 273.15, // تحويل من كيلفن إلى سلزيوس
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'],
      humidity: json['main']['humidity'],
      maxTemp: json['main']['temp_max'] - 273.15, // تحويل من كيلفن إلى سلزيوس
      icon: json['weather'][0]['icon'],
    );
  }
}
