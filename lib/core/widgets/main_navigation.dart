import 'package:flutter/material.dart';
import '../../modules/teacher/presenter/pages/teacher_dashboard_page.dart';
import '../../modules/trilhas/presenter/pages/trilhas_page.dart';
import '../../modules/humor/presenter/pages/humor_page.dart';
import '../../modules/vowel_game/presenter/pages/vowel_game_screen.dart';
import '../../modules/jogos/presenter/pages/jogos_menu_page.dart';

/// Widget principal de navegação com bottom navigation bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Lista das páginas disponíveis
  static final List<Widget> _pages = <Widget>[
    const TeacherDashboardPage(),
    const TrilhasPage(),
    const HumorPage(),
    const VowelGameScreen(),
    const JogosMenuPage(),
  ];

  // Lista dos itens da bottom navigation
  static const List<BottomNavigationBarItem> _navItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'Trilhas',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mood),
      label: 'Humor',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.abc),
      label: 'Vogais',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.games),
      label: 'Jogos',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}