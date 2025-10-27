import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../ml/teeth_classifier.dart';

class MlPage extends StatefulWidget {
  const MlPage({super.key});

  @override
  State<MlPage> createState() => _MlPageState();
}

class _MlPageState extends State<MlPage> {
  final _picker = ImagePicker();
  final _clf = TeethClassifier();

  File? _image;
  String? _result;
  double? _conf;
  bool _busy = false;
  String _status = 'Cargando modelo…';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 1) Self-check del asset en el bundle
    try {
      await rootBundle.load(TeethClassifier.assetKey);
      if (!mounted) return;
      setState(() => _status = 'Asset OK ✅');
    } catch (e) {
      if (!mounted) return;
      setState(() => _status =
          'Asset no encontrado: ${TeethClassifier.assetKey}. Error: $e');
      return; // No intentamos cargar el intérprete si falta el asset
    }

    // 2) Cargar el modelo
    try {
      await _clf.load();
      if (!mounted) return;
      setState(() => _status = 'Modelo listo ✅');
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Error cargando modelo: $e');
    }
  }

  Future<void> _pick(ImageSource src) async {
    try {
      final x = await _picker.pickImage(source: src, imageQuality: 95);
      if (x == null) return;
      setState(() {
        _image = File(x.path);
        _result = null;
        _conf = null;
      });
      await _run();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _run() async {
    if (_image == null || !_clf.isLoaded) return;
    setState(() => _busy = true);
    try {
      final r = await _clf.classify(_image!);
      setState(() {
        _result = r['label'] as String;
        _conf = (r['confidence'] as double);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al predecir: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _clf.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clasificador de dientes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.memory, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(_status)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: _image == null
                    ? const Text('Toma o selecciona una imagen…')
                    : Image.file(_image!, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 12),
            if (_busy) const LinearProgressIndicator(),
            if (_result != null)
              Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(
                    'Resultado: $_result',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Confianza: ${(_conf! * 100).toStringAsFixed(1)}%',
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Cámara'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
