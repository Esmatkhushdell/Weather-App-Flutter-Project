import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String cityName = 'London';
  String temperature = '';
  String description = '';
  final String apiKey =
      '10b81b6b5d61c46e41f50ef8ebb62492'; // Replace with your actual API key

  Future<void> fetchWeather() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Weather data: $data'); // Debug print
        setState(() {
          temperature = data['main']['temp'].toString();
          description = data['weather'][0]['description'];
        });
      } else {
        print(
            'Failed to load weather data: ${response.statusCode}'); // Debug print
        setState(() {
          temperature = '';
          description = 'City not found';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      } // Debug print
      setState(() {
        temperature = '';
        description = 'Error fetching weather';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                cityName = value;
              },
              decoration: const InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchWeather,
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 20),
            if (temperature.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Temperature: $temperature °C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Description: $description',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            if (temperature.isEmpty && description.isNotEmpty)
              Text(
                description,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
