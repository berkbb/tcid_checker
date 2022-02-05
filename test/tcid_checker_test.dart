import 'package:tcid_checker/tcid_checker.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('All of False', () {
      expect(check("11111111111"), isFalse);
      expect(check("12345678912"), isFalse);
    });

    test('Less than 11 digits', () {
      expect(check("111111111"), isFalse);
      expect(check("123456789"), isFalse);
    });

    test('More than 11 digits', () {
      expect(check("11111111111111"), isFalse);
      expect(check("123456789122222"), isFalse);
    });

    test('Validate', () async {
      expect(await validate("11111111111", "ali", "veli", "1991"), isFalse);
    });
  });
}
