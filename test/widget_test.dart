// Testes básicos da aplicação HabitQuest

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aghg_alunos_27639_27640_27653/main.dart';

void main() {
  testWidgets('HabitQuest app starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verificar que a app inicia
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Bottom navigation bar has 4 items', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verificar que existem 4 itens na bottom navigation
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
