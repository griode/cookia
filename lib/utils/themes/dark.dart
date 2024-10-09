import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cookia/utils/themes/colors.dart';

ThemeData themeDark() {
  return ThemeData(

    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.dark)
          .textTheme, // Adapte la police au thème sombre
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      // Transparence pour mieux s'adapter au mode sombre
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.grey[800], // Arrière-plan adapté au thème sombre
      labelStyle: const TextStyle(color: Colors.white),
    ),
    brightness: Brightness.dark,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        padding: const EdgeInsets.all(16.0),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        padding: const EdgeInsets.all(16.0),
        foregroundColor: Colors.white,
        side: const BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.white70,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      labelStyle: const TextStyle(
        color: Colors.white,
      ),
      hintStyle: const TextStyle(
        color: Colors.white54,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      // Fond noir pour la barre de navigation
      unselectedItemColor: Colors.white70,

      unselectedLabelStyle: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 11,
      ),
      selectedLabelStyle: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 11.5,
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  );
}
