import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/difficulty.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({
    required this.selectedDifficulty,
    required this.onChanged,
    super.key,
  });

  final Difficulty selectedDifficulty;
  final ValueChanged<Difficulty> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: Difficulty.values.map((difficulty) {
        final isSelected = difficulty == selectedDifficulty;
        return _DifficultyOption(
          difficulty: difficulty,
          isSelected: isSelected,
          onTap: () => onChanged(difficulty),
        );
      }).toList(),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  const _DifficultyOption({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected ? AppTheme.ember : Colors.white;

    return SizedBox(
      width: 168,
      child: Material(
        color: Colors.white.withValues(alpha: isSelected ? 0.98 : 0.9),
        elevation: isSelected ? 8 : 3,
        shadowColor: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.circle_outlined,
                      color: isSelected ? AppTheme.ember : AppTheme.deepTeal,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        difficulty.displayName,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  difficulty.accentLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.ink.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${difficulty.cardCount} cards',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.ink.withValues(alpha: 0.64),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
