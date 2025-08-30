import 'package:flutter/material.dart';
import '../../../shared/widgets/red_card_widget.dart';

class WeatherInfoSection extends StatelessWidget {
  final String temperature;
  final String weatherInfo;
  final VoidCallback? onWeatherTap;
  final VoidCallback? onDisasterInfoTap;

  const WeatherInfoSection({
    super.key,
    required this.temperature,
    required this.weatherInfo,
    this.onWeatherTap,
    this.onDisasterInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: RedCardWidget(
              title: temperature,
              subtitle: weatherInfo,
              onTap: onWeatherTap,
              height: 100,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RedCardWidget(
              title: 'Informasi\nBencana',
              onTap: onDisasterInfoTap,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
