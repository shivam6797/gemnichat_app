import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/core/utils/helpers/shared_prefes_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await SharedPrefsHelper.getThemeMode();
    emit(theme);
  }

  Future<void> toggleTheme() async {
    final newMode =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await SharedPrefsHelper.setThemeMode(newMode);
    emit(newMode);
  }
}
