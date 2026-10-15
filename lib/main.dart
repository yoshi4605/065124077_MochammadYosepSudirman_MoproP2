import 'dart:ui';
import 'package:flutter/material.dart';
import 'data/app_state.dart';
import 'screens/halaman_menu.dart';

void main() {
  runApp(const KantinBuSari());
}

class KantinScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class KantinBuSari extends StatelessWidget {
  const KantinBuSari({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isDark = AppState.instance.isDarkMode;

        return MaterialApp(
          title: 'Kantin Bu Sari',
          debugShowCheckedModeBanner: false,
          scrollBehavior: KantinScrollBehavior(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2C3E50),
              primary: const Color(0xFF2C3E50),
              secondary: const Color(0xFFE74C3C),
              surface: Colors.white,
              brightness: Brightness.light,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Color(0xFF1A1A1A)),
              bodyLarge: TextStyle(color: Color(0xFF1A1A1A)),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2C3E50),
              primary: const Color(0xFF34495E),
              secondary: const Color(0xFFE74C3C),
              surface: const Color(0xFF1E1E1E),
              brightness: Brightness.dark,
            ),
          ),
          home: const HalamanMenu(),
        );
      },
    );
  }
}
