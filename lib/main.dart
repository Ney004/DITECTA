import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() => runApp(
  MaterialApp(
    title: "DITECTA",
    home: Home(),
    theme: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFFAFAF5),
        brightness: Brightness.light,
      ),
    ),
  ),
);
