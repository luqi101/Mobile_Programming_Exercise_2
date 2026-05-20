class MemoryCard {
  MemoryCard({
    required this.id,
    required this.pairId,
    required this.title,
    required this.imageAsset,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  final String id;
  final String pairId;
  final String title;
  final String imageAsset;
  bool isFaceUp;
  bool isMatched;
}
