import 'package:flutter/material.dart';

class AppConstants {
  // Nome da aplicação
  static const String appName = 'HabitQuest';
  static const String appTagline = 'Transforma hábitos em conquistas!';

  // Categorias de hábitos
  static const List<Map<String, String>> habitCategories = [
    {'name': 'Saúde', 'icon': '💪'},
    {'name': 'Fitness', 'icon': '🏃'},
    {'name': 'Alimentação', 'icon': '🥗'},
    {'name': 'Estudo', 'icon': '📚'},
    {'name': 'Trabalho', 'icon': '💼'},
    {'name': 'Meditação', 'icon': '🧘'},
    {'name': 'Sono', 'icon': '😴'},
    {'name': 'Hidratação', 'icon': '💧'},
    {'name': 'Social', 'icon': '👥'},
    {'name': 'Criatividade', 'icon': '🎨'},
    {'name': 'Finanças', 'icon': '💰'},
    {'name': 'Geral', 'icon': '🎯'},
  ];

  // Ícones disponíveis para hábitos
  static const List<String> habitIcons = [
    '🎯', '💪', '🏃', '🥗', '📚', '💼', '🧘', '😴',
    '💧', '👥', '🎨', '💰', '🌅', '🌙', '☀️', '⭐',
    '🔥', '💎', '🏆', '🎮', '🎵', '📝', '🧠', '❤️',
    '🌱', '🌳', '🦋', '🐝', '🍎', '🥤', '☕', '🧹',
  ];

  // Cores para níveis
  static const List<Color> levelColors = [
    Color(0xFF9E9E9E), // Nível 1 - Cinza
    Color(0xFF4CAF50), // Nível 2 - Verde
    Color(0xFF2196F3), // Nível 3 - Azul
    Color(0xFF9C27B0), // Nível 4 - Roxo
    Color(0xFFFF9800), // Nível 5 - Laranja
    Color(0xFFE91E63), // Nível 6 - Rosa
    Color(0xFF00BCD4), // Nível 7 - Ciano
    Color(0xFFFF5722), // Nível 8 - Vermelho-Laranja
    Color(0xFF673AB7), // Nível 9 - Roxo Profundo
    Color(0xFFFFD700), // Nível 10+ - Dourado
  ];

  static Color getLevelColor(int level) {
    if (level <= 0) return levelColors[0];
    if (level > 10) return levelColors[9];
    return levelColors[level - 1];
  }

  // Sugestões de hábitos
  static const List<Map<String, dynamic>> habitSuggestions = [
    {
      'name': 'Beber 2L de água',
      'description': 'Manter-se hidratado durante o dia',
      'icon': '💧',
      'category': 'Hidratação',
      'xpReward': 10,
    },
    {
      'name': 'Exercício 30min',
      'description': 'Praticar atividade física',
      'icon': '🏃',
      'category': 'Fitness',
      'xpReward': 20,
    },
    {
      'name': 'Meditar 10min',
      'description': 'Momento de calma e reflexão',
      'icon': '🧘',
      'category': 'Meditação',
      'xpReward': 15,
    },
    {
      'name': 'Ler 20 páginas',
      'description': 'Expandir conhecimentos',
      'icon': '📚',
      'category': 'Estudo',
      'xpReward': 15,
    },
    {
      'name': 'Dormir 8 horas',
      'description': 'Descanso adequado',
      'icon': '😴',
      'category': 'Sono',
      'xpReward': 15,
    },
    {
      'name': 'Comer fruta',
      'description': 'Alimentação saudável',
      'icon': '🍎',
      'category': 'Alimentação',
      'xpReward': 10,
    },
    {
      'name': 'Sem redes sociais',
      'description': '1 hora sem telemóvel',
      'icon': '📵',
      'category': 'Saúde',
      'xpReward': 20,
    },
    {
      'name': 'Agradecer',
      'description': 'Escrever 3 coisas por que és grato',
      'icon': '🙏',
      'category': 'Meditação',
      'xpReward': 10,
    },
  ];
}

class AppTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF00D9A5);
  static const Color accentColor = Color(0xFFFFB74D);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF4CAF50);

  // Cores de fundo
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color darkBackgroundColor = Color(0xFF1A1A2E);
  static const Color darkCardColor = Color(0xFF16213E);

  // Cores de texto
  static const Color textPrimaryColor = Color(0xFF2D3436);
  static const Color textSecondaryColor = Color(0xFF636E72);
  static const Color textLightColor = Color(0xFFFFFFFF);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00D9A5), Color(0xFF00B894)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Tema claro
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: cardColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textLightColor,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: textLightColor,
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLightColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondaryColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  // Tema escuro
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: darkCardColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkCardColor,
      foregroundColor: textLightColor,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: darkCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: textLightColor,
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLightColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkCardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondaryColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}

