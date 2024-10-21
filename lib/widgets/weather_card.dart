import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String label;
  final String value;

  const WeatherCard({super.key, required this.label, required this.value, required String icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
