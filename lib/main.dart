import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'modules/word_game/providers/word_game_provider.dart';
import 'modules/teacher/providers/teacher_dashboard_provider.dart';
import 'modules/trilhas/providers/trilhas_provider.dart';
import 'modules/humor/providers/humor_provider.dart';
import 'modules/vowel_game/providers/vowel_game_provider.dart';
import 'modules/syllable_game/providers/syllable_game_provider.dart';
import 'modules/ble/services/ble_service.dart';
import 'core/services/audio_service.dart';
import 'core/widgets/main_navigation.dart';
import 'core/widgets/ble_connection_splash.dart';

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

    ChangeNotifierProvider<TrilhasProvider>(
      create: (_) {
        debugPrint('Creating TrilhasProvider...');
        return TrilhasProvider();
      },
    ),

    ChangeNotifierProvider<HumorProvider>(
      create: (_) {
        debugPrint('Creating HumorProvider...');
        return HumorProvider();
      },
    ),

    Provider<BleService>(
      create: (_) {
        debugPrint('Creating BleService...');
        return BleService();
      },
    ),

    Provider<AudioService>(
      create: (_) {
        debugPrint('Creating AudioService...');
        return AudioService();
      },
    ),

    ChangeNotifierProvider<VowelGameProvider>(
      create: (context) {
        final bleService = Provider.of<BleService>(context, listen: false);
        debugPrint('Creating VowelGameProvider...');
        return VowelGameProvider(bleService);
      },
    ),

    ChangeNotifierProvider<SyllableGameProvider>(
      create: (context) {
        final bleService = Provider.of<BleService>(context, listen: false);
        debugPrint('Creating SyllableGameProvider...');
        return SyllableGameProvider(bleService);
      },
    ),
  ],
      child: MaterialApp(
        title: 'Educare',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.teacherTheme,
        home: BleConnectionSplash(
          nextScreen: const MainNavigation(),
        ),
      ),
    );
  }
}
