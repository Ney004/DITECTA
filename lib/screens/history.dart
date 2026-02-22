import 'package:flutter/material.dart';
import '../models/scan_model.dart';
import '../data/scan_data.dart';
import 'profile.dart';
import 'home.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String selectedFilter = 'Todos';
  String searchQuery = '';

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Saludable':
        return Colors.green;
      case 'Medio':
        return Colors.amber;
      case 'Moderada':
        return Colors.orange;
      case 'Grave':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Método para filtrar los escaneos
  List<ScanModel> _getFilteredScans() {
    List<ScanModel> scans = ScanData.getAllScans();

    // Filtrar por búsqueda
    if (searchQuery.isNotEmpty) {
      scans = scans.where((scan) {
        return scan.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Filtrar por severidad
    if (selectedFilter != 'Todos') {
      scans = scans.where((scan) {
        return scan.severity == selectedFilter;
      }).toList();
    }

    return scans;
  }

  @override
  Widget build(BuildContext context) {
    final filteredScans = _getFilteredScans();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        title: const Text(
          "Historial de Escaneos",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Buscar por nombre",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.green[600]),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: "Todos",
                    isSelected: selectedFilter == 'Todos',
                    selectedColor: _getFilterColor('Todos'),
                    onTap: () => setState(() => selectedFilter = 'Todos'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: "Saludable",
                    isSelected: selectedFilter == 'Saludable',
                    selectedColor: _getFilterColor('Saludable'),
                    onTap: () => setState(() => selectedFilter = 'Saludable'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: "Medio",
                    isSelected: selectedFilter == 'Medio',
                    selectedColor: _getFilterColor('Medio'),
                    onTap: () => setState(() => selectedFilter = 'Medio'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: "Moderada",
                    isSelected: selectedFilter == 'Moderada',
                    selectedColor: _getFilterColor('Moderada'),
                    onTap: () => setState(() => selectedFilter = 'Moderada'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: "Grave",
                    isSelected: selectedFilter == 'Grave',
                    selectedColor: _getFilterColor('Grave'),
                    onTap: () => setState(() => selectedFilter = 'Grave'),
                  ),
                ],
              ),
            ),
          ),

          // HISTORY LIST
          Expanded(
            child: filteredScans.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No se encontraron resultados",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Intenta con otra búsqueda o filtro",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredScans.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      return _HistoryCard(item: filteredScans[index]);
                    },
                  ),
          ),
        ],
      ),

      // BARRA DE NAVEGACIÓN INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF416C18),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Profile()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cuenta"),
        ],
      ),
    );
  }
}

// FILTER CHIP WIDGET
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey[300]!,
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
  final ScanModel item;

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
                      "Ver Detalles",
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
