import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/difficulty.dart';
import '../utils/formatters.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({
    required this.difficulty,
    required this.elapsedTime,
    required this.moves,
    required this.matchedPairs,
    required this.totalPairs,
    required this.onRestart,
    required this.onNewGame,
    super.key,
  });

  final Difficulty difficulty;
  final Duration elapsedTime;
  final int moves;
  final int matchedPairs;
  final int totalPairs;
  final VoidCallback onRestart;
  final VoidCallback onNewGame;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white.withValues(alpha: 0.93),
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${difficulty.displayName} Match',
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: 'Restart',
                  onPressed: onRestart,
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: 'New game',
                  onPressed: onNewGame,
                  icon: const Icon(Icons.home_outlined),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _HeaderStat(
                  icon: Icons.timer_outlined,
                  label: 'Time',
                  value: formatDuration(elapsedTime),
                ),
                _HeaderStat(
                  icon: Icons.ads_click,
                  label: 'Moves',
                  value: moves.toString(),
                ),
                _HeaderStat(
                  icon: Icons.auto_awesome,
                  label: 'Pairs',
                  value: '$matchedPairs/$totalPairs',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
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
      constraints: const BoxConstraints(minWidth: 106),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.mist,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.seaGlass.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.deepTeal, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.ink.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
