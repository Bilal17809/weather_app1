import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/example/city/ctr/e_city_controller.dart';
import 'package:weather/example/home/sidebar/side_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/model/city_model.dart';
import '../../city/view/cityname.dart';
import '../../daily/controller/daily_controller.dart';
import '../../daily/screen/daily_screen.dart';
import '../../service/function/example.dart';
import '../../hourly/ctr/e_hourly_controler.dart';
import '../../hourly/view/E_hourly_screen.dart';
import '../../weather/controller/e_weather_controller.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String locationText = "Getting location...";
  String temperature = "--°C";
  String condition = "";
  String conditionIcon = "";

  final E_HourlyForecastController hourlyController = Get.put(E_HourlyForecastController());
final E_DailyForecastController dailyController=Get.put(E_DailyForecastController());
final E_CityController cityController=Get.put(E_CityController());
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final result = await WeatherService.getLocationAndWeather();

      if (result != null && result['lat'] != null && result['lng'] != null) {
        // ✅ Fetch hourly forecast for current location
        hourlyController.fetchHourlyForecast(
          result['lat'],
          result['lng'],
          isCurrentLocation: true,
        );

        // ✅ Fetch daily forecast for current location
        dailyController.fetchDailyForecast(
          result['lat'],
          result['lng'],
          isCurrentLocation: true,
        );

        setState(() {
          locationText = result['city'];
          temperature = result['temperature'];
          condition = result['condition'];
          conditionIcon = result['icon'];
        });

        // ✅ ADD THIS LINE HERE!
        dailyController.setCurrentCityName(result['city']);
      } else if (result != null && result['error'] != null) {
        setState(() {
          locationText = result['error'];
        });
      }
    });
  }

  String getCurrentTime() {
    return DateFormat('EEEE, d MMMM').format(DateTime.now());
  }
  Future<void> loadLocationWeather() async {
    final result = await WeatherService.getLocationAndWeather();

    if (result == null || result['error'] != null) {
      setState(() => locationText = result?['error'] ?? "Unknown error");
    } else {
      setState(() {
        locationText = result['city'];
        temperature = result['temperature'];
        condition = result['condition'];
        conditionIcon = result['icon'];
      });
      // dailyController.setCurrentCityName(result['city']);
      // ✅ Fetch hourly forecast for current location
      hourlyController.fetchHourlyForecast(result['lat'], result['lng']);

      // ✅ Fetch daily forecast for current location (FIXED)
      dailyController.fetchDailyForecast(
        result['lat'],
        result['lng'],
      );
    }
  }
  Future<void> fetchWeatherForCity(Malta city) async {
    final result = await WeatherService.fetchWeatherForCity(city);
    if (result == null || result['error'] != null) {
      setState(() => locationText = result?['error'] ?? "Unknown error");
    } else {
      setState(() {
        locationText = result['city'];
        temperature = result['temperature'];
        condition = result['condition'];
        conditionIcon = result['icon'];
      });
      dailyController.setCurrentCityName(result['city']);
      hourlyController.fetchHourlyForecast(city.lat, city.lng);
      dailyController.fetchDailyForecast(
        result['lat'],
        result['lng'],
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        backgroundColor: bgDark2,
        leading: Builder(
          builder: (ctx) => InkWell(
            onTap: () => Scaffold.of(ctx).openDrawer(),
            child: Icon(Icons.menu, color: kWhite, size: 28),
          ),
        ),
        title: Column(
          children: [
            Text(
              locationText,
              style: context.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kWhite,
              ),
            ),
            Text(
              getCurrentTime(),
              style: context.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                color: kWhite,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: kWhite),
            onPressed: () async {
              final selectedCity = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CitySelectionScreen()),
              );

              if (selectedCity != null && selectedCity is Malta) {
                // 1. Fetch weather
                fetchWeatherForCity(selectedCity);

                // 2. ✅ Update selected city in controller
                Get.find<SelectedDayWeatherController>().selectedCity.value = selectedCity;

                // 3. ✅ Fetch hourly forecast
                await Get.find<E_HourlyForecastController>().fetchHourlyForecast(
                  selectedCity.lat,
                  selectedCity.lng,
                );

                // 4. ✅ Fetch daily forecast
                await Get.find<E_DailyForecastController>().fetchDailyForecast(
                  selectedCity.lat,
                  selectedCity.lng,
                );

                print("✅ selectedCity updated: ${selectedCity.city}");
              }
            },
          ),


        ],
      ),
      body: Container(
        decoration: bgwithgradent,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8
            ),
            child: Column(
              children: [
                if (conditionIcon.isNotEmpty)
                  Image.network(
                    "https:$conditionIcon".replaceAll('64x64', '128x128'),
                    width: screenWidth * 0.5,
                    // height: screenhight * 0.5,
                    fit: BoxFit.contain,
                  ),
                Text(
                  condition,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 19,
                    color: kWhite,
                  ),
                ),
                Text(
                  temperature,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
                SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8),
                  child: Obx(() {
                    if (hourlyController.hourlyWeatherList.isEmpty) {
                      return const CircularProgressIndicator(color: Colors.white);
                    }
                    return E_HourlyCastWidget(hourlyData: hourlyController.hourlyWeatherList
                    ,removeBackground: false,);
                  }),
                ),
                SizedBox(height: 8,),
                // For selected city
                Obx(() {
                  final selectedCity = cityController.selectedCity.value;
                  return E_DailyForecastWidget(
                    dcontroller: dailyController,
                    isCurrentLocation: selectedCity == null,
                  );
                }),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
