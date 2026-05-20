import 'dart:math' as math;

import '../models/difficulty.dart';

int calculateScore({
  required Difficulty difficulty,
  required Duration elapsedTime,
  required int moves,
}) {
  final base = difficulty.pairCount * 1000;
  final timePenalty = elapsedTime.inSeconds * 8;
  final movePenalty = moves * 24;
  final efficiencyBonus = math.max(0, difficulty.targetMoves - moves) * 90;
  return math.max(100, base + efficiencyBonus - timePenalty - movePenalty);
}
