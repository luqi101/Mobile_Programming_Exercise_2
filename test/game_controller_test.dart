import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:memory_matching_flutter_game/controllers/game_controller.dart';
import 'package:memory_matching_flutter_game/models/difficulty.dart';
import 'package:memory_matching_flutter_game/utils/scoring.dart';

void main() {
  GameController buildController({
    Difficulty difficulty = Difficulty.medium,
    Duration mismatchDelay = Duration.zero,
  }) {
    return GameController(
      difficulty: difficulty,
      random: math.Random(7),
      mismatchDelay: mismatchDelay,
      startTimer: false,
    );
  }

  List<int> matchingIndexes(GameController controller) {
    for (var i = 0; i < controller.cards.length; i += 1) {
      for (var j = i + 1; j < controller.cards.length; j += 1) {
        if (controller.cards[i].pairId == controller.cards[j].pairId) {
          return [i, j];
        }
      }
    }
    throw StateError('No matching pair found');
  }

  List<int> nonMatchingIndexes(GameController controller) {
    for (var i = 0; i < controller.cards.length; i += 1) {
      for (var j = i + 1; j < controller.cards.length; j += 1) {
        if (controller.cards[i].pairId != controller.cards[j].pairId) {
          return [i, j];
        }
      }
    }
    throw StateError('No non-matching pair found');
  }

  test('generates the correct card count for every difficulty', () {
    for (final difficulty in Difficulty.values) {
      final controller = buildController(difficulty: difficulty);
      addTearDown(controller.dispose);

      expect(controller.cards, hasLength(difficulty.cardCount));
      expect(controller.totalPairs, difficulty.pairCount);
    }
  });

  test('generates exactly two cards for every pair', () {
    final controller = buildController(difficulty: Difficulty.hard);
    addTearDown(controller.dispose);

    final counts = <String, int>{};
    for (final card in controller.cards) {
      counts.update(card.pairId, (value) => value + 1, ifAbsent: () => 1);
    }

    expect(counts, hasLength(Difficulty.hard.pairCount));
    expect(counts.values, everyElement(2));
  });

  test('matching pair stays revealed and increments matched count', () async {
    final controller = buildController(difficulty: Difficulty.easy);
    addTearDown(controller.dispose);
    final indexes = matchingIndexes(controller);

    await controller.revealCard(indexes.first);
    await controller.revealCard(indexes.last);

    expect(controller.moves, 1);
    expect(controller.matchedPairs, 1);
    expect(controller.cards[indexes.first].isFaceUp, isTrue);
    expect(controller.cards[indexes.last].isFaceUp, isTrue);
    expect(controller.cards[indexes.first].isMatched, isTrue);
    expect(controller.cards[indexes.last].isMatched, isTrue);
  });

  test('non-matching pair flips back after delay', () async {
    final controller = buildController(
      difficulty: Difficulty.easy,
      mismatchDelay: const Duration(milliseconds: 10),
    );
    addTearDown(controller.dispose);
    final indexes = nonMatchingIndexes(controller);

    await controller.revealCard(indexes.first);
    final pending = controller.revealCard(indexes.last);

    expect(controller.moves, 1);
    expect(controller.isInputLocked, isTrue);
    expect(controller.cards[indexes.first].isFaceUp, isTrue);
    expect(controller.cards[indexes.last].isFaceUp, isTrue);

    await pending;

    expect(controller.isInputLocked, isFalse);
    expect(controller.cards[indexes.first].isFaceUp, isFalse);
    expect(controller.cards[indexes.last].isFaceUp, isFalse);
    expect(controller.matchedPairs, 0);
  });

  test('invalid taps are ignored during mismatch delay', () async {
    final controller = buildController(
      difficulty: Difficulty.medium,
      mismatchDelay: const Duration(milliseconds: 10),
    );
    addTearDown(controller.dispose);
    final indexes = nonMatchingIndexes(controller);
    final extraIndex = controller.cards.indexWhere(
      (card) =>
          card.id != controller.cards[indexes.first].id &&
          card.id != controller.cards[indexes.last].id,
    );

    await controller.revealCard(indexes.first);
    final pending = controller.revealCard(indexes.last);
    await controller.revealCard(extraIndex);

    expect(controller.moves, 1);
    expect(controller.selectedCount, 0);
    expect(controller.cards[extraIndex].isFaceUp, isFalse);

    await pending;
  });

  test('same card cannot be selected twice as a pair', () async {
    final controller = buildController(difficulty: Difficulty.easy);
    addTearDown(controller.dispose);

    await controller.revealCard(0);
    await controller.revealCard(0);

    expect(controller.selectedCount, 1);
    expect(controller.moves, 0);
  });

  test('move counter increments once per two-card attempt', () async {
    final controller = buildController(difficulty: Difficulty.easy);
    addTearDown(controller.dispose);
    final indexes = matchingIndexes(controller);

    await controller.revealCard(indexes.first);
    expect(controller.moves, 0);

    await controller.revealCard(indexes.last);
    expect(controller.moves, 1);
  });

  test('restart resets game state and can change difficulty', () async {
    final controller = buildController(difficulty: Difficulty.easy);
    addTearDown(controller.dispose);

    await controller.revealCard(0);
    controller.startNewGame(Difficulty.hard);

    expect(controller.difficulty, Difficulty.hard);
    expect(controller.cards, hasLength(Difficulty.hard.cardCount));
    expect(controller.moves, 0);
    expect(controller.matchedPairs, 0);
    expect(controller.elapsedTime, Duration.zero);
    expect(controller.isInputLocked, isFalse);
    expect(controller.selectedCount, 0);
    expect(controller.result, isNull);
    expect(
      controller.cards.every((card) => !card.isFaceUp && !card.isMatched),
      isTrue,
    );
  });

  test('stale mismatch delay cannot corrupt a restarted game', () async {
    final controller = buildController(
      difficulty: Difficulty.easy,
      mismatchDelay: const Duration(milliseconds: 10),
    );
    addTearDown(controller.dispose);
    final indexes = nonMatchingIndexes(controller);

    await controller.revealCard(indexes.first);
    final pending = controller.revealCard(indexes.last);
    controller.startNewGame();
    await pending;

    expect(controller.moves, 0);
    expect(controller.isInputLocked, isFalse);
    expect(
      controller.cards.every((card) => !card.isFaceUp && !card.isMatched),
      isTrue,
    );
  });

  test('win condition creates a complete game result', () async {
    final controller = buildController(difficulty: Difficulty.easy);
    addTearDown(controller.dispose);

    while (!controller.isComplete) {
      final firstIndex = controller.cards.indexWhere((card) => !card.isMatched);
      final pairId = controller.cards[firstIndex].pairId;
      final secondIndex = controller.cards.indexWhere(
        (card) =>
            card.pairId == pairId && card.id != controller.cards[firstIndex].id,
      );
      await controller.revealCard(firstIndex);
      await controller.revealCard(secondIndex);
    }

    expect(controller.matchedPairs, Difficulty.easy.pairCount);
    expect(controller.moves, Difficulty.easy.pairCount);
    expect(controller.result, isNotNull);
    expect(controller.result!.score, greaterThan(0));
    expect(
      controller.result!.score,
      calculateScore(
        difficulty: Difficulty.easy,
        elapsedTime: Duration.zero,
        moves: Difficulty.easy.pairCount,
      ),
    );
  });

  test('score calculation is deterministic and rewards efficiency', () {
    final efficientScore = calculateScore(
      difficulty: Difficulty.easy,
      elapsedTime: const Duration(seconds: 30),
      moves: 6,
    );
    final slowerScore = calculateScore(
      difficulty: Difficulty.easy,
      elapsedTime: const Duration(seconds: 30),
      moves: 10,
    );

    expect(efficientScore, 3616);
    expect(slowerScore, lessThan(efficientScore));
  });
}
