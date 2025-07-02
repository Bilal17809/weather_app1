import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final int length;
  final ValueChanged<String> onChanged;

  const OtpInput({
    super.key,
    this.length = 4,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 50,
          child: TextFormField(
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty) {
                FocusScope.of(context).previousFocus();
              }
              onChanged(value);
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(counterText: ''),
          ),
        );
      }),
    );
  }
}