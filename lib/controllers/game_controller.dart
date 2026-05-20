import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../models/difficulty.dart';
import '../models/game_result.dart';
import '../models/memory_card.dart';
import '../utils/scoring.dart';

class CardFaceDefinition {
  const CardFaceDefinition({
    required this.pairId,
    required this.title,
    required this.imageAsset,
  });

  final String pairId;
  final String title;
  final String imageAsset;
}

class GameController extends ChangeNotifier {
  GameController({
    required Difficulty difficulty,
    math.Random? random,
    this.mismatchDelay = const Duration(milliseconds: 720),
    bool startTimer = true,
  }) : _difficulty = difficulty,
       _random = random ?? math.Random(),
       _startTimerAutomatically = startTimer {
    startNewGame(difficulty);
  }

  static const List<CardFaceDefinition> faceDefinitions = [
    CardFaceDefinition(
      pairId: 'aurora',
      title: 'Aurora',
      imageAsset: 'assets/images/cards/card_aurora.png',
    ),
    CardFaceDefinition(
      pairId: 'canoe',
      title: 'Canoe',
      imageAsset: 'assets/images/cards/card_canoe.png',
    ),
    CardFaceDefinition(
      pairId: 'compass',
      title: 'Compass',
      imageAsset: 'assets/images/cards/card_compass.png',
    ),
    CardFaceDefinition(
      pairId: 'lantern',
      title: 'Lantern',
      imageAsset: 'assets/images/cards/card_lantern.png',
    ),
    CardFaceDefinition(
      pairId: 'lake',
      title: 'Lake',
      imageAsset: 'assets/images/cards/card_lake.png',
    ),
    CardFaceDefinition(
      pairId: 'mountain',
      title: 'Mountain',
      imageAsset: 'assets/images/cards/card_mountain.png',
    ),
    CardFaceDefinition(
      pairId: 'pine',
      title: 'Pine',
      imageAsset: 'assets/images/cards/card_pine.png',
    ),
    CardFaceDefinition(
      pairId: 'star',
      title: 'Star',
      imageAsset: 'assets/images/cards/card_star.png',
    ),
  ];

  Difficulty _difficulty;
  final math.Random _random;
  final Duration mismatchDelay;
  final bool _startTimerAutomatically;
  final List<int> _selectedIndexes = [];

  List<MemoryCard> _cards = [];
  final ValueNotifier<int> cardsRevision = ValueNotifier<int>(0);
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  int _moves = 0;
  int _matchedPairs = 0;
  int _generation = 0;
  bool _isInputLocked = false;
  bool _isComplete = false;
  bool _disposed = false;
  GameResult? _result;

  Difficulty get difficulty => _difficulty;
  List<MemoryCard> get cards => List.unmodifiable(_cards);
  Duration get elapsedTime => _elapsedTime;
  int get moves => _moves;
  int get matchedPairs => _matchedPairs;
  int get totalPairs => _difficulty.pairCount;
  bool get isInputLocked => _isInputLocked;
  bool get isComplete => _isComplete;
  GameResult? get result => _result;
  int get selectedCount => _selectedIndexes.length;

  void startNewGame([Difficulty? difficulty]) {
    _generation += 1;
    _timer?.cancel();
    _difficulty = difficulty ?? _difficulty;
    _cards = _buildDeck(_difficulty);
    _selectedIndexes.clear();
    _elapsedTime = Duration.zero;
    _moves = 0;
    _matchedPairs = 0;
    _isInputLocked = false;
    _isComplete = false;
    _result = null;
    if (_startTimerAutomatically) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_isComplete || _disposed) {
          return;
        }
        _elapsedTime += const Duration(seconds: 1);
        notifyListeners();
      });
    }
    _notifyCardsChanged();
    notifyListeners();
  }

  Future<void> revealCard(int index) async {
    if (!_canReveal(index)) {
      return;
    }

    _cards[index].isFaceUp = true;
    _selectedIndexes.add(index);
    _notifyCardsChanged();
    notifyListeners();

    if (_selectedIndexes.length < 2) {
      return;
    }

    _moves += 1;
    final pendingIndexes = List<int>.from(_selectedIndexes);
    _selectedIndexes.clear();
    final first = _cards[pendingIndexes.first];
    final second = _cards[pendingIndexes.last];

    if (first.pairId == second.pairId) {
      first.isMatched = true;
      second.isMatched = true;
      _matchedPairs += 1;
      if (_matchedPairs == _difficulty.pairCount) {
        _finishGame();
      }
      _notifyCardsChanged();
      notifyListeners();
      return;
    }

    _isInputLocked = true;
    final generationAtMismatch = _generation;
    notifyListeners();

    await Future<void>.delayed(mismatchDelay);
    if (_disposed || generationAtMismatch != _generation) {
      return;
    }

    for (final cardIndex in pendingIndexes) {
      final card = _cards[cardIndex];
      if (!card.isMatched) {
        card.isFaceUp = false;
      }
    }
    _isInputLocked = false;
    _notifyCardsChanged();
    notifyListeners();
  }

  bool _canReveal(int index) {
    if (_isComplete || _isInputLocked || index < 0 || index >= _cards.length) {
      return false;
    }
    final card = _cards[index];
    return !card.isFaceUp && !card.isMatched;
  }

  List<MemoryCard> _buildDeck(Difficulty difficulty) {
    final selectedFaces = faceDefinitions.take(difficulty.pairCount);
    final cards = <MemoryCard>[];

    for (final face in selectedFaces) {
      cards
        ..add(
          MemoryCard(
            id: '${face.pairId}-a',
            pairId: face.pairId,
            title: face.title,
            imageAsset: face.imageAsset,
          ),
        )
        ..add(
          MemoryCard(
            id: '${face.pairId}-b',
            pairId: face.pairId,
            title: face.title,
            imageAsset: face.imageAsset,
          ),
        );
    }

    cards.shuffle(_random);
    return cards;
  }

  void _finishGame() {
    _isComplete = true;
    _isInputLocked = false;
    _timer?.cancel();
    _timer = null;
    _result = GameResult(
      difficulty: _difficulty,
      elapsedTime: _elapsedTime,
      moves: _moves,
      matchedPairs: _matchedPairs,
      totalPairs: _difficulty.pairCount,
      score: calculateScore(
        difficulty: _difficulty,
        elapsedTime: _elapsedTime,
        moves: _moves,
      ),
    );
  }

  void _notifyCardsChanged() {
    cardsRevision.value += 1;
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    cardsRevision.dispose();
    super.dispose();
  }
}
