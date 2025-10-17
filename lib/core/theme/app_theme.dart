import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de cores do Cicatriza baseado no guia de branding e mockups
class CicatrizaColors {
  // Cores primárias do branding
  static const Color primary = Color(0xFF049082); // Verde clínico
  static const Color primaryVariant = Color(0xFF4DB6AC); // Verde água
  static const Color secondary = Color(0xFF007AFF); // Azul calmo

  // Cores de fundo baseadas nos mockups
  static const Color background = Color(0xFFF8FCFB); // Fundo principal
  static const Color surface = Color(0xFFE6F4F3); // Superfícies e campos
  static const Color surfaceVariant = Color(0xFFFAFAFA); // Neutra claro

  // Cores de texto baseadas nos mockups
  static const Color onBackground = Color(0xFF0D1C1B); // Texto principal
  static const Color onSurface = Color(0xFF479E96); // Texto secundário
  static const Color onPrimary = Color(0xFFF8FCFB); // Texto em botões primários

  // Cores funcionais
  static const Color error = Color(0xFFE57373); // Vermelho suave
  static const Color success = Color(0xFF4CAF50); // Verde sucesso
  static const Color warning = Color(0xFFFF9800); // Laranja alerta
  static const Color info = Color(0xFF2196F3); // Azul informação

  // Cores neutras
  static const Color neutral100 = Color(0xFFFAFAFA);
  static const Color neutral200 = Color(0xFFF5F5F5);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF263238); // Neutra escuro
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
      fontFamily: GoogleFonts.inter().fontFamily, // Fonte baseada nos mockups
      // Esquema de cores baseado no branding
      colorScheme: const ColorScheme.light(
        primary: CicatrizaColors.primary,
        onPrimary: CicatrizaColors.onPrimary,
        primaryContainer: CicatrizaColors.primaryVariant,
        onPrimaryContainer: CicatrizaColors.onBackground,
        secondary: CicatrizaColors.secondary,
        onSecondary: CicatrizaColors.onPrimary,
        error: CicatrizaColors.error,
        onError: CicatrizaColors.onPrimary,
        surface: CicatrizaColors.background,
        onSurface: CicatrizaColors.onBackground,
        surfaceContainerHighest: CicatrizaColors.surface,
        onSurfaceVariant: CicatrizaColors.onSurface,
        outline: CicatrizaColors.neutral300,
      ),

      // Tema do AppBar baseado nos mockups
      appBarTheme: const AppBarTheme(
        backgroundColor: CicatrizaColors.background,
        foregroundColor: CicatrizaColors.onBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        centerTitle: true,
      ),

      // Tema dos cartões baseado nos mockups
      cardTheme: CardThemeData(
        color: CicatrizaColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
      ),

      // Tema dos botões baseado nos mockups
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CicatrizaColors.primary,
          foregroundColor: CicatrizaColors.onPrimary,
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

      // Tema dos campos de entrada baseado nos mockups
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CicatrizaColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CicatrizaColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CicatrizaColors.error, width: 2),
        ),
        hintStyle: const TextStyle(
          color: CicatrizaColors.onSurface,
          fontSize: 16,
          fontFamily: 'Inter',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),

      // Tema da navegação inferior baseado nos mockups
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CicatrizaColors.background,
        selectedItemColor: CicatrizaColors.onBackground,
        unselectedItemColor: CicatrizaColors.onSurface,
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

      // Tipografia baseada nos mockups
      textTheme: const TextTheme(
        // Títulos principais
        headlineLarge: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),

        // Títulos de seção
        titleLarge: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        titleMedium: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        titleSmall: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),

        // Texto corpo
        bodyLarge: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          color: CicatrizaColors.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),

        // Labels
        labelLarge: TextStyle(
          color: CicatrizaColors.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        labelMedium: TextStyle(
          color: CicatrizaColors.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        labelSmall: TextStyle(
          color: CicatrizaColors.onSurface,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),

      // Tema dos FloatingActionButtons baseado nos mockups
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CicatrizaColors.primary,
        foregroundColor: CicatrizaColors.onPrimary,
        elevation: 0,
        shape: CircleBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,

      colorScheme: const ColorScheme.dark(
        primary: CicatrizaColors.primaryVariant,
        onPrimary: CicatrizaColors.neutral900,
        secondary: CicatrizaColors.secondary,
        onSecondary: CicatrizaColors.neutral900,
        error: CicatrizaColors.error,
        onError: CicatrizaColors.neutral900,
        surface: CicatrizaColors.neutral800,
        onSurface: CicatrizaColors.neutral100,
        outline: CicatrizaColors.neutral600,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: CicatrizaColors.neutral900,
        foregroundColor: CicatrizaColors.neutral100,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        color: CicatrizaColors.neutral800,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CicatrizaColors.primaryVariant,
          foregroundColor: CicatrizaColors.neutral900,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
