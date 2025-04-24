import 'package:flutter/material.dart';
import 'package:app_tarefas/src/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = AppTheme.lightTheme;

  ThemeData get theme => _theme;

  void alternarTema() {
    if (_theme == AppTheme.lightTheme) {
      _theme = AppTheme.darkTheme;
    } else {
      _theme = AppTheme.lightTheme;
    }

    notifyListeners();
  }
}
