import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Clasificador binario "limpio/sucio" exportado desde tu notebook.
/// Entrenaste MobileNetV2 224x224 con salida sigmoid (1 neurona).
class TeethClassifier {
  // Clave pública del asset para comprobaciones externas
  static const assetKey = 'assets/ml/teeth_classifier.tflite';
  static const _assetPath = assetKey;
  static const _inputSize = 224;

  Interpreter? _interpreter;
  bool get isLoaded => _interpreter != null;

  Future<void> load() async {
    if (_interpreter != null) return;
    dynamic lastError;
    // Intentos progresivos con diferentes opciones/delegados
    final attempts = <Future<Interpreter> Function()>[
      () async => Interpreter.fromAsset(_assetPath),
      () async => Interpreter.fromAsset(_assetPath,
          options: InterpreterOptions()..threads = 1),
    ];
    for (final loader in attempts) {
      try {
        _interpreter = await loader();
        break;
      } catch (e) {
        lastError = e;
      }
    }
    if (_interpreter == null) {
      throw ArgumentError(
          'Unable to create interpreter. Last error: $lastError');
    }
  }

  /// Clasifica un archivo de imagen. Devuelve un Map con etiqueta y confianza.
  Future<Map<String, dynamic>> classify(File file) async {
    if (_interpreter == null) {
      throw StateError('TeethClassifier no cargado. Llama primero a load().');
    }

    // Decodificar con package:image (sin dependencias de UI)
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('No se pudo decodificar la imagen');
    }

    // Convertir a float32 1x224x224x3 normalizado a 0..1
    final resized =
        img.copyResize(decoded, width: _inputSize, height: _inputSize);
    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (_) => List.generate(
          _inputSize,
          (_) => List<double>.filled(3, 0.0, growable: false),
          growable: false,
        ),
        growable: false,
      ),
      growable: false,
    );
    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        final p = resized.getPixel(x, y);
        input[0][y][x][0] = img.getRed(p) / 255.0;
        input[0][y][x][1] = img.getGreen(p) / 255.0;
        input[0][y][x][2] = img.getBlue(p) / 255.0;
      }
    }

    // Ejecutar inferencia
    final outputTensor = List.generate(1, (_) => List.filled(1, 0.0));
    _interpreter!.run(input, outputTensor);

    // pred = sigmoid -> 0..1 (umbral 0.5)
    final double pred = outputTensor[0][0];
    final bool isDirty = pred >= 0.5;
    final label = isDirty ? '😬 Sucio' : '🦷 Limpio';
    final conf = isDirty ? pred : (1.0 - pred);

    return {'label': label, 'confidence': conf};
  }

  Future<void> close() async {
    _interpreter?.close();
    _interpreter = null;
  }
}
