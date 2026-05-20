import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../models/difficulty.dart';
import '../widgets/asset_background.dart';
import '../widgets/game_header.dart';
import '../widgets/responsive_game_grid.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({required this.difficulty, super.key});

  final Difficulty difficulty;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  bool _resultPresented = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController(difficulty: widget.difficulty)
      ..addListener(_handleControllerUpdate);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerUpdate)
      ..dispose();
    super.dispose();
  }

  void _handleControllerUpdate() {
    final result = _controller.result;
    if (result == null || _resultPresented || !mounted) {
      return;
    }

    _resultPresented = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => ResultScreen(result: result)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AssetBackground(
        asset: 'assets/images/backgrounds/game_background.png',
        overlayColor: Colors.white.withValues(alpha: 0.2),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 500
                  ? 12.0
                  : 20.0;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  14,
                  horizontalPadding,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListenableBuilder(
                          listenable: _controller,
                          builder: (context, _) {
                            return GameHeader(
                              difficulty: _controller.difficulty,
                              elapsedTime: _controller.elapsedTime,
                              moves: _controller.moves,
                              matchedPairs: _controller.matchedPairs,
                              totalPairs: _controller.totalPairs,
                              onRestart: () {
                                _resultPresented = false;
                                _controller.startNewGame();
                              },
                              onNewGame: () => Navigator.of(context).pop(),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        RepaintBoundary(
                          child: ValueListenableBuilder<int>(
                            valueListenable: _controller.cardsRevision,
                            builder: (context, _, child) {
                              return ResponsiveGameGrid(
                                cards: _controller.cards,
                                difficulty: _controller.difficulty,
                                onCardTap: _controller.revealCard,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
