import 'package:daily_quotes/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote App',
      theme: ThemeData(
        primaryColor: Colors.deepPurple[200], // Soft lavender for primary color
        scaffoldBackgroundColor: Colors.purple[50], // Light lavender for background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[200], // Lavender AppBar
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.deepPurple[900], // Deep purple for text
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: GoogleFonts.playfairDisplayTextTheme(
          Theme.of(context).textTheme.copyWith(
            bodyLarge: TextStyle(
              color: Colors.deepPurple[800], // Medium purple for larger body text
            ),
            bodyMedium: TextStyle(
              color: Colors.deepPurple[800], // Medium purple for medium body text
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.deepPurple[50], // Light lavender for card background
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple[300], // Soft purple for buttons
          foregroundColor: Colors.white, // White text/icons for contrast
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.deepPurple[300], // White text for contrast
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: SplashScreen(), // Start with the custom SplashScreen
    );
  }
}
