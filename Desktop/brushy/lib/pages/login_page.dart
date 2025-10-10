import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../ui/shell/home_shell.dart';
import '../utils/responsive_helper.dart';
import '../widgets/brushy_logo.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function(String)? onLoginSuccess;

  const LoginPage({super.key, this.onLoginSuccess});

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
      // Llamar al callback de éxito si existe
      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!(_emailCtrl.text);
      } else {
        // Fallback: navegar manualmente si no hay callback
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => HomeShell(email: _emailCtrl.text),
            ),
          );
        }
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: ResponsiveHelper.getContainerMaxWidth(context),
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 10),
                  ),
                  Row(
                    children: [
                      const BrushyLogo(),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSize(context, 12),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Brushy IA',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      22,
                                    ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Inicia sesión',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 28),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getResponsiveSize(context, 18),
                    ),
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
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              labelStyle: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                size: ResponsiveHelper.getResponsiveSize(
                                  context,
                                  20,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSize(
                              context,
                              12,
                            ),
                          ),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                size: ResponsiveHelper.getResponsiveSize(
                                  context,
                                  20,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Ingresa tu contraseña.';
                              if (v.length < 8)
                                return 'La contraseña debe tener al menos 8 caracteres.';
                              return null;
                            },
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSize(
                              context,
                              12,
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordPage(),
                                ),
                              ),
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        16,
                                      ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSize(
                              context,
                              18,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.getResponsiveSize(
                                    context,
                                    14,
                                  ),
                                ),
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
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.getResponsiveFontSize(
                                              context,
                                              16,
                                            ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSize(
                              context,
                              12,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            ),
                            child: Text(
                              '¿No tienes cuenta? Regístrate',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 40),
                  ),
                  Center(
                    child: Text(
                      'Hecho con ❤️ para apoyar los hábitos de cepillado',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          12,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
