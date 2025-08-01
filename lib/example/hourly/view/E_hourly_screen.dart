import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../model/e_houry_model.dart';

/// Checks if a given forecast time matches the current hour
bool isCurrentHour(String itemTime) {
  final now = DateTime.now();
  final currentHour = now.hour;

  try {
    // Convert "8 PM" → "8:00 PM" for safety
    if (RegExp(r'^\d{1,2} (AM|PM)$').hasMatch(itemTime)) {
      itemTime = itemTime.replaceFirstMapped(
        RegExp(r'^(\d{1,2}) (AM|PM)$'),
            (match) => "${match[1]}:00 ${match[2]}",
      );
    }

    // Parse time safely
    final parsedHour = DateFormat('h:mm a').parse(itemTime).hour;
    return parsedHour == currentHour;
  } catch (e) {
    print("❌ Could not parse itemTime: $itemTime");
    return false;
  }
}

/// Hourly weather forecast card widget
class HourlyCastCard extends StatelessWidget {
  final String time;
  final String temperature;
  final String iconUrl;
  final bool isNow;
  final bool removeBackground;

  const HourlyCastCard({
    Key? key,
    required this.time,
    required this.temperature,
    required this.iconUrl,
    this.isNow = false,
    this.removeBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: 65,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: isNow ? Border.all(color: Colors.white, width: 2) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            iconUrl.replaceAll('64x64', '128x128'),
            width: screenWidth * 0.15,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
          const SizedBox(height: 4),
          Text(
            isNow ? 'Now' : time,
            style: TextStyle(
              color: kWhite,
              fontSize: screenWidth * 0.040,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            temperature,
            style: TextStyle(
              color: kWhite,
              fontSize: screenWidth * 0.040,
            ),
          ),
        ],
      ),
    );
  }
}

/// Main hourly forecast horizontal scroll widget
class E_HourlyCastWidget extends StatefulWidget {
  final List<E_HourlyWeather> hourlyData;
  final bool removeBackground;

  const E_HourlyCastWidget({
    super.key,
    required this.hourlyData,
    this.removeBackground = false,
  });

  @override
  State<E_HourlyCastWidget> createState() => _E_HourlyCastWidgetState();
}

class _E_HourlyCastWidgetState extends State<E_HourlyCastWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = widget.hourlyData.indexWhere(
            (item) => isCurrentHour(item.time),
      );

      if (index != -1) {
        final screenWidth = MediaQuery.of(context).size.width;
        const itemWidth = 73.0; // 65 (width) + 8 (horizontal margin)
        final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              offset.clamp(0.0, _scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.19,
      decoration: widget.removeBackground ? null : roundedDecorationWithShadow,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.hourlyData.length,
        itemBuilder: (context, index) {
          final item = widget.hourlyData[index];
          final isNow = isCurrentHour(item.time);

          return HourlyCastCard(
            time: item.time,
            temperature: item.temperature,
            iconUrl: item.iconUrl,
            isNow: isNow,
            removeBackground: widget.removeBackground,
          );
        },
      ),
    );
  }
}
