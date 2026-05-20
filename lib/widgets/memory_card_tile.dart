import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/memory_card.dart';

class MemoryCardTile extends StatelessWidget {
  const MemoryCardTile({required this.card, required this.onTap, super.key});

  static const cardBackAsset = 'assets/images/cards/card_back.png';

  final MemoryCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final showFront = card.isFaceUp || card.isMatched;

    return RepaintBoundary(
      child: Semantics(
        button: true,
        label: showFront ? '${card.title} card' : 'Hidden card',
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: showFront ? 1 : 0),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOutCubic,
          builder: (context, value, child) {
            final isShowingFront = value >= 0.5;
            final rotation = isShowingFront
                ? (value - 1) * math.pi
                : value * math.pi;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(rotation),
              child: _CardSurface(
                key: ValueKey('${card.id}-$isShowingFront-${card.isMatched}'),
                card: card,
                isFront: isShowingFront,
                onTap: onTap,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({
    required this.card,
    required this.isFront,
    required this.onTap,
    super.key,
  });

  final MemoryCard card;
  final bool isFront;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: card.isMatched ? 2 : 6,
      shadowColor: Colors.black.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              isFront ? card.imageAsset : MemoryCardTile.cardBackAsset,
              fit: BoxFit.cover,
              cacheWidth: 360,
              filterQuality: FilterQuality.medium,
            ),
            if (isFront)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.48),
                    ],
                  ),
                ),
              ),
            if (isFront)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    card.title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            if (card.isMatched)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppTheme.gold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: AppTheme.ink, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
