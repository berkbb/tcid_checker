/// Support for doing something awesome.
///
/// More dartdocs go here.
library tcid_checker;

import 'dart:convert';

import 'package:http/http.dart' as http;

/// * Info: Checks that Turkish ID number is correct or not.
/// * Params: [id] is TC ID.
/// * Returns: boolean.
bool check(String id) {
  try {
    bool c1 = false;
    bool c2 = false;
    bool c3 = false;
    var tcID = int.tryParse(id); // TC ID int.
    if (id.length == 11 &&
        id[0] != '0' &&
        tcID != null) // If length is 11 and first number is not equal 0.
    {
      int first10Sum = 0; // First 10 digit sum.

      for (int i = 0; i < 10; i++) {
        first10Sum = first10Sum + int.parse(id[i]);
      }

      int sum1 = int.parse(id[0]) +
          int.parse(id[2]) +
          int.parse(id[4]) +
          int.parse(id[6]) +
          int.parse(
              id[8]); // Sum of numbers at 1., 3., 5., 7. and 9. positions.

      int multiply1 = sum1 * 7; // Multiply sum1 with 7.

      int sum2 = int.parse(id[1]) +
          int.parse(id[3]) +
          int.parse(id[5]) +
          int.parse(id[7]); // Sum of numbers at 2., 4., 6. and 8. positions.

      int multiply2 = sum2 * 9; // Multiply sum2 with 9.

      int operation1 = first10Sum % 10; // mod10 of first10sum.

      int operation2 = (multiply1 + multiply2) %
          10; // mod10 of Multiply multiply1 and multiply1.

      int operation3 = (sum1 * 8) % 10; // mod10 Multiply sum1 and 8.

      if (operation1 ==
          int.parse(id[10])) //If operation1 is equal to 11th digit of the ID.

      {
        c1 = true;
      }

      if (operation2 ==
          int.parse(id[9])) //If operation2  is equal to 10th digit of the ID.

      {
        c2 = true;
      }

      if (operation3 ==
          int.parse(
              id[10])) //If operation3 mod 10 is equal to 11th digit of the ID.

      {
        c3 = true;
      }
    }

    bool isValid = c1 & c2 & c3;

    print('TC ID: $id is ${isValid == true ? 'cırrent' : 'not correct'}.');
    return isValid;
  } catch (e) {
    print('An error occurred while checking Turkish ID - $e');
    return false;
  }
}

/// * Info: Validate that Turkish ID number with given credentials from Web API.
/// * Params: [id] is TC ID, [name] is user name, [surname] is user surname, [birthYear] is userbirth year.
/// * Returns: boolean.
Future<bool> validate(
    String id, String name, String surname, String birthYear) async {
  try {
    bool result = false;

    if (check(id) == true) {
      var soap12Envelope =
          '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">\n<soap12:Body>\n<TCKimlikNoDogrula xmlns="http://tckimlik.nvi.gov.tr/WS">\n<TCKimlikNo>$id</TCKimlikNo>\n<Ad>"${name.toLowerCase()}"</Ad>\n<Soyad>${surname.toLowerCase()}</Soyad>\n<DogumYili>$birthYear</DogumYili>\n</TCKimlikNoDogrula>\n</soap12:Body>\n</soap12:Envelope>';

      http.Response response = await http.post(
          Uri(
              scheme: "https",
              host: "tckimlik.nvi.gov.tr",
              path: "Service/KPSPublic.asmx"),
          headers: {
            "Content-Type": "application/soap+xml; charset=utf-8",
            "Content-Length": "length"
          },
          body: utf8.encode(soap12Envelope),
          encoding: Encoding.getByName("UTF-8"));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) // OK
      {
        result = true;
      }
      print(
          'TC ID: $id ${result == true ? 'is validated' : 'cannot validated'} via Web API.');
    } else {
      print('TC ID: $id cannot validated via Web API.');
    }

    return result;
  } catch (e) {
    print('An error occurred while validating Turkish ID - $e');
    return false;
  }
}
