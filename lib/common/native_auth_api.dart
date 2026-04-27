import 'dart:developer' as developer;

import 'package:flutter/services.dart';

class NativeAuthApi {
  NativeAuthApi._();

  static const MethodChannel _channel = MethodChannel('native_api');
  static const String _logName = 'NativeAuthApi';

  static const double _defaultActivityLevel = 1.2;
  static const int _defaultTargetId = 1;
  static const double _defaultWeeklyBudget = 5000.0;

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    developer.log('→ login called: email=$email', name: _logName);
    final dynamic token = await _channel.invokeMethod('login', {
      'email': email,
      'password': password,
    });
    developer.log(
      '← login returned: ${token != null ? "exists" : "null"}',
      name: _logName,
    );
    return token?.toString();
  }

  static Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required double weight,
    required int height,
    required String birthDate,
    required String gender,
    double activityLevel = _defaultActivityLevel,
    int targetId = _defaultTargetId,
    double weeklyBudget = _defaultWeeklyBudget,
  }) async {
    developer.log('→ register called: email=$email', name: _logName);
    final res = await _channel.invokeMethod<bool>('register', {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'weight': weight,
      'height': height,
      'birthDate': birthDate,
      'gender': gender.toUpperCase(),
      'activityLevel': activityLevel,
      'targetId': targetId,
      'weeklyBudget': weeklyBudget,
    });
    developer.log('← register returned: $res', name: _logName);
    return res == true;
  }

  static Future<dynamic> profile() async {
    developer.log('→ profile called', name: _logName);
    final dynamic profile = await _channel.invokeMethod('profile');
    developer.log(
      '← profile returned: ${profile != null ? "exists" : "null"}',
      name: _logName,
    );
    return profile;
  }
}

