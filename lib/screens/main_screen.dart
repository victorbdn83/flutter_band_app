import 'package:flutter/material.dart';
import 'package:my_audio_flutter/views/home_page.dart';
import 'package:my_audio_flutter/views/recorder_page.dart';
import 'package:my_audio_flutter/views/songs.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final screens = [const HomeView(), const RecorderView(), const SongsView()];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 6,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            //activeIcon: const Icon(Icons.motorcycle),
            label: 'Home',
            backgroundColor: colors.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fiber_manual_record),
            //activeIcon: const Icon(Icons.person_3),
            label: 'REC',
            backgroundColor: colors.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.music_note),
            //activeIcon: const Icon(Icons.settings),
            label: 'Songs',
            backgroundColor: colors.primary,
          ),
        ],
      ),
    );
  }
}