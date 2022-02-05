/// Support for doing something awesome.
///
/// More dartdocs go here.
library tcid_checker;

// Checks that Turkish ID number is valid or not.[value] is TC ID.
bool checkID(String value) {
  try {
    bool c1 = false;
    bool c2 = false;
    bool c3 = false;
    var tcID = int.tryParse(value); // TC ID int.
    if (value.length == 11 &&
        value[0] != '0' &&
        tcID != null) // If length is 11 and first number is not equal 0.
    {
      int first10Sum = 0; // First 10 digit sum.

      for (int i = 0; i < 10; i++) {
        first10Sum = first10Sum + int.parse(value[i]);
      }

      // print('first10Sum: $first10Sum');

      int sum1 = int.parse(value[0]) +
          int.parse(value[2]) +
          int.parse(value[4]) +
          int.parse(value[6]) +
          int.parse(
              value[8]); // Sum of numbers at 1., 3., 5., 7. and 9. positions.

      // print('sum1: $sum1');
      int multiply1 = sum1 * 7; // Multiply sum1 with 7.

      // print('multiply1: $multiply1');

      int sum2 = int.parse(value[1]) +
          int.parse(value[3]) +
          int.parse(value[5]) +
          int.parse(value[7]); // Sum of numbers at 2., 4., 6. and 8. positions.

      // print('sum2: $sum2');

      int multiply2 = sum2 * 9; // Multiply sum2 with 9.

      // print('multiply2: $multiply2');

      int operation1 = first10Sum % 10; // mod10 of first10sum.

      // print('operation1: $operation1');

      int operation2 = (multiply1 + multiply2) %
          10; // mod10 of Multiply multiply1 and multiply1.

      // print('operation2: $operation2');

      int operation3 = (sum1 * 8) % 10; // mod10 Multiply sum1 and 8.

      // print('operation3: $operation3');

      if (operation1 ==
          int.parse(
              value[10])) //If operation1 is equal to 11th digit of the ID.

      {
        c1 = true;
        // print('Operation 1 is true');
      }

      if (operation2 ==
          int.parse(
              value[9])) //If operation2  is equal to 10th digit of the ID.

      {
        c2 = true;
        // print('Operation 2 is true');
      }

      if (operation3 ==
          int.parse(value[
              10])) //If operation3 mod 10 is equal to 11th digit of the ID.

      {
        c3 = true;

        // print('Operation 3 is true');
      }
    }

    bool isValid = c1 & c2 & c3;

    print('TC ID is ${isValid == true ? 'valid' : 'not valid'}.');
    return isValid;
  } catch (e) {
    print('An error occurred while checking Turkish ID - $e');
    return false;
  }
}
