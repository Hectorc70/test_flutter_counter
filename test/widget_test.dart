// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:test_flutter_counter/main.dart';

void main() {
  test('Prueba de text input vacio', () {
    final result = validateInputs('');
    expect(result, 'Ingrese datos');
  });

  test('Prueba de text input mayor a 60', () {
    final result = validateInputs('121');
    expect(result, 'Intente con menor a 60');
  });
  test('Prueba de text input no es numero', () {
    final result = validateInputs('-');
    expect(result, '"-" no es un numero');
  });
}
