import 'package:flutter/material.dart';
import '../models/scan_model.dart';

class ScanData {
  static final List<ScanModel> allScans = [
    ScanModel(
      id: "1",
      title: "Scaneo #1",
      date: "Oct 24, 2025 • 10:30 AM",
      timeAgo: "Hace 2 horas",
      severity: "Saludable",
      severityColor: Colors.green,
      imagePath: "",
    ),
    ScanModel(
      id: "2",
      title: "Scaneo #2",
      date: "Oct 22, 2025 • 04:15 PM",
      timeAgo: "Hace 5 horas",
      severity: "Moderada",
      severityColor: Colors.orange,
      imagePath: "",
    ),
    ScanModel(
      id: "3",
      title: "Scaneo #3",
      date: "Oct 20, 2025 • 09:45 AM",
      timeAgo: "Ayer",
      severity: "Grave",
      severityColor: Colors.red,
      imagePath: "",
    ),
    ScanModel(
      id: "4",
      title: "Scaneo #4",
      date: "Oct 18, 2025 • 11:20 AM",
      timeAgo: "Hace 3 días",
      severity: "Medio",
      severityColor: Colors.amber,
      imagePath: "",
    ),
    ScanModel(
      id: "5",
      title: "Scaneo #5",
      date: "Oct 15, 2025 • 02:30 PM",
      timeAgo: "Hace 1 semana",
      severity: "Moderada",
      severityColor: Colors.orange,
      imagePath: "",
    ),
  ];

  // Obtener solo los 3 más recientes
  static List<ScanModel> getRecentScans() {
    return allScans.take(3).toList();
  }

  // Obtener todos los escaneos
  static List<ScanModel> getAllScans() {
    return allScans;
  }
}
