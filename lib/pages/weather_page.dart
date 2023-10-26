import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('5a91b720f94a4bfe1a2b93d3f70462a1');
  Weather? _weather;
  Forecast? _forecast;
  List? forecast_data;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      final forecast = await _weatherService.getForecast(cityName);
      setState(() {
        _weather = weather;
        _forecast = forecast;
        forecast_data = _forecast?.getforecastlist();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  String getAnimation(String? mainCondition) {
    print(forecast_data);

    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/windy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  Icon getWeatherIcon(String weatherCondition) {
    IconData iconData;

    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        break;
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        iconData = Icons.cloud;
        break;
      case 'thunderstorm':
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        iconData = Icons.beach_access; // You can change this to a rain icon
        break;
      // Add more cases for other weather conditions as needed
      default:
        iconData = Icons.wb_sunny; // Default to an error icon
        break;
    }

    return Icon(
      iconData,
      size: 32,
    );
  }

  String getDate(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);

    String formattedDateTime = formatDate(dateTime);

    return formattedDateTime;
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM d, y, hh:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: 30,
                color: Colors.black54,
              ),
              Text(
                _weather?.cityName ?? "loading city...",
                style: TextStyle(fontSize: 30, color: Colors.black54),
              ),
              SizedBox(
                height: 40,
              ),
              Lottie.asset(getAnimation(_weather?.mainCondition)),
              SizedBox(
                height: 10,
              ),
              Text('${_weather?.temperature.round()} °C',
                  style: TextStyle(fontSize: 24, color: Colors.black54)),
              Text('${_weather?.mainCondition}',
                  style: TextStyle(fontSize: 24, color: Colors.black54)),
              Spacer(),
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: forecast_data?[0].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 260,
                          // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ListTile(
                            leading: getWeatherIcon(forecast_data?[2][
                                index]), // You can use an appropriate weather icon here
                            title: forecast_data?[1][index] != null
                                ? Text(
                                    "${forecast_data?[1][index].toString()} °C",
                                    style: TextStyle(fontSize: 20),
                                  )
                                : Text("Default"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                forecast_data?[2][index] != null
                                    ? Text(forecast_data?[2][index],
                                        style: TextStyle(fontSize: 16))
                                    : Text("Default"),
                                forecast_data?[3][index] != null
                                    ? Text(getDate(forecast_data?[3][index]),
                                        style: TextStyle(fontSize: 16))
                                    : Text("Default"),
                              ],
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
