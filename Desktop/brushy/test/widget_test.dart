import 'package:flutter_test/flutter_test.dart';
import 'package:brushy/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(BrushyApp());

    // Verify that our app shows the splash screen initially
    expect(find.text('Brushy'), findsOneWidget);
    expect(find.text('¡Cepillarse nunca fue tan divertido!'), findsOneWidget);
  });

  testWidgets('Navigation to login page works', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(BrushyApp());

    // Wait for splash screen animation to complete
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Verify we're now on the login page
    expect(find.text('Inicia sesión'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
  });

  testWidgets('Navigation to register page works', (WidgetTester tester) async {
    // Build our app and wait for login page
    await tester.pumpWidget(BrushyApp());
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Tap the register button
    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();

    // Verify we're on the register page
    expect(find.text('Registro'), findsOneWidget);
    expect(find.text('Nombre (o nombre del niño)'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });

  testWidgets('Login form validation works', (WidgetTester tester) async {
    // Build our app and wait for login page
    await tester.pumpWidget(BrushyApp());
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Try to submit empty form
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    // Verify validation messages appear
    expect(find.text('Ingresa tu correo.'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña.'), findsOneWidget);
  });

  testWidgets('Register form validation works', (WidgetTester tester) async {
    // Navigate to register page
    await tester.pumpWidget(BrushyApp());
    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();

    // Try to submit empty form
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    // Verify validation messages appear
    expect(find.text('Ingresa un nombre.'), findsOneWidget);
    expect(find.text('Ingresa un correo.'), findsOneWidget);
  });
}