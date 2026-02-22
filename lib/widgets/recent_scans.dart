import 'package:flutter/material.dart';

class RecentScans extends StatelessWidget {
  final List<ScanItem> scans;

  const RecentScans({super.key, required this.scans});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Scans",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF323846),
              ),
            ),
            Text(
              "VIEW ALL",
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // LISTA VERTICAL SIN SCROLL PROPIO
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

class ScanItem {
  final String title;
  final String timeAgo;
  final String status;
  final Color statusColor;
  final String imagePath;

  ScanItem({
    required this.title,
    required this.timeAgo,
    required this.status,
    required this.statusColor,
    required this.imagePath,
  });
}

class _ScanCard extends StatelessWidget {
  final ScanItem scan;

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
          // IMAGEN
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey[200],
              child: scan.imagePath.isNotEmpty
                  ? Image.asset(
                      scan.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Icon(Icons.image, color: Colors.grey[400]),
                    )
                  : Icon(Icons.eco, color: Colors.green[700], size: 28),
            ),
          ),
          const SizedBox(width: 12),

          // TEXTO
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
                    Icon(Icons.circle, size: 8, color: scan.statusColor),
                    const SizedBox(width: 6),
                    Text(
                      scan.status,
                      style: TextStyle(
                        fontSize: 13,
                        color: scan.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // FECHA
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
