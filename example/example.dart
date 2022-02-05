import 'package:tcid_checker/tcid_checker.dart';

void main(List<String> args) async {
  check("11111111111");

  await validate("11111111111", "ali", "veli", "1991");
}
