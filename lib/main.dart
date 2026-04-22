import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  developer.log('🚀 App starting', name: 'MyApp');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  static const MethodChannel _channel = MethodChannel('native_api');
  static const String _logName = 'AuthPage';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  String? _result;

  Future<void> _register() async {
    developer.log('→ _register called: email=${emailController.text}', name: _logName);
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      developer.log('→ Invoking native register...', name: _logName);
      final res = await _channel.invokeMethod<bool>('register', {
        "email": emailController.text,
        "password": passwordController.text,
      });
      developer.log('← Native register returned: $res', name: _logName);

      setState(() {
        _result = res == true ? "REGISTER SUCCESS" : "REGISTER FAILED";
        _loading = false;
      });
    } on PlatformException catch (e) {
      developer.log('← PlatformException: code=${e.code}, message=${e.message}', name: _logName, error: e);
      setState(() {
        _result = "ERROR: ${e.message}";
        _loading = false;
      });
    } catch (e, stack) {
      developer.log('← Unexpected error: $e', name: _logName, error: e, stackTrace: stack);
      setState(() {
        _result = "UNEXPECTED ERROR: $e";
        _loading = false;
      });
    }
  }

  Future<void> _login() async {
    developer.log('→ _login called: email=${emailController.text}', name: _logName);
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      developer.log('→ Invoking native login...', name: _logName);
      final token = await _channel.invokeMethod<String>('login', {
        "email": emailController.text,
        "password": passwordController.text,
      });
      developer.log('← Native login returned: token=${token != null ? "exists" : "null"}', name: _logName);

      setState(() {
        _result = token != null ? "TOKEN: $token" : "LOGIN FAILED";
        _loading = false;
      });
    } on PlatformException catch (e) {
      developer.log('← PlatformException: code=${e.code}, message=${e.message}', name: _logName, error: e);
      setState(() {
        _result = "ERROR: ${e.message}";
        _loading = false;
      });
    } catch (e, stack) {
      developer.log('← Unexpected error: $e', name: _logName, error: e, stackTrace: stack);
      setState(() {
        _result = "UNEXPECTED ERROR: $e";
        _loading = false;
      });
    }
  }

  Future<void> _profile() async {
    developer.log('→ _profile called', name: _logName);
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      developer.log('→ Invoking native profile...', name: _logName);
      final profile = await _channel.invokeMethod<String>('profile');
      developer.log('← Native profile returned: ${profile != null ? "exists" : "null"}', name: _logName);

      setState(() {
        _result = profile ?? "EMPTY PROFILE";
        _loading = false;
      });
    } on PlatformException catch (e) {
      developer.log('← PlatformException: code=${e.code}, message=${e.message}', name: _logName, error: e);
      setState(() {
        _result = "ERROR: ${e.message}";
        _loading = false;
      });
    } catch (e, stack) {
      developer.log('← Unexpected error: $e', name: _logName, error: e, stackTrace: stack);
      setState(() {
        _result = "UNEXPECTED ERROR: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Native Auth Demo"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 20),

            if (_loading)
              const CircularProgressIndicator(color: Colors.orange)
            else
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: _login,
                        child: const Text("Login"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: _register,
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: _profile,
                    child: const Text("Get Profile"),
                  ),
                ],
              ),

            const SizedBox(height: 30),

            if (_result != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _result!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}