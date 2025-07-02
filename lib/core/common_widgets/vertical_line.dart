import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 46,
      color:dividerColor,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}