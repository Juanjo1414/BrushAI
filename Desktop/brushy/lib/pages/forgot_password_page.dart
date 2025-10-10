import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/responsive_helper.dart';
import '../widgets/brushy_logo.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _tokenSent = false;
  final AuthService _auth = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetToken() async {
    if (_emailController.text.trim().isEmpty) {
      _showError('Ingresa tu correo electrónico');
      return;
    }

    setState(() => _loading = true);

    final error = await _auth.sendResetToken(_emailController.text.trim());

    setState(() => _loading = false);

    if (error != null) {
      _showError(error);
    } else {
      setState(() => _tokenSent = true);
      _showSuccess(
        'Se ha enviado un código de 6 dígitos a tu correo. Revisa tu bandeja de entrada.',
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final error = await _auth.resetPasswordWithToken(
      _emailController.text.trim(),
      _tokenController.text.trim(),
      _newPasswordController.text,
    );

    setState(() => _loading = false);

    if (error != null) {
      _showError(error);
    } else {
      _showSuccessDialog();
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
  }

  void _showSuccess(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green),
      );
    }
  }

  void _showSuccessDialog() {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('¡Contraseña actualizada!'),
          content: Text(
            'Tu contraseña ha sido cambiada exitosamente. Ya puedes iniciar sesión con tu nueva contraseña.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Volver a login
              },
              child: Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
        backgroundColor: Color(0xFFF7FBFF),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: ResponsiveHelper.getContainerMaxWidth(context),
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              _tokenSent
                                  ? 'Ingresa tu código'
                                  : 'Recupera tu cuenta',
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
                    child: _tokenSent ? _buildTokenForm() : _buildEmailForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingresa tu correo electrónico',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 8)),
        Text(
          'Te enviaremos un código de 6 dígitos para restablecer tu contraseña.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
          ),
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 20)),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
          ),
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
            ),
            prefixIcon: Icon(
              Icons.email,
              size: ResponsiveHelper.getResponsiveSize(context, 20),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 24)),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _sendResetToken,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getResponsiveSize(context, 14),
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
                    'Enviar código',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        16,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTokenForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Código enviado a: ${_emailController.text}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          TextFormField(
            controller: _tokenController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Código de 6 dígitos',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              ),
              prefixIcon: Icon(
                Icons.security,
                size: ResponsiveHelper.getResponsiveSize(context, 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              counterText: '',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Ingresa el código de 6 dígitos';
              if (v.trim().length != 6) return 'El código debe tener 6 dígitos';
              return null;
            },
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
            ),
            decoration: InputDecoration(
              labelText: 'Nueva contraseña',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              ),
              prefixIcon: Icon(
                Icons.lock,
                size: ResponsiveHelper.getResponsiveSize(context, 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Ingresa tu nueva contraseña';
              if (v.length < 8)
                return 'La contraseña debe tener al menos 8 caracteres';
              return null;
            },
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
            ),
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                size: ResponsiveHelper.getResponsiveSize(context, 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Confirma tu nueva contraseña';
              if (v != _newPasswordController.text)
                return 'Las contraseñas no coinciden';
              return null;
            },
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 24)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _tokenSent = false);
                    _tokenController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getResponsiveSize(context, 14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cambiar correo',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSize(context, 12)),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _loading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getResponsiveSize(context, 14),
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
                          'Cambiar contraseña',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              16,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 16)),
          Center(
            child: TextButton(
              onPressed: _loading ? null : _sendResetToken,
              child: Text(
                '¿No recibiste el código? Reenviar',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
