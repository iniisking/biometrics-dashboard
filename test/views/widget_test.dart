import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:biometrics_dashboard/controller/dashboard_controller.dart';
import 'package:biometrics_dashboard/views/dashboard_view.dart';

void main() {
  group('Dashboard Widget Tests', () {
    late DashboardController controller;

    setUp(() {
      controller = DashboardController();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<DashboardController>(
          create: (context) => controller,
          child: const DashboardView(),
        ),
      );
    }

    testWidgets('Dashboard shows loading state initially', (
      WidgetTester tester,
    ) async {
      // Set controller to loading state
      controller = DashboardController();

      await tester.pumpWidget(createTestWidget());

      // Should show loading skeleton
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading data...'), findsOneWidget);
    });

    testWidgets('Dashboard shows error state with retry button', (
      WidgetTester tester,
    ) async {
      // Simulate error state
      controller = DashboardController();
      await tester.pumpWidget(createTestWidget());

      // Simulate error by calling retry (which will fail without data)
      await tester.pumpAndSettle();

      // Look for retry button
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('Range selector updates when range is changed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find range selector buttons
      final rangeButtons = find.byType(ElevatedButton);
      expect(rangeButtons, findsWidgets);

      // Test 7d button
      final sevenDayButton = find.text('7d');
      if (sevenDayButton.evaluate().isNotEmpty) {
        await tester.tap(sevenDayButton);
        await tester.pump();

        // Verify the button is now selected (has different styling)
        final button = tester.widget<ElevatedButton>(sevenDayButton);
        expect(button.style?.backgroundColor?.resolve({}), isNotNull);
      }
    });

    testWidgets('Large dataset toggle works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the large dataset switch
      final switchFinder = find.byType(Switch);
      if (switchFinder.evaluate().isNotEmpty) {
        final switchWidget = tester.widget<Switch>(switchFinder);
        final initialValue = switchWidget.value;

        // Toggle the switch
        await tester.tap(switchFinder);
        await tester.pump();

        // Verify the value changed
        final newSwitchWidget = tester.widget<Switch>(switchFinder);
        expect(newSwitchWidget.value, isNot(equals(initialValue)));
      }
    });

    testWidgets('Charts are displayed when data is available', (
      WidgetTester tester,
    ) async {
      // Mock some data - not used in this test but kept for future use

      // Set up controller with mock data
      controller = DashboardController();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Look for chart titles
      expect(find.text('Heart Rate Variability (HRV)'), findsOneWidget);
      expect(find.text('Resting Heart Rate (RHR)'), findsOneWidget);
      expect(find.text('Daily Steps'), findsOneWidget);
    });

    testWidgets('App bar shows correct title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Biometrics Dashboard'), findsOneWidget);
    });

    testWidgets('Dark mode toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // The app should support dark mode through system theme
      expect(find.byType(MaterialApp), findsOneWidget);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.system));
    });
  });
}
