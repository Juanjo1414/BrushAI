import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/responsive_helper.dart';
import '../widgets/brushy_logo.dart';

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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      _showError('Selecciona tu fecha de nacimiento.');
      return;
    }
    if (!_acceptedTerms) {
      _showError('Debes aceptar los términos y condiciones.');
      return;
    }

    // Validar edad mínima de 6 años
    final today = DateTime.now();
    final age = today.year - _selectedBirthDate!.year;
    if (age < 6 ||
        (age == 6 &&
            today.isBefore(
              DateTime(
                _selectedBirthDate!.year + 6,
                _selectedBirthDate!.month,
                _selectedBirthDate!.day,
              ),
            ))) {
      _showError('Debes tener al menos 6 años para registrarte.');
      return;
    }

    setState(() => _loading = true);

    final err = await _auth.register(
      _emailCtrl.text,
      _passCtrl.text,
      _nameCtrl.text,
    );

    setState(() => _loading = false);

    if (err != null) {
      _showError(err);
    } else {
      _showSuccess();
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _showSuccess() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('¡Registro exitoso!'),
          content: Text('Tu cuenta ha sido creada. Ya puedes iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
      fieldLabelText: 'Fecha de nacimiento',
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Términos y Condiciones',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: ResponsiveHelper.getContainerMaxWidth(context),
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TÉRMINOS Y CONDICIONES DE USO - BRUSHY IA',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 16),
                  ),
                  Text(
                    '1. ACEPTACIÓN DE LOS TÉRMINOS',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 8),
                  ),
                  Text(
                    'Al utilizar Brushy IA, aceptas estos términos y condiciones en su totalidad. Si no estás de acuerdo, no utilices la aplicación.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 12),
                  ),
                  Text(
                    '2. DESCRIPCIÓN DEL SERVICIO',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 8),
                  ),
                  Text(
                    'Brushy IA es una aplicación de asistencia para el cuidado dental que utiliza inteligencia artificial para proporcionar recomendaciones y consejos.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 12),
                  ),
                  Text(
                    '3. PRIVACIDAD Y DATOS',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 8),
                  ),
                  Text(
                    'Respetamos tu privacidad. Los datos proporcionados se utilizarán únicamente para mejorar tu experiencia con la aplicación.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 12),
                  ),
                  Text(
                    '4. EDAD MÍNIMA',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 8),
                  ),
                  Text(
                    'Debes tener al menos 6 años para utilizar esta aplicación. Los menores de edad deben contar con supervisión de un adulto.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 12),
                  ),
                  Text(
                    '5. LIMITACIÓN DE RESPONSABILIDAD',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 8),
                  ),
                  Text(
                    'Brushy IA proporciona información general y no sustituye el consejo médico profesional. Siempre consulta a un dentista para problemas de salud dental.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSize(context, 16),
                  ),
                  Text(
                    'Al aceptar estos términos, confirmas que has leído y entendido todas las condiciones.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        12,
                      ),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _acceptedTerms = true);
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
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
                              'Crea tu cuenta',
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
                            controller: _nameCtrl,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Nombre completo',
                              labelStyle: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
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
                                return 'Ingresa tu nombre.';
                              if (v.trim().length < 2)
                                return 'El nombre debe tener al menos 2 caracteres.';
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
                            controller: _birthDateCtrl,
                            readOnly: true,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Fecha de nacimiento',
                              labelStyle: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                size: ResponsiveHelper.getResponsiveSize(
                                  context,
                                  20,
                                ),
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                size: ResponsiveHelper.getResponsiveSize(
                                  context,
                                  24,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onTap: _selectDate,
                            validator: (v) {
                              if (_selectedBirthDate == null)
                                return 'Selecciona tu fecha de nacimiento.';
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
                                return 'Ingresa una contraseña.';
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
                          TextFormField(
                            controller: _pass2Ctrl,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Confirmar contraseña',
                              labelStyle: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
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
                                return 'Confirma tu contraseña.';
                              if (v != _passCtrl.text)
                                return 'Las contraseñas no coinciden.';
                              return null;
                            },
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSize(
                              context,
                              16,
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptedTerms,
                                onChanged: (v) =>
                                    setState(() => _acceptedTerms = v ?? false),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _showTermsAndConditions,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.getResponsiveFontSize(
                                              context,
                                              14,
                                            ),
                                        color: Colors.black87,
                                      ),
                                      children: [
                                        TextSpan(text: 'Acepto los '),
                                        TextSpan(
                                          text: 'términos y condiciones',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                      'Registrarse',
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
                        ],
                      ),
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
