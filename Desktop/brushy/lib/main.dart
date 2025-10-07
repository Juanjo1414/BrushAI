// Brushy - main.dart
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '/mongo_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/shell/home_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MongoService.connect();
  } catch (e, st) {
    print('[MongoService] Error al conectar: $e');
    print(st);
  }
  runApp(BrushyApp());
}

class BrushyApp extends StatelessWidget {
  const BrushyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brush IA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF7FBFF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglés
        Locale('es', 'ES'), // Español
      ],
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        // 'home': (context) => HomeShell(email: ''), // Este no se usa directamente
      },
    );
  }
}

// Simple splash to show branding and animate into login
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400),
    );
    _ctrl.forward();
    Future.delayed(Duration(milliseconds: 1400), () async {
      if (!mounted) return;
      {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrushyLogo(size: 120),
              SizedBox(height: 20),
              Text(
                'Brush IA',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '¡Cepillarse nunca fue tan divertido!',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrushyLogo extends StatelessWidget {
  final double size;
  const BrushyLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7EE8FA), Color(0xFF80FFDB)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.medical_services,
          size: size * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ----------------- Auth Service con MongoDB -----------------
// AuthService con mejor debugging
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

      // Verificar estado antes de proceder
      MongoService.debugStatus();

      // Verificar conexión antes de proceder
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

      // Mensajes más específicos según el tipo de error
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

      // Verificar estado antes de proceder
      MongoService.debugStatus();

      // Verificar conexión antes de proceder
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
}

// ----------------- Login Page -----------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  final AuthService _auth = AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final err = await _auth.login(_emailCtrl.text, _passCtrl.text);

    setState(() => _loading = false);

    if (err != null) {
      _showError(err);
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeShell(email: _emailCtrl.text)),
        );
      }
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  BrushyLogo(size: 64),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Brush IA',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Inicia sesión',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Ingresa tu correo.';
                          if (!RegExp(
                            r"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                          ).hasMatch(v))
                            return 'Correo inválido.';
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Ingresa tu contraseña.';
                          if (v.length < 8)
                            return 'La contraseña debe tener al menos 8 caracteres.';
                          return null;
                        },
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text('Entrar', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RegisterPage()),
                        ),
                        child: Text(
                          '¿No tienes cuenta? Regístrate',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: mq.height * 0.1),
              Center(
                child: Text(
                  'Hecho con ❤️ para apoyar los hábitos de cepillado',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- Register Page -----------------

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();

  bool _loading = false;
  bool _acceptedTerms = false;
  DateTime? _selectedBirthDate;
  final AuthService _auth = AuthService();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  void _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        Duration(days: 365 * 10),
      ), // 10 años atrás por defecto
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('es', 'ES'),
      helpText: 'Selecciona la fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  bool _isAgeValid(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;

    // Si aún no ha cumplido años este año
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return age - 1 >= 6;
    }

    return age >= 6;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes aceptar los términos y condiciones')),
      );
      return;
    }

    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona una fecha de nacimiento')),
      );
      return;
    }

    if (!_isAgeValid(_selectedBirthDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Edad mínima no permitida. Debes tener al menos 6 años.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final err = await _auth.register(
        _emailCtrl.text,
        _passCtrl.text,
        _nameCtrl.text,
      );
      if (err != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err)));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '¡Cuenta creada exitosamente! Ya puedes iniciar sesión.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('[RegisterPage] Error inesperado: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado al registrar.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _passwordQuality(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa una contraseña.';
    if (v.length < 8) return 'Mínimo 8 caracteres.';
    if (!RegExp(r'[A-Z]').hasMatch(v))
      return 'Incluye al menos una letra mayúscula.';
    if (!RegExp(r'[a-z]').hasMatch(v))
      return 'Incluye al menos una letra minúscula.';
    if (!RegExp(r'\d').hasMatch(v)) return 'Incluye al menos un número.';
    return null;
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y Condiciones'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Términos de Uso de Brush IA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  '1. Uso de la aplicación para fines educativos sobre higiene dental.',
                ),
                SizedBox(height: 8),
                Text(
                  '2. Los datos se almacenan de forma segura y no se comparten con terceros.',
                ),
                SizedBox(height: 8),
                Text(
                  '3. La supervisión de un adulto es recomendada para menores.',
                ),
                SizedBox(height: 8),
                Text(
                  '4. La aplicación no reemplaza el consejo médico profesional.',
                ),
                SizedBox(height: 12),
                Text(
                  'Al aceptar estos términos, confirmas que has leído y entendido las condiciones de uso.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ingresa un nombre.'
                            : null,
                      ),
                      SizedBox(height: 12),

                      // Campo de fecha de nacimiento
                      TextFormField(
                        controller: _birthDateCtrl,
                        readOnly: true,
                        onTap: _selectBirthDate,
                        decoration: InputDecoration(
                          labelText: 'Fecha de nacimiento del usuario',
                          prefixIcon: Icon(Icons.calendar_today),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText: 'Selecciona la fecha de nacimiento',
                        ),
                        validator: (v) {
                          if (_selectedBirthDate == null) {
                            return 'Selecciona una fecha de nacimiento.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),

                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Ingresa un correo.';
                          if (!RegExp(
                            r"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                          ).hasMatch(v))
                            return 'Correo inválido.';
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: _passwordQuality,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _pass2Ctrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Repetir contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Repite la contraseña.';
                          if (v != _passCtrl.text)
                            return 'Las contraseñas no coinciden.';
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Checkbox de términos y condiciones
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _acceptedTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _acceptedTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _showTermsDialog,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(text: 'Acepto los '),
                                      TextSpan(
                                        text: 'términos y condiciones',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(text: ' de uso'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Crear cuenta',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                'Al registrarte, confirmas que tienes al menos 6 años de edad y aceptas nuestros términos de uso.',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ----------------- Home Page (placeholder) -----------------

class HomePage extends StatelessWidget {
  final String name;
  const HomePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brush IA'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola, ${name.split('@').first}! 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hora de cepillarse',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Usa el cronómetro interactivo para cepillarte 2 minutos. Agrega canciones y personajes para motivar a los niños.',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () => _showTimer(context),
                      child: Text('Iniciar cronómetro'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimer(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Cronómetro de cepillado'),
        content: BrushTimer(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

// ----------------- Brush Timer (simple) -----------------

class BrushTimer extends StatefulWidget {
  const BrushTimer({super.key});

  @override
  _BrushTimerState createState() => _BrushTimerState();
}

class _BrushTimerState extends State<BrushTimer> {
  static const int targetSeconds = 120; // 2 minutes
  int _seconds = targetSeconds;
  bool _running = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_running) return;
    setState(() => _running = true);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds -= 1;
        } else {
          _running = false;
          timer.cancel();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = targetSeconds;
      _running = false;
    });
  }

  String _format(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _format(_seconds),
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _startTimer, child: Text('Iniciar')),
            SizedBox(width: 12),
            ElevatedButton(onPressed: _pauseTimer, child: Text('Pausar')),
            SizedBox(width: 12),
            OutlinedButton(onPressed: _resetTimer, child: Text('Reset')),
          ],
        ),
      ],
    );
  }
}
