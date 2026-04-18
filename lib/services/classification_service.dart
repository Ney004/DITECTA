// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ClassificationService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  // Singleton
  static final ClassificationService _instance =
      ClassificationService._internal();
  factory ClassificationService() => _instance;
  ClassificationService._internal();

  // Inicializar modelo
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Cargar modelo
      _interpreter = await Interpreter.fromAsset(
        'assets/model/modelo_ditecta.tflite',
      );

      // Cargar labels
      final labelsData = await rootBundle.loadString('assets/model/labels.txt');
      _labels = labelsData
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();

      _isInitialized = true;
      print('Modelo cargado correctamente');
      print('Clases: $_labels');
    } catch (e) {
      print('Error cargando modelo: $e');
      throw Exception('Error inicializando modelo: $e');
    }
  }

  // Clasificar imagen
  Future<ClassificationResult> classifyImage(String imagePath) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // 1. Leer imagen
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();

      // 2. Decodificar y redimensionar
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('No se pudo decodificar la imagen');
      }

      // Redimensionar a 224x224 (tamaño del modelo)
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // 3. Convertir a formato de entrada del modelo
      var input = _imageToByteListFloat32(resizedImage);

      // 4. Preparar salida
      var output = List.filled(
        _labels.length,
        0.0,
      ).reshape([1, _labels.length]);

      // 5. Ejecutar inferencia
      _interpreter!.run(input, output);

      // 6. Procesar resultados
      List<double> probabilities = List<double>.from(output[0]);

      // Obtener top 5
      List<PredictionScore> predictions = [];
      for (int i = 0; i < probabilities.length; i++) {
        predictions.add(
          PredictionScore(label: _labels[i], confidence: probabilities[i]),
        );
      }

      // Ordenar por confianza
      predictions.sort((a, b) => b.confidence.compareTo(a.confidence));

      return ClassificationResult(
        topPrediction: predictions[0],
        allPredictions: predictions.take(5).toList(),
      );
    } catch (e) {
      print('Error clasificando imagen: $e');
      throw Exception('Error en clasificación: $e');
    }
  }

  // Convertir imagen a tensor
  Uint8List _imageToByteListFloat32(img.Image image) {
    var convertedBytes = Float32List(1 * 224 * 224 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = image.getPixel(x, y);

        // Normalizar valores RGB a [0, 1]
        buffer[pixelIndex++] = pixel.r / 255.0;
        buffer[pixelIndex++] = pixel.g / 255.0;
        buffer[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return convertedBytes.buffer.asUint8List();
  }

  // Cerrar intérprete
  void dispose() {
    _interpreter?.close();
    _isInitialized = false;
  }
}

// Modelos de datos
class ClassificationResult {
  final PredictionScore topPrediction;
  final List<PredictionScore> allPredictions;

  ClassificationResult({
    required this.topPrediction,
    required this.allPredictions,
  });
}

class PredictionScore {
  final String label;
  final double confidence;

  PredictionScore({required this.label, required this.confidence});
}
