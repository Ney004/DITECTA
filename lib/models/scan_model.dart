import 'package:flutter/material.dart';

class ScanModel {
  final String id;
  final String title;
  final String date;
  final String timeAgo;
  final String severity;
  final Color severityColor;
  final String imagePath;

  ScanModel({
    required this.id,
    required this.title,
    required this.date,
    required this.timeAgo,
    required this.severity,
    required this.severityColor,
    required this.imagePath,
  });
}
