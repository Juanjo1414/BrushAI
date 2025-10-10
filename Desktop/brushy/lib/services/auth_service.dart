import 'dart:convert';
import 'dart:math';
import '../mongo_service.dart';

class AuthService {
  static const collectionName = "users";

  String _randomSalt([int length = 16]) {
    final r = Random();
    final values = List<int>.generate(length, (_) => r.nextInt(256));
    return base64Encode(values);
  }

  String _hash(String salt, String password) {
    final combined = salt + password;
    int hash = 0;
    for (int i = 0; i < combined.length; i++) {
      hash = ((hash << 5) - hash + combined.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash.toString();
  }

  Future<String?> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      print(
        '[AuthService.register] Iniciando registro para: ${email.trim().toLowerCase()}',
      );

      MongoService.debugStatus();

      if (!MongoService.isConnected) {
        print(
          '[AuthService.register] No hay conexión, intentando reconectar...',
        );
        await MongoService.ensureConnection();
      }

      email = email.trim().toLowerCase();
      final col = MongoService.getCollection();
      print(
        '[AuthService.register] Obtenida colección, buscando usuario existente...',
      );

      final existing = await col.findOne({"email": email});
      if (existing != null) {
        print('[AuthService.register] Usuario ya existe: $email');
        return 'El correo ya está registrado.';
      }

      final salt = _randomSalt();
      final h = _hash(salt, password);

      print('[AuthService.register] Insertando nuevo usuario...');
      await col.insertOne({
        "email": email,
        "salt": salt,
        "hash": h,
        "displayName": displayName,
        "createdAt": DateTime.now().toIso8601String(),
      });

      print('[AuthService.register] ✅ Usuario registrado exitosamente: $email');
      return null; // success
    } catch (e, st) {
      print('[AuthService.register] ❌ Error: $e');
      print('[AuthService.register] StackTrace: $st');

      if (e.toString().contains('not connected')) {
        return 'Error de conexión a la base de datos. Inténtalo de nuevo.';
      }

      if (e.toString().contains('duplicate key') ||
          e.toString().contains('E11000')) {
        return 'El correo ya está registrado.';
      }

      return 'Error al registrar usuario. Verifica tu conexión.';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      print(
        '[AuthService.login] Iniciando login para: ${email.trim().toLowerCase()}',
      );

      MongoService.debugStatus();

      if (!MongoService.isConnected) {
        print('[AuthService.login] No hay conexión, intentando reconectar...');
        await MongoService.ensureConnection();
      }

      email = email.trim().toLowerCase();
      final col = MongoService.getCollection();
      print('[AuthService.login] Obtenida colección, buscando usuario...');

      final user = await col.findOne({"email": email});
      if (user == null) {
        print('[AuthService.login] Usuario no encontrado: $email');
        return 'Credenciales inválidas.';
      }

      final salt = user["salt"];
      final hash = user["hash"];

      if (_hash(salt, password) == hash) {
        print('[AuthService.login] ✅ Login exitoso: $email');
        return null; // success
      }

      print('[AuthService.login] Contraseña incorrecta para: $email');
      return 'Credenciales inválidas.';
    } catch (e, st) {
      print('[AuthService.login] ❌ Error: $e');
      print('[AuthService.login] StackTrace: $st');

      if (e.toString().contains('not connected')) {
        return 'Error de conexión a la base de datos. Inténtalo de nuevo.';
      }

      return 'Error al iniciar sesión. Verifica tu conexión.';
    }
  }

  // Método para generar token de reset
  Future<Map<String, dynamic>?> generateResetToken(String email) async {
    try {
      print(
        '[AuthService.generateResetToken] Generando token para: ${email.trim().toLowerCase()}',
      );

      if (!MongoService.isConnected) {
        await MongoService.ensureConnection();
      }

      email = email.trim().toLowerCase();
      final col = MongoService.getCollection();

      // Verificar si el usuario existe
      final user = await col.findOne({"email": email});
      if (user == null) {
        return {
          "error": "No se encontró una cuenta con ese correo electrónico.",
        };
      }

      // Generar token de reset (6 dígitos)
      final resetToken = _generateResetToken();
      final tokenExpiry = DateTime.now().add(
        Duration(minutes: 15),
      ); // 15 minutos de validez

      // Guardar token en la base de datos
      await col.updateOne(
        {"email": email},
        {
          "\$set": {
            "resetToken": resetToken,
            "resetTokenExpiry": tokenExpiry.toIso8601String(),
            "resetDate": DateTime.now().toIso8601String(),
          },
        },
      );

      print('[AuthService.generateResetToken] ✅ Token generado: $resetToken');
      return {"token": resetToken, "expiry": tokenExpiry};
    } catch (e, st) {
      print('[AuthService.generateResetToken] ❌ Error: $e');
      print('[AuthService.generateResetToken] StackTrace: $st');
      return {"error": "Error al generar token de reset."};
    }
  }

  /// Método simplificado para enviar token de reset
  Future<String?> sendResetToken(String email) async {
    final result = await generateResetToken(email);

    if (result == null) {
      return 'Error al generar token de reset.';
    }

    if (result.containsKey('error')) {
      return result['error'];
    }

    final token = result['token'];
    print(
      'Token enviado a $email: $token',
    ); // En producción, aquí enviarías el email

    return null; // Sin error
  }

  // Método para verificar token y cambiar contraseña
  Future<String?> resetPasswordWithToken(
    String email,
    String token,
    String newPassword,
  ) async {
    try {
      print(
        '[AuthService.resetPasswordWithToken] Verificando token para: ${email.trim().toLowerCase()}',
      );

      if (!MongoService.isConnected) {
        await MongoService.ensureConnection();
      }

      email = email.trim().toLowerCase();
      final col = MongoService.getCollection();

      // Buscar usuario con token válido
      final user = await col.findOne({"email": email, "resetToken": token});

      if (user == null) {
        return 'Token inválido o expirado.';
      }

      // Verificar expiración del token
      final expiryStr = user["resetTokenExpiry"];
      if (expiryStr != null) {
        final expiry = DateTime.parse(expiryStr);
        if (DateTime.now().isAfter(expiry)) {
          return 'El token ha expirado. Solicita uno nuevo.';
        }
      }

      // Validar nueva contraseña
      if (newPassword.length < 8) {
        return 'La nueva contraseña debe tener al menos 8 caracteres.';
      }

      // Generar hash para nueva contraseña
      final newSalt = _randomSalt();
      final newHash = _hash(newSalt, newPassword);

      // Actualizar contraseña y limpiar token
      await col.updateOne(
        {"email": email},
        {
          "\$set": {
            "salt": newSalt,
            "hash": newHash,
            "passwordChangedAt": DateTime.now().toIso8601String(),
          },
          "\$unset": {
            "resetToken": "",
            "resetTokenExpiry": "",
            "tempPassword": "",
          },
        },
      );

      print(
        '[AuthService.resetPasswordWithToken] ✅ Contraseña actualizada para: $email',
      );
      return null; // Éxito
    } catch (e, st) {
      print('[AuthService.resetPasswordWithToken] ❌ Error: $e');
      print('[AuthService.resetPasswordWithToken] StackTrace: $st');
      return 'Error al cambiar la contraseña.';
    }
  }

  String _generateResetToken() {
    final r = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => r.nextInt(10) + 48), // Números del 0-9
    );
  }

  /// Verifica si el usuario está autenticado
  Future<bool> isLoggedIn() async {
    try {
      // En una implementación real, aquí verificarías un token de sesión almacenado
      // Por ahora, retornamos false para forzar al usuario a hacer login
      return false;
    } catch (e) {
      print('Error al verificar estado de login: $e');
      return false;
    }
  }
}
