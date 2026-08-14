import 'package:flutter/material.dart';

import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/level_select_screen.dart';
import 'theme/palette.dart';

class FlowerFieldApp extends StatelessWidget {
  const FlowerFieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '一笔花田',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Palette.pink,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Palette.cream,
        appBarTheme: const AppBarTheme(
          backgroundColor: Palette.cream,
          foregroundColor: Palette.ink,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        LevelSelectScreen.route: (_) => const LevelSelectScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == GameScreen.route) {
          final levelId = settings.arguments as int;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => GameScreen(levelId: levelId),
          );
        }
        return null;
      },
    );
  }
}