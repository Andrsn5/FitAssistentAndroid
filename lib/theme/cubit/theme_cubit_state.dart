part of 'theme_cubit.dart';

class ThemeCubitState extends Equatable {
  const ThemeCubitState({required this.themeMode});

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

