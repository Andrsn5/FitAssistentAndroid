import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Native Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Native Counter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;
  bool _isLoading = false;
  String? _errorMessage;

  static const MethodChannel _channel = MethodChannel('counter');

  Future<void> _incrementCounter() async {

    print("FLUTTER: button pressed");

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {

      print("FLUTTER: calling native");

      final int? newValue =
      await _channel.invokeMethod<int>('incrementCounter');

      print("FLUTTER: native returned $newValue");

      setState(() {
        _counter = newValue ?? 0;
        _isLoading = false;
      });

    } on PlatformException catch (e) {

      print("FLUTTER ERROR: ${e.message}");

      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),

            if (_isLoading)
              const CircularProgressIndicator(color: Colors.orange)
            else
              Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: _incrementCounter,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}