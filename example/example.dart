import 'package:tcid_checker/tcid_checker.dart';

void main(List<String> args) async {
  controlID(11111111111); // Control ID. -- false

  await validateID(
      11111111111, "ali", "veli", 1900); // Validate ID from WEB API. -- false

  await validateForeignID(11111111111, "jack", "delay", 1, 1,
      1900); // Validate foreign ID from WEB API. -- false

  await validatePersonAndCard(
      11111111111,
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
      'y02n45764'); // Validate Person and Card ID from WEB API. -- false
}
