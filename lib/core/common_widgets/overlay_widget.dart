import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingOverlay(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (_) => Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
