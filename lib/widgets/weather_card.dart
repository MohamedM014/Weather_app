import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon; // Add this line

  const WeatherCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(icon, width: 40, height: 40), // Display the icon
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
