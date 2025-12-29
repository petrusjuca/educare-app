import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modules/word_game/providers/word_game_provider.dart';
import 'modules/word_game/presenter/pages/intro_page/intro_page.dart';

void main() {
  debugPrint('Starting application...');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MainApp...');
    return MultiProvider(
  providers: [
    ChangeNotifierProvider<WordGameProvider>(
      create: (_) {
        debugPrint('Creating WordGameProvider...');
        return WordGameProvider();
      },
    ),

    ChangeNotifierProvider<TeacherDashboardProvider>(
      create: (_) {
        debugPrint('Creating TeacherDashboardProvider...');
        return TeacherDashboardProvider();
      },
    ),
  ],
      child: MaterialApp(
        title: 'Educare - Aprendendo Vogais',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.fredokaTextTheme(),
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) {
            debugPrint('Building IntroPage...');
            return const IntroPage();
          },
        ),
      ),
    );
  }
}
