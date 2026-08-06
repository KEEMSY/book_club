import 'package:book_club/core/layout/web_navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({required int selectedIndex, required void Function(int) onSel}) {
    return MaterialApp(
      home: MediaQuery(
        // Extended (desktop) width so the rail renders labels alongside icons.
        data: const MediaQueryData(size: Size(1200, 800)),
        child: Scaffold(
          body: WebNavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSel,
          ),
        ),
      ),
    );
  }

  // Guards BC-79: 검색(book search) is MVP core and must stay in the rail
  // regardless of the deferred discovery flag. Before the fix the middle slot
  // was 탐색 gated behind FeatureFlags.discovery (off) → no search entry point.
  testWidgets('rail shows the 검색 tab at index 1, never 탐색', (tester) async {
    await tester.pumpWidget(host(selectedIndex: 0, onSel: (_) {}));
    await tester.pumpAndSettle();

    expect(find.text('검색'), findsOneWidget);
    expect(find.text('탐색'), findsNothing);
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('서재'), findsOneWidget);
  });

  testWidgets('tapping 검색 selects branch index 1', (tester) async {
    int? tapped;
    await tester.pumpWidget(host(selectedIndex: 0, onSel: (i) => tapped = i));
    await tester.pumpAndSettle();

    await tester.tap(find.text('검색'));
    await tester.pumpAndSettle();

    expect(tapped, 1);
  });
}
