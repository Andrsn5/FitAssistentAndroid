import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_cubit_state.dart';

class ThemeCubit extends Cubit<ThemeCubitState> {
  ThemeCubit() : super(const ThemeCubitState(themeMode: ThemeMode.dark));

  void setThemeMode(ThemeMode themeMode) {
    emit(ThemeCubitState(themeMode: themeMode));
  }

  void toggleThemeMode() {
    emit(
      ThemeCubitState(
        themeMode: state.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );
  }
}

