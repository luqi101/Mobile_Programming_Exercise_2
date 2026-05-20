import 'package:flutter/material.dart';

import '../models/difficulty.dart';
import '../models/memory_card.dart';
import 'memory_card_tile.dart';

class ResponsiveGameGrid extends StatelessWidget {
  const ResponsiveGameGrid({
    required this.cards,
    required this.difficulty,
    required this.onCardTap,
    super.key,
  });

  final List<MemoryCard> cards;
  final Difficulty difficulty;
  final ValueChanged<int> onCardTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = _columnsFor(width, difficulty);
        final spacing = width < 420 ? 8.0 : 12.0;

        return GridView.builder(
          key: const ValueKey('memory-card-grid'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            return MemoryCardTile(
              key: ValueKey(cards[index].id),
              card: cards[index],
              onTap: () => onCardTap(index),
            );
          },
        );
      },
    );
  }

  int _columnsFor(double width, Difficulty difficulty) {
    if (width >= 900) {
      return switch (difficulty) {
        Difficulty.easy => 4,
        Difficulty.medium => 6,
        Difficulty.hard => 8,
      };
    }

    if (width >= 560) {
      return switch (difficulty) {
        Difficulty.easy => 4,
        Difficulty.medium => 4,
        Difficulty.hard => 4,
      };
    }

    return switch (difficulty) {
      Difficulty.easy => 2,
      Difficulty.medium => 3,
      Difficulty.hard => 4,
    };
  }
}
