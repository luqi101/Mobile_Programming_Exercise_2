enum Difficulty {
  easy(
    displayName: 'Easy',
    pairCount: 4,
    accentLabel: '4 pairs',
    targetMoves: 6,
  ),
  medium(
    displayName: 'Medium',
    pairCount: 6,
    accentLabel: '6 pairs',
    targetMoves: 10,
  ),
  hard(
    displayName: 'Hard',
    pairCount: 8,
    accentLabel: '8 pairs',
    targetMoves: 14,
  );

  const Difficulty({
    required this.displayName,
    required this.pairCount,
    required this.accentLabel,
    required this.targetMoves,
  });

  final String displayName;
  final int pairCount;
  final String accentLabel;
  final int targetMoves;

  int get cardCount => pairCount * 2;
}
