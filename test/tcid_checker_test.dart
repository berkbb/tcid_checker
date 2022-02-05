import 'package:tcid_checker/tcid_checker.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('All of False', () {
      expect(checkID("11111111111"), isFalse);
      expect(checkID("12345678912"), isFalse);
    });

    test('Less than 11 digits', () {
      expect(checkID("111111111"), isFalse);
      expect(checkID("123456789"), isFalse);
    });

    test('More than 11 digits', () {
      expect(checkID("11111111111111"), isFalse);
      expect(checkID("123456789122222"), isFalse);
    });
  });
}
