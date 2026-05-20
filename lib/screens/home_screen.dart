import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/difficulty.dart';
import '../widgets/asset_background.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/primary_action_button.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Difficulty _selectedDifficulty = Difficulty.medium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AssetBackground(
        asset: 'assets/images/backgrounds/home_background.png',
        overlayColor: AppTheme.ink.withValues(alpha: 0.28),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Memory Match',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontSize: constraints.maxWidth < 420 ? 38 : 54,
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Northern Adventure',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        DifficultySelector(
                          selectedDifficulty: _selectedDifficulty,
                          onChanged: (difficulty) {
                            setState(() => _selectedDifficulty = difficulty);
                          },
                        ),
                        const SizedBox(height: 28),
                        Align(
                          alignment: Alignment.center,
                          child: PrimaryActionButton(
                            label: 'Start Game',
                            icon: Icons.play_arrow_rounded,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => GameScreen(
                                    difficulty: _selectedDifficulty,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
