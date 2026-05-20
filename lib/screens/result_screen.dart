import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/game_result.dart';
import '../utils/formatters.dart';
import '../widgets/asset_background.dart';
import '../widgets/primary_action_button.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({required this.result, super.key});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AssetBackground(
        asset: 'assets/images/backgrounds/home_background.png',
        overlayColor: AppTheme.ink.withValues(alpha: 0.34),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.96),
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: AppTheme.gold,
                          size: 54,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Trail Complete',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          result.difficulty.displayName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.deepTeal,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _ResultStat(
                              icon: Icons.timer_outlined,
                              label: 'Time',
                              value: formatDuration(result.elapsedTime),
                            ),
                            _ResultStat(
                              icon: Icons.ads_click,
                              label: 'Moves',
                              value: result.moves.toString(),
                            ),
                            _ResultStat(
                              icon: Icons.auto_awesome,
                              label: 'Pairs',
                              value:
                                  '${result.matchedPairs}/${result.totalPairs}',
                            ),
                            _ResultStat(
                              icon: Icons.stars,
                              label: 'Score',
                              value: formatScore(result.score),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            PrimaryActionButton(
                              label: 'Play Again',
                              icon: Icons.replay,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => GameScreen(
                                      difficulty: result.difficulty,
                                    ),
                                  ),
                                );
                              },
                            ),
                            PrimaryActionButton(
                              label: 'Home',
                              icon: Icons.home_outlined,
                              isPrimary: false,
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 126,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.mist,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.seaGlass.withValues(alpha: 0.45)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.deepTeal),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppTheme.ink.withValues(alpha: 0.62),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
