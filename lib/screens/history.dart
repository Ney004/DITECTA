import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String selectedFilter = 'All';

  final List<HistoryItem> historyItems = [
    HistoryItem(
      title: "Black Sigatoka",
      date: "Oct 24, 2025 • 10:30 AM",
      severity: "MODERATE",
      severityColor: Colors.orange,
      imagePath: "",
    ),
    HistoryItem(
      title: "No Diseases Detected",
      date: "Oct 22, 2025 • 04:15 PM",
      severity: "HEALTHY",
      severityColor: Colors.green,
      imagePath: "",
    ),
    HistoryItem(
      title: "Fusarium Wilt",
      date: "Oct 20, 2025 • 09:45 AM",
      severity: "SEVERE",
      severityColor: Colors.red,
      imagePath: "",
    ),
    HistoryItem(
      title: "Yellow Sigatoka",
      date: "Oct 18, 2025 • 11:20 AM",
      severity: "MILD",
      severityColor: Colors.amber,
      imagePath: "",
    ),
    HistoryItem(
      title: "Banana Speckle",
      date: "Oct 15, 2025 • 02:30 PM",
      severity: "MODERATE",
      severityColor: Colors.orange,
      imagePath: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Scan History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by date or disease...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.green[600]),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // FILTERS
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: "All",
                  isSelected: selectedFilter == 'All',
                  onTap: () => setState(() => selectedFilter = 'All'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "Healthy",
                  isSelected: selectedFilter == 'Healthy',
                  onTap: () => setState(() => selectedFilter = 'Healthy'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "Mild",
                  isSelected: selectedFilter == 'Mild',
                  onTap: () => setState(() => selectedFilter = 'Mild'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "Moderate",
                  isSelected: selectedFilter == 'Moderate',
                  onTap: () => setState(() => selectedFilter = 'Moderate'),
                ),
              ],
            ),
          ),

          // HISTORY LIST
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: historyItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return _HistoryCard(item: historyItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// FILTER CHIP WIDGET
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// HISTORY CARD WIDGET
class _HistoryCard extends StatelessWidget {
  final HistoryItem item;

  const _HistoryCard({required this.item});

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
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: item.imagePath.isNotEmpty
                  ? Image.asset(item.imagePath, fit: BoxFit.cover)
                  : Icon(Icons.eco, color: Colors.green[700], size: 32),
            ),
          ),
          const SizedBox(width: 12),

          // TEXTO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF323846),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.severityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.severity,
                        style: TextStyle(
                          color: item.severityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.date,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "View full report",
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Colors.green[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// HISTORY ITEM MODEL
class HistoryItem {
  final String title;
  final String date;
  final String severity;
  final Color severityColor;
  final String imagePath;

  HistoryItem({
    required this.title,
    required this.date,
    required this.severity,
    required this.severityColor,
    required this.imagePath,
  });
}
