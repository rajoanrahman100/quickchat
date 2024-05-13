import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  navigateToScreen({bool isReplaced = false, required Widget child}) {
    if (isReplaced) {
      Navigator.pushReplacement(this, MaterialPageRoute(builder: (context) => child));
    } else {
      Navigator.push(this, MaterialPageRoute(builder: (context) => child));
    }
  }

  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
