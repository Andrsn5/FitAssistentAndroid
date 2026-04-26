import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitassistent/theme/dark_theme.dart';
import 'package:fitassistent/theme/light_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitassistent/theme/cubit/theme_cubit.dart';
import 'package:fitassistent/pages/authorization_page.dart';

void main() {
  developer.log('🚀 App starting', name: 'MyApp');
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeCubitState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Native Auth Demo',
          debugShowCheckedModeBanner: false,
          theme: LightTheme().themeData,
          darkTheme: DarkTheme().themeData,
          themeMode: state.themeMode,
          home: const AuthorizationPage(),
        );
      },
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

  final emailController = TextEditingController(text: 'test@gmail.com');
  final passwordController = TextEditingController(text: 'test123');
  final firstNameController = TextEditingController(text: 'Ivan');
  final lastNameController = TextEditingController(text: 'Ivanov');
  final weightController = TextEditingController(text: '75.0');
  final heightController = TextEditingController(text: '180');
  final birthDateController = TextEditingController(text: '1995-05-15');
  final genderController = TextEditingController(text: 'MALE');
  final activityLevelController = TextEditingController(text: '1.375');
  final targetIdController = TextEditingController(text: '1');
  final weeklyBudgetController = TextEditingController(text: '5000.0');

  bool _loading = false;
  String? _result;
  bool _showRegisterFields = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    weightController.dispose();
    heightController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    activityLevelController.dispose();
    targetIdController.dispose();
    weeklyBudgetController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    developer.log('→ _register called: email=${emailController.text}', name: _logName);
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final res = await _channel.invokeMethod<bool>('register', {
        "email": emailController.text,
        "password": passwordController.text,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "weight": double.tryParse(weightController.text) ?? 0.0,
        "height": int.tryParse(heightController.text) ?? 0,
        "birthDate": birthDateController.text,
        "gender": genderController.text.toUpperCase(),
        "activityLevel": double.tryParse(activityLevelController.text) ?? 1.2,
        "targetId": int.tryParse(targetIdController.text) ?? 1,
        "weeklyBudget": double.tryParse(weeklyBudgetController.text) ?? 5000.0,
      });
      developer.log('← Native register returned: $res', name: _logName);
      setState(() {
        _result = res == true ? "REGISTER SUCCESS" : "REGISTER FAILED";
        _loading = false;
      });
    } on PlatformException catch (e) {
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
      // invokeMethod<dynamic> чтобы не падать на типах
      final dynamic token = await _channel.invokeMethod('login', {
        "email": emailController.text,
        "password": passwordController.text,
      });
      developer.log('← Native login returned: ${token != null ? "exists" : "null"}', name: _logName);
      setState(() {
        _result = token != null ? "LOGIN SUCCESS\nTOKEN: $token" : "LOGIN FAILED";
        _loading = false;
      });
    } on PlatformException catch (e) {
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
      final dynamic profile = await _channel.invokeMethod('profile');
      developer.log('← Native profile returned: ${profile != null ? "exists" : "null"}', name: _logName);
      setState(() {
        _result = profile?.toString() ?? "EMPTY PROFILE";
        _loading = false;
      });
    } on PlatformException catch (e) {
      developer.log('← PlatformException: code=${e.code}, message=${e.message}', name: _logName, error: e);
      setState(() {
        _loading = false;
        // Если есть кеш — он придёт как success, сюда попадаем только при реальной ошибке
        _result = null;
      });

      if (mounted) {
        final isNoInternet = e.message?.toLowerCase().contains('интернет') ?? false ||
            e.message!.toLowerCase().contains('internet') ?? false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNoInternet
                  ? '📶 Нет подключения к интернету'
                  : 'Ошибка: ${e.message}',
            ),
            backgroundColor: isNoInternet ? Colors.orange : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e, stack) {
      developer.log('← Unexpected error: $e', name: _logName, error: e, stackTrace: stack);
      setState(() {
        _result = "UNEXPECTED ERROR: $e";
        _loading = false;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.orange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Native Auth Demo"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => context.read<ThemeCubit>().toggleThemeMode(),
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(controller: emailController, label: "Email"),
            const SizedBox(height: 12),
            _buildTextField(
              controller: passwordController,
              label: "Password",
              obscure: true,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text("Registration fields"),
                Switch(
                  value: _showRegisterFields,
                  activeColor: Colors.orange,
                  onChanged: (val) => setState(() => _showRegisterFields = val),
                ),
              ],
            ),

            if (_showRegisterFields) ...[
              _buildTextField(controller: firstNameController, label: "First Name"),
              const SizedBox(height: 12),
              _buildTextField(controller: lastNameController, label: "Last Name"),
              const SizedBox(height: 12),
              _buildTextField(
                controller: weightController,
                label: "Weight (kg)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: heightController,
                label: "Height (cm)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: birthDateController,
                label: "Birth Date (yyyy-MM-dd)",
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: genderController,
                label: "Gender (MALE/FEMALE)",
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: activityLevelController,
                label: "Activity Level (e.g. 1.375)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: targetIdController,
                label: "Target ID (1/2/3)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: weeklyBudgetController,
                label: "Weekly Budget",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 8),

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
              Text(
                _result!,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}