import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(
  MaterialApp(
    title: "DITECTA",
    home: Home(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.green,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
    ),
  ),
);
