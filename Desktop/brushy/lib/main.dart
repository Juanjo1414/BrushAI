import 'package:flutter/material.dart';
import 'mongo_service.dart';
import 'ui/shell/home_shell.dart';
import 'pages/login_page.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar MongoDB
  try {
    await MongoService.connect();
    print('✅ MongoDB conectado exitosamente');
  } catch (e) {
    print('❌ Error al conectar MongoDB: $e');
  }

  runApp(const BrushyApp());
}

class BrushyApp extends StatelessWidget {
  const BrushyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brushy IA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FBFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7FBFF),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1976D2),
            side: const BorderSide(color: Color(0xFF1976D2)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1976D2),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Widget que maneja la autenticación y determina qué pantalla mostrar
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Verifica si el usuario está autenticado
  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al verificar estado de autenticación: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  /// Actualiza el estado de autenticación
  void _updateAuthStatus(bool isLoggedIn, [String email = '']) {
    setState(() {
      _isLoggedIn = isLoggedIn;
      if (isLoggedIn && email.isNotEmpty) {
        _userEmail = email;
      } else if (!isLoggedIn) {
        _userEmail = ''; // Limpiar el email al cerrar sesión
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Iniciando Brushy IA...'),
            ],
          ),
        ),
      );
    }

    if (_isLoggedIn) {
      return HomeShell(
        email: _userEmail.isNotEmpty ? _userEmail : 'usuario@ejemplo.com',
        onLogout: () => _updateAuthStatus(false),
      );
    } else {
      return LoginPage(
        onLoginSuccess: (email) => _updateAuthStatus(true, email),
      );
    }
  }
}
