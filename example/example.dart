import 'package:tcid_checker/tcid_checker.dart';

void main(List<String> args) async {
  // bool r1 =
  controlID("08392566548", true, false); // Control ID. -- true

  // bool r6 =
  controlID("02345678982", false, false); // Control ID. -- false

  // String? r2 =
  generateID(false, false)!; // Generates valid random TC ID. -- random int.

// String? r8 =
  generateID(false, true)!; // Returns a print ready TC ID. -- 02345678982.

  // String? r7 =
  generateID(true, true)!; // Returns a print ready TC ID. -- 02345678982.

  // String? r9 =
  generateID(
      true, false)!; // Returns a valid fake TC ID start with 0. -- random int.

  // bool r3 =
  await validateID("11111111111", "ali", "veli", 1900,
      false); // Validate ID from WEB API. -- false

  // bool r4 =
  await validateForeignID("11111111111", "jack", "delay", 1, 1, 1900,
      false); // Validate foreign ID from WEB API. -- false

  // bool r5 =
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
      false); // Validate Person and Card ID from WEB API. -- false

//Print area.
  // print(r1);
  // print(r2);
  // print(r3);
  // print(r4);
  // print(r5);
  // print(r6);
  // print(r7);
  // print(r8);
  // print(r9);
}
