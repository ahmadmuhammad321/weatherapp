class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main']);
  }
}

class Forecast {
  final List Forecast_Data;
  // List Forecast_List = [];

  Forecast({
    required this.Forecast_Data,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    // print("Model:" + json['list'].toString());
    List data = [[], [], [], []];
    List<dynamic> dataList = json['list'];

    for (int i = 0; i < dataList.length; i++) {
      data[0].add(dataList[i]['dt'].toString());
      data[1].add(
          dataList[i]['main']['temp'].toString().replaceRange(2, null, ""));
      data[2].add(dataList[i]['weather'][0]['main'].toString());
      data[3].add(dataList[i]['dt_txt'].toString());
    }

    return Forecast(Forecast_Data: data);
  }
  List getforecastlist() {
    return Forecast_Data;
  }
}
