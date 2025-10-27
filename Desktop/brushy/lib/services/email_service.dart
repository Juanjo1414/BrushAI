import 'dart:convert';
import 'package:http/http.dart' as http;
import 'email_config.dart';

/// Servicio simple para enviar correos usando EmailJS.
class EmailService {
  static const _endpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Envía un correo con el token de restablecimiento de contraseña.
  /// Retorna null en caso de éxito; en caso de error, retorna un mensaje de error.
  static Future<String?> sendResetTokenEmail({
    required String toEmail,
    required String token,
  }) async {
    try {
      // Validar configuración: asegurar que no queden placeholders
      if (EmailConfig.serviceId.isEmpty ||
          EmailConfig.templateId.isEmpty ||
          EmailConfig.publicKey.isEmpty ||
          EmailConfig.serviceId.startsWith('REEMPLAZA') ||
          EmailConfig.templateId.startsWith('REEMPLAZA') ||
          EmailConfig.publicKey.startsWith('REEMPLAZA')) {
        return 'Configura EmailJS en email_config.dart antes de enviar correos.';
      }

      final payload = {
        'service_id': EmailConfig.serviceId,
        'template_id': EmailConfig.templateId,
        'user_id':
            EmailConfig.publicKey, // EmailJS usa user_id para la public key
        'template_params': {
          'to_email': toEmail,
          // Compat extra: algunas plantillas usan user_email o to
          'user_email': toEmail,
          'to': toEmail,
          // Tu plantilla usa {{email}} en el campo To
          'email': toEmail,
          // Tu plantilla muestra {{passcode}} en el cuerpo
          'passcode': token,
          // También dejamos 'token' por compatibilidad con otras plantillas
          'token': token,
          // Valor para {{time}} si lo usas en la plantilla
          'time': '${EmailConfig.tokenValidityMinutes} min',
          'app_name': EmailConfig.appName,
        }
      };

      final headers = {
        'Content-Type': 'application/json',
        // Origin requerido por EmailJS; debe coincidir con un dominio autorizado en tu cuenta
        'origin': EmailConfig.origin,
      };

      final res = await http.post(
        Uri.parse(_endpoint),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return null; // éxito
      }

      return 'Fallo al enviar correo (${res.statusCode}): ${res.body}';
    } catch (e) {
      return 'Error enviando correo: $e';
    }
  }
}
