import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cookia/utils/themes/colors.dart';

ThemeData themeLight() {
  return ThemeData(

      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        labelStyle: const TextStyle(color: Colors.black),
      ),
      brightness: Brightness.light,
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
          foregroundColor: Colors.black,
          side: const BorderSide(
            color: Colors.grey,
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
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintStyle: const TextStyle(
          color: Colors.black54,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedItemColor: Colors.black54,
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
      ));
}
