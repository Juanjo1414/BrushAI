// lib/mongo_service.dart
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static Db? _db;
  static DbCollection? _usersCollection;
  static bool _connected = false;

  static const String _mongoUri =
      "mongodb+srv://alsonotalexlol_db_user:KGjPzwScTTdmIgDq@cluster0.vitp91l.mongodb.net/brushy?retryWrites=true&w=majority&appName=Cluster0";

  /// Conectar a MongoDB (llamar antes de usar cualquier otro método)
  static Future<void> connect() async {
    // Reset del estado antes de intentar conectar
    _connected = false;
    _db = null;
    _usersCollection = null;

    try {
      debugPrint('[MongoService] Iniciando conexión...');
      _db = await Db.create(_mongoUri);

      debugPrint('[MongoService] Abriendo conexión...');
      await _db!.open();

      // Verificar que la conexión esté activa
      if (_db!.state != State.open) {
        throw Exception('Database connection failed - state: ${_db!.state}');
      }

      _usersCollection = _db!.collection('users');

      // Marcar como conectado ANTES de crear el índice
      _connected = true;
      debugPrint('[MongoService] Conexión establecida correctamente');

      // Crear índice único en email (opcional, puede fallar si ya existe)
      try {
        await _usersCollection!.createIndex(
          keys: {'email': 1},
          unique: true,
          name: 'email_unique_index',
        );
        debugPrint('[MongoService] Índice creado exitosamente');
      } catch (e) {
        debugPrint('[MongoService] Índice ya existe o error al crear: $e');
        // No es crítico si falla
      }

      debugPrint('[MongoService] ✅ Conectado a MongoDB exitosamente');
      debugStatus(); // Mostrar estado para debugging
    } catch (e, stackTrace) {
      debugPrint('[MongoService] ❌ Error al conectar: $e');
      debugPrint('[MongoService] StackTrace: $stackTrace');
      _connected = false;
      _db = null;
      _usersCollection = null;
      debugStatus(); // Mostrar estado de error
      rethrow; // Relanzar el error para que se maneje en main()
    }
  }

  /// Verificar si la conexión está activa
  static bool get isConnected =>
      _connected && _db != null && _db!.state == State.open;

  /// Devuelve la colección indicada (por defecto 'users').
  static DbCollection getCollection([String name = 'users']) {
    if (!isConnected) {
      throw StateError(
          'MongoService: not connected. Call MongoService.connect() first. Current state: connected=$_connected, db=${_db?.state}');
    }

    if (name == 'users' && _usersCollection != null) {
      return _usersCollection!;
    }
    return _db!.collection(name);
  }

  /// Buscar usuario por correo
  static Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    final col = getCollection('users');
    return await col.findOne({'email': email});
  }

  /// Insertar un usuario
  static Future<void> insertUser(Map<String, dynamic> user) async {
    final col = getCollection('users');
    await col.insertOne(user);
  }

  /// Obtener todos los usuarios
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final col = getCollection('users');
    final list = await col.find().toList();
    return List<Map<String, dynamic>>.from(list);
  }

  /// Cerrar conexión
  static Future<void> close() async {
    if (!_connected || _db == null) return;

    try {
      await _db!.close();
      debugPrint('[MongoService] Conexión cerrada correctamente');
    } catch (e) {
      debugPrint('[MongoService] Error al cerrar conexión: $e');
    } finally {
      _connected = false;
      _db = null;
      _usersCollection = null;
    }
  }

  /// Método para reconectar si la conexión se pierde
  static Future<void> ensureConnection() async {
    if (!isConnected) {
      debugPrint('[MongoService] Reconectando...');
      _connected = false; // Reset del estado
      await connect();
    }
  }

  /// Método de debugging para ver el estado actual
  static void debugStatus() {
    debugPrint('[MongoService DEBUG]');
    debugPrint('  _connected: $_connected');
    debugPrint('  _db: $_db');
    debugPrint('  _db?.state: ${_db?.state}');
    debugPrint('  _usersCollection: $_usersCollection');
    debugPrint('  isConnected: $isConnected');
  }
}
