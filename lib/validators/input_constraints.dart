import 'package:flutter/services.dart';

class InputConstraints {
  const InputConstraints._();

  static const List<double> activityLevels = [
    1,
    1.2,
    1.4,
    1.6,
    1.8,
  ];

  static const List<String> activityLevelLabels = [
    'Малоактивный',
    'Лёгкая активность',
    'Умеренный',
    'Активный',
    'Очень активный',
  ];

  static const double defaultActivityLevel = 1;

  static int activityIndexForValue(double value) {
    final i = activityLevels.indexOf(value);
    return i < 0 ? 0 : i;
  }

  static String activityLabelForValue(double value) {
    final i = activityIndexForValue(value);
    return activityLevelLabels[i];
  }

  static const int minHeightCm = 50;
  static const int maxHeightCm = 250;
  static const double minWeightKg = 20;
  static const double maxWeightKg = 300;
  static const int minAgeYears = 5;
  static const int maxAgeYears = 120;
  static const int minWeeklyBudget = 1;

  static const int emailMaxLength = 254;
  static const int passwordMaxLength = 64;
  static const int nameMaxLength = 32;
  static const int heightMaxLength = 3;
  static const int weightMaxLength = 5;
  static const int ageMaxLength = 3;
  static const int budgetMaxLength = 7;

  // Character constraints
  static final RegExp nameAllowed = RegExp(r"[A-Za-zА-Яа-яЁё\s\-]");
  static final RegExp emailAllowed = RegExp(r"[A-Za-z0-9@._+\-]");
  static final RegExp passwordAllowed = RegExp(
    r"[A-Za-z0-9 !@#\$%\^&\*\(\)_\+\-=\[\]\{\};:'"",.<>\/\?\\|`~]",
  );

  static final RegExp digitsOnly = RegExp(r"[0-9]");
  static final RegExp decimalNumberAllowed = RegExp(r"[0-9\.,]");

  static final TextInputFormatter nameFormatter =
      FilteringTextInputFormatter.allow(nameAllowed);
  static final TextInputFormatter emailFormatter =
      FilteringTextInputFormatter.allow(emailAllowed);
  static final TextInputFormatter passwordFormatter =
      FilteringTextInputFormatter.allow(passwordAllowed);
  static final TextInputFormatter digitsOnlyFormatter =
      FilteringTextInputFormatter.allow(digitsOnly);
  static final TextInputFormatter decimalNumberFormatter =
      FilteringTextInputFormatter.allow(decimalNumberAllowed);
  static final TextInputFormatter denyWhitespaceFormatter =
      FilteringTextInputFormatter.deny(RegExp(r"\s"));
}

