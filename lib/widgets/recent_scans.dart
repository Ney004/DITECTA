import 'package:flutter/material.dart';
import '../models/scan_model.dart';

class RecentScans extends StatelessWidget {
  final List<ScanModel> scans;
  final VoidCallback? onViewAll; // ← NUEVO parámetro

  const RecentScans({
    super.key,
    required this.scans,
    this.onViewAll, // ← OPCIONAL
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Escaneos Recientes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF323846),
              ),
            ),
            GestureDetector(
              // ← Hacer clickeable
              onTap: onViewAll,
              child: Text(
                "Ver Todos",
                style: TextStyle(
                  color: Color(0xFF8FBC26),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // LISTA VERTICAL
        ...scans.map(
          (scan) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ScanCard(scan: scan),
          ),
        ),
      ],
    );
  }
}

class _ScanCard extends StatelessWidget {
  final ScanModel scan;

  const _ScanCard({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey[200],
              child: scan.imagePath.isNotEmpty
                  ? Image.asset(scan.imagePath, fit: BoxFit.cover)
                  : Icon(Icons.eco, color: Colors.green[700], size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF323846),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: scan.severityColor),
                    const SizedBox(width: 6),
                    Text(
                      scan.severity,
                      style: TextStyle(
                        fontSize: 13,
                        color: scan.severityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            scan.timeAgo,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        ],
      ),
    );
  }
}
