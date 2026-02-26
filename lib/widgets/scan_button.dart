import 'package:flutter/material.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón circular
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 6),
              ),
              padding: const EdgeInsets.all(70),
              backgroundColor: const Color(0xFF4CAF50),
              shadowColor: Colors.greenAccent,
              elevation: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt, color: Colors.white, size: 80),
                SizedBox(height: 10),
                Text(
                  "EMPEZAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Texto descriptivo
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "Apunta la cámara hacia las hojas para una detección instantánea",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
