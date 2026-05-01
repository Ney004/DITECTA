import 'package:flutter/material.dart';

class ScanModel {
  final int? id;
  String supabaseId; // ← nuevo
  final String title;
  final String date;
  final String timeAgo;
  final String severity;
  final String diseaseType;
  final String imagePath;
  final double confidence;
  final String sector;
  final DateTime scannedAt;

  ScanModel({
    this.id,
    this.supabaseId = '', // ← nuevo
    required this.title,
    required this.date,
    required this.timeAgo,
    required this.severity,
    required this.diseaseType,
    required this.imagePath,
    required this.confidence,
    required this.sector,
    required this.scannedAt,
  });

  Color get severityColor {
    switch (severity.toLowerCase()) {
      case 'saludable':
        return const Color(0xFF4CAF50);
      case 'leve':
        return const Color(0xFFFFEB3B);
      case 'moderada':
        return const Color(0xFFFF9800);
      case 'grave':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'date': date,
    'timeAgo': timeAgo,
    'severity': severity,
    'diseaseType': diseaseType,
    'imagePath': imagePath,
    'confidence': confidence,
    'sector': sector,
    'scannedAt': scannedAt.toIso8601String(),
  };

  factory ScanModel.fromMap(Map<dynamic, dynamic> map, int key) => ScanModel(
    id: key,
    supabaseId: map['supabaseId'] ?? '', // ← agrega esto
    title: map['title'] ?? '',
    date: map['date'] ?? '',
    timeAgo: map['timeAgo'] ?? '',
    severity: map['severity'] ?? '',
    diseaseType: map['diseaseType'] ?? '',
    imagePath: map['imagePath'] ?? '',
    confidence: (map['confidence'] ?? 0.0).toDouble(),
    sector: map['sector'] ?? '',
    scannedAt: DateTime.parse(
      map['scannedAt'] ?? DateTime.now().toIso8601String(),
    ),
  );
}
