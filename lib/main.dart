import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_audio_flutter/screens/main_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.limeM3;

    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: usedScheme,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: usedScheme,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}
