import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_matching_flutter_game/app/memory_match_app.dart';
import 'package:memory_matching_flutter_game/widgets/memory_card_tile.dart';

void main() {
  testWidgets('app launches to home screen with difficulty selector', (
    tester,
  ) async {
    await tester.pumpWidget(const MemoryMatchApp());
    await tester.pumpAndSettle();

    expect(find.text('Memory Match'), findsOneWidget);
    expect(find.text('Northern Adventure'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
  });

  testWidgets('selecting difficulty and starting game shows header and grid', (
    tester,
  ) async {
    await tester.pumpWidget(const MemoryMatchApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Easy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    expect(find.text('Easy Match'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Moves'), findsOneWidget);
    expect(find.text('Pairs'), findsOneWidget);
    expect(find.byKey(const ValueKey('memory-card-grid')), findsOneWidget);
    expect(find.byType(MemoryCardTile), findsNWidgets(8));
    expect(find.byTooltip('Restart'), findsOneWidget);

    await tester.tap(find.byTooltip('Restart'));
    await tester.pumpAndSettle();
    expect(find.byType(MemoryCardTile), findsNWidgets(8));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
