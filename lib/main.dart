import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_wrapper.dart';

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
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'သင်ကြားရေး App',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          useMaterial3: true,

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0), // နက်နက်ရှိုင်းရှိုင်း အပြာ
            primary: const Color(0xFF1565C0),
            secondary: const Color(0xFF42A5F5),
            tertiary: const Color(0xFFFFCA28),
            brightness: Brightness.light,
            surface: const Color(0xFFFAFDFF),
            background: const Color(0xFFFAFDFF),
          ),

          scaffoldBackgroundColor: const Color(0xFFFAFDFF),

          textTheme: GoogleFonts.notoSansMyanmarTextTheme(
            Theme.of(context).textTheme,
          ).copyWith(
            headlineMedium: GoogleFonts.notoSansMyanmar(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
            titleLarge: GoogleFonts.notoSansMyanmar(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            bodyLarge: GoogleFonts.notoSansMyanmar(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
            labelLarge: GoogleFonts.notoSansMyanmar(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          cardTheme: CardThemeData(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            surfaceTintColor: Colors.transparent,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              elevation: 3,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: GoogleFonts.notoSansMyanmar(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.15)),
            ),
          ),

          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            titleTextStyle: GoogleFonts.notoSansMyanmar(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            centerTitle: true,
            shape: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            labelStyle: GoogleFonts.notoSansMyanmar(color: Colors.black54),
          ),
        ),

        home: const AuthWrapper().animate().fadeIn(
          duration: 800.ms,
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}
