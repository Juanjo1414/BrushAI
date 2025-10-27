// lib/services/ml_service.dart
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// Servicio para cargar el TFLite y ejecutar inferencias sin usar helper.
/// Modelo: MobileNetV2 fine-tuned binario (limpio/sucio)
class BrushAiClassifier {
  // Debe coincidir con la ruta declarada en pubspec.yaml (flutter -> assets)
  static const _assetPath = 'assets/ml/teeth_classifier.tflite';
  static const _inputSize = 224;

  late Interpreter _interpreter;
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> load() async {
    dynamic lastError;
    for (final loader in <Future<Interpreter> Function()>[
      () async => Interpreter.fromAsset(_assetPath),
      () async => Interpreter.fromAsset(
            _assetPath,
            options: InterpreterOptions()..threads = 1,
          ),
    ]) {
      try {
        _interpreter = await loader();
        _loaded = true;
        return;
      } catch (e) {
        lastError = e;
      }
    }
    throw ArgumentError('Unable to create interpreter. Last error: $lastError');
  }

  /// Preprocesa imagen: resize 224x224 y normaliza a [0,1]
  List<List<List<List<double>>>> _preprocess(img.Image image) {
    final resized =
        img.copyResize(image, width: _inputSize, height: _inputSize);
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
        final pixel = resized.getPixel(x, y);
        final r = img.getRed(pixel) / 255.0;
        final g = img.getGreen(pixel) / 255.0;
        final b = img.getBlue(pixel) / 255.0;
        input[0][y][x][0] = r;
        input[0][y][x][1] = g;
        input[0][y][x][2] = b;
      }
    }
    return input;
  }

  /// Ejecuta predicción y devuelve etiqueta legible
  /// pred < 0.5 => Limpio ; pred >= 0.5 => Sucio
  Future<String> predict(img.Image image) async {
    if (!_loaded) {
      await load();
    }

    final input = _preprocess(image);
    final output =
        List<List<double>>.generate(1, (_) => List<double>.filled(1, 0.0));

    _interpreter.run(input, output);

    final pred = output[0][0]; // 0..1
    return pred < 0.5 ? "🦷 Limpio" : "😬 Sucio";
  }

  void close() {
    if (_loaded) {
      _interpreter.close();
      _loaded = false;
    }
  }
}
