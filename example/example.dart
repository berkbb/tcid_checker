import 'package:tcid_checker/tcid_checker.dart';

main(List<String> args) {
  print('TC ID is ${checkID("11111111111") == true ? 'valid' : 'not valid'}.');
}
