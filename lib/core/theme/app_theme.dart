import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de cores do Cicatriza - Tema Claro (☀️)
class CicatrizaLightColors {
  // Cores primárias
  static const Color primary = Color(0xFF009688); // Verde Clínico
  static const Color secondary = Color(0xFF4DB6AC); // Verde Água
  static const Color accent = Color(0xFF007AFF); // Azul Calmo

  // Superfícies
  static const Color surface = Color(0xFFFFFFFF); // Branco
  static const Color background = Color(0xFFFAFAFA); // Cinza Claro

  // Textos
  static const Color textPrimary = Color(0xFF263238); // Grafite
  static const Color textSecondary = Color(0xFF546E7A); // Cinza Médio

  // Bordas e divisores
  static const Color divider = Color(0xFFE0E0E0); // Cinza Suave

  // Estados
  static const Color error = Color(0xFFE57373); // Vermelho Suave
  static const Color success = Color(0xFF81C784); // Verde Suave
  static const Color disabled = Color(0xFFCFD8DC); // Cinza Pálido

  // Overlays
  static const Color overlayLight = Color(
    0x14009688,
  ); // rgba(0, 150, 136, 0.08)
}

/// Sistema de cores do Cicatriza - Tema Escuro (🌙)
class CicatrizaDarkColors {
  // Cores primárias
  static const Color primary = Color(0xFF4DB6AC); // Verde Clínico Claro
  static const Color secondary = Color(0xFF80CBC4); // Verde Suave
  static const Color accent = Color(0xFF82B1FF); // Azul Claro

  // Superfícies
  static const Color surface = Color(0xFF263238); // Cinza Escuro
  static const Color background = Color(0xFF121212); // Preto Suave

  // Textos
  static const Color textPrimary = Color(0xFFFFFFFF); // Branco
  static const Color textSecondary = Color(0xFFB0BEC5); // Cinza Claro

  // Bordas e divisores
  static const Color divider = Color(0xFF37474F); // Cinza Opaco

  // Estados
  static const Color error = Color(0xFFEF5350); // Vermelho Vivo
  static const Color success = Color(0xFFA5D6A7); // Verde Claro
  static const Color disabled = Color(0xFF455A64); // Cinza Escuro

  // Overlays
  static const Color overlayDark = Color(
    0x294DB6AC,
  ); // rgba(77, 182, 172, 0.16)
}

/// Cores específicas para status de feridas
class WoundStatusColors {
  static const Color healing = Color(0xFF4CAF50); // Verde - Cicatrizando
  static const Color stagnant = Color(0xFFFF9800); // Laranja - Estagnada
  static const Color worsening = Color(0xFFE57373); // Vermelho suave - Piorando
  static const Color infected = Color(0xFFD32F2F); // Vermelho - Infectada
  static const Color granulation = Color(0xFFE91E63); // Rosa - Granulação
  static const Color epithelialization = Color(
    0xFF9C27B0,
  ); // Roxo - Epitelização
}

/// Espaçamentos padronizados baseados nos mockups
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Espaçamentos específicos dos mockups
  static const double cardPadding = 16.0; // Padding interno dos cards
  static const double screenPadding = 16.0; // Padding das telas
  static const double listItemPadding = 16.0; // Padding dos itens de lista
  static const double buttonHeight = 48.0; // Altura padrão dos botões
  static const double inputHeight = 48.0; // Altura padrão dos campos
}

/// Tema principal do aplicativo Cicatriza
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      brightness: Brightness.light,

      // Esquema de cores - Tema Claro
      colorScheme: const ColorScheme.light(
        primary: CicatrizaLightColors.primary,
        onPrimary: Colors.white,
        primaryContainer: CicatrizaLightColors.secondary,
        onPrimaryContainer: CicatrizaLightColors.textPrimary,
        secondary: CicatrizaLightColors.secondary,
        onSecondary: Colors.white,
        tertiary: CicatrizaLightColors.accent,
        onTertiary: Colors.white,
        error: CicatrizaLightColors.error,
        onError: Colors.white,
        surface: CicatrizaLightColors.surface,
        onSurface: CicatrizaLightColors.textPrimary,
        surfaceContainerHighest: CicatrizaLightColors.background,
        onSurfaceVariant: CicatrizaLightColors.textSecondary,
        outline: CicatrizaLightColors.divider,
      ),

      // Tema do AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: CicatrizaLightColors.surface,
        foregroundColor: CicatrizaLightColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        centerTitle: true,
      ),

      // Tema dos cartões
      cardTheme: CardThemeData(
        color: CicatrizaLightColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
      ),

      // Tema dos botões elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CicatrizaLightColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Tema dos campos de entrada
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CicatrizaLightColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CicatrizaLightColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CicatrizaLightColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CicatrizaLightColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CicatrizaLightColors.error,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          color: CicatrizaLightColors.textSecondary,
          fontSize: 16,
          fontFamily: 'Inter',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),

      // Tema da navegação inferior
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CicatrizaLightColors.surface,
        selectedItemColor: CicatrizaLightColors.textPrimary,
        unselectedItemColor: CicatrizaLightColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),

      // Tipografia
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        titleLarge: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        titleMedium: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        titleSmall: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          color: CicatrizaLightColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        labelLarge: TextStyle(
          color: CicatrizaLightColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        labelMedium: TextStyle(
          color: CicatrizaLightColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        labelSmall: TextStyle(
          color: CicatrizaLightColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CicatrizaLightColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),

      // Scaffold
      scaffoldBackgroundColor: CicatrizaLightColors.background,

      // Divider
      dividerColor: CicatrizaLightColors.divider,
      dividerTheme: const DividerThemeData(
        color: CicatrizaLightColors.divider,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      brightness: Brightness.dark,

      // Esquema de cores - Tema Escuro
      colorScheme: const ColorScheme.dark(
        primary: CicatrizaDarkColors.primary,
        onPrimary: CicatrizaDarkColors.surface,
        primaryContainer: CicatrizaDarkColors.secondary,
        onPrimaryContainer: CicatrizaDarkColors.textPrimary,
        secondary: CicatrizaDarkColors.secondary,
        onSecondary: CicatrizaDarkColors.surface,
        tertiary: CicatrizaDarkColors.accent,
        onTertiary: CicatrizaDarkColors.surface,
        error: CicatrizaDarkColors.error,
        onError: CicatrizaDarkColors.surface,
        surface: CicatrizaDarkColors.surface,
        onSurface: CicatrizaDarkColors.textPrimary,
        surfaceContainerHighest: CicatrizaDarkColors.background,
        onSurfaceVariant: CicatrizaDarkColors.textSecondary,
        outline: CicatrizaDarkColors.divider,
      ),

      // Tema do AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: CicatrizaDarkColors.surface,
        foregroundColor: CicatrizaDarkColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        centerTitle: true,
      ),

      // Tema dos cartões
      cardTheme: CardThemeData(
        color: CicatrizaDarkColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
      ),

      // Tema dos botões elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CicatrizaDarkColors.primary,
          foregroundColor: CicatrizaDarkColors.surface,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Tema dos campos de entrada
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CicatrizaDarkColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CicatrizaDarkColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CicatrizaDarkColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CicatrizaDarkColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CicatrizaDarkColors.error,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          color: CicatrizaDarkColors.textSecondary,
          fontSize: 16,
          fontFamily: 'Inter',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),

      // Tema da navegação inferior
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CicatrizaDarkColors.surface,
        selectedItemColor: CicatrizaDarkColors.textPrimary,
        unselectedItemColor: CicatrizaDarkColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),

      // Tipografia
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        titleLarge: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        titleMedium: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        titleSmall: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          color: CicatrizaDarkColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        labelLarge: TextStyle(
          color: CicatrizaDarkColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        labelMedium: TextStyle(
          color: CicatrizaDarkColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        labelSmall: TextStyle(
          color: CicatrizaDarkColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CicatrizaDarkColors.primary,
        foregroundColor: CicatrizaDarkColors.surface,
        elevation: 0,
        shape: CircleBorder(),
      ),

      // Scaffold
      scaffoldBackgroundColor: CicatrizaDarkColors.background,

      // Divider
      dividerColor: CicatrizaDarkColors.divider,
      dividerTheme: const DividerThemeData(
        color: CicatrizaDarkColors.divider,
        thickness: 1,
      ),
    );
  }
}
