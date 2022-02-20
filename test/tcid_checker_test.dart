import 'package:logbox_color/extensions.dart';
import 'package:tcid_checker/tcid_checker.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('Skip real Citizen ID', () {
      expect(controlID("02345678982", false, false, LogLevel.debug), isFalse);
      expect(controlID("02345678982", true, false, LogLevel.debug), isTrue);
    });
    test('All of False', () {
      expect(controlID("11111111111", false, true, LogLevel.debug), isFalse);
      expect(controlID("12345678912", false, true, LogLevel.debug), isFalse);
    });

    test('Less than 11 digits', () {
      expect(controlID("111111111", false, true, LogLevel.debug), isFalse);
      expect(controlID("123456789", false, true, LogLevel.debug), isFalse);
    });

    test('More than 11 digits', () {
      expect(controlID("11111111111111", false, true, LogLevel.debug), isFalse);
      expect(
          controlID("123456789122222", false, true, LogLevel.debug), isFalse);
    });

    test('Validate', () async {
      expect(
          await validateID(
              "11111111111", "ali", "veli", 1991, false, LogLevel.debug),
          isFalse);
      expect(
          await validateForeignID("11111111111", "jack", "delay", 1, 1, 1900,
              false, LogLevel.debug),
          isFalse);
      expect(
          await validatePersonAndCard(
              "11111111111",
              "ali",
              "veli",
              false,
              1,
              false,
              1,
              false,
              1900,
              'a15',
              796544,
              'y02n45764',
              false,
              LogLevel.debug),
          isFalse);
    });
  });
}
