import 'package:tcid_checker/tcid_checker.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('All of False', () {
      expect(controlID(11111111111), isFalse);
      expect(controlID(12345678912), isFalse);
    });

    test('Less than 11 digits', () {
      expect(controlID(111111111), isFalse);
      expect(controlID(123456789), isFalse);
    });

    test('More than 11 digits', () {
      expect(controlID(11111111111111), isFalse);
      expect(controlID(123456789122222), isFalse);
    });

    test('Validate', () async {
      expect(await validateID(11111111111, "ali", "veli", 1991), isFalse);
      expect(await validateForeignID(11111111111, "jack", "delay", 1, 1, 1900),
          isFalse);
      expect(
          await validatePersonAndCard(11111111111, "ali", "veli", false, 1,
              false, 1, false, 1900, 'a15', 796544, 'y02n45764'),
          isFalse);
    });
  });
}
