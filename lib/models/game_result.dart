import 'difficulty.dart';

class GameResult {
  const GameResult({
    required this.difficulty,
    required this.elapsedTime,
    required this.moves,
    required this.matchedPairs,
    required this.totalPairs,
    required this.score,
  });

  final Difficulty difficulty;
  final Duration elapsedTime;
  final int moves;
  final int matchedPairs;
  final int totalPairs;
  final int score;
}
