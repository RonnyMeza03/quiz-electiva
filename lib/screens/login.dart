import 'package:flutter/material.dart';
import 'package:quiz/screens/carros_electricos.dart';
import 'package:quiz/service/login_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _statusMessage = "";

  void _validate() async {
    print(_usernameController.value.text);
    print(_passwordController.value.text);
    LoginService.fetch({
      "username": _usernameController.value.text,
      "password": _passwordController.value.text,
    }).then((value) {
      setState(() {
        _statusMessage = value ? "Login exitoso" : "Usuario o contraseña incorrecta";
      });
      if (value) {
        _login();
      }
    });
  }

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarrosElectricosScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _validate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _statusMessage == "Login exitoso"
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'No tienes cuenta? Regístrate',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}