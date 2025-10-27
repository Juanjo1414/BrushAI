/// Configuración de EmailJS.
/// REEMPLAZA estos valores con los de tu cuenta de EmailJS.
///
/// 1) Crea cuenta en https://www.emailjs.com/
/// 2) Crea un servicio (service_id)
/// 3) Crea una plantilla (template_id) con variables por ejemplo: to_email, token, app_name
/// 4) Copia tu public key (user_id / public key)
///
/// Nota: Estos valores no deben considerarse secretos fuertes, pero evita subir claves privadas.
class EmailConfig {
  static const serviceId = 'service_i30mqe6';
  static const templateId = 'template_2n3eo6p';
  static const publicKey = 'BijdOIApnIC6VzQv6';
  // Remitente opcional para tu plantilla
  static const appName = 'Brushy IA';
  // Origin permitido en EmailJS (añádelo en tu dashboard de EmailJS > Domains & Emails)
  // Para desarrollo en emulador/web, suele bastar 'http://localhost'
  static const origin = 'http://localhost';
  // Minutos de validez del código de restablecimiento
  static const tokenValidityMinutes = 15;
}
