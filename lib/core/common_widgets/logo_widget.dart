import 'package:ad_english_dictionary/extension/extension.dart';
import 'package:flutter/material.dart';


class LogoWidget extends StatelessWidget {
  final String title;
  const LogoWidget({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,style: context.textTheme.titleLarge,);
  }
}
