/// Support for doing something awesome.
///
/// More dartdocs go here.
library tcid_checker;

import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

/// * Info: Checks that Turkish ID number is correct or not.
/// * Params: [id] is TC ID, [skipRealCitizen] is a key that controls not to create a real citizen ID. If it is true, ID will start 0, it is not correct on real life, [notPrint] enables / dsiables console log. If true, log will printed.
/// * Returns: boolean.
/// * Notes:
bool controlID(String id, bool skipRealCitizen, bool printLog) {
  try {
    bool c1 = false;
    bool c2 = false;
    bool c3 = false;

    if (id.length == 11 && skipRealCitizen == true
        ? true
        : id[0] != '0') // If length is 11 and first number is not equal 0.
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

    if (printLog == true) {
      print('TC ID: $id is ${isValid == true ? 'correct' : 'wrong'}.');
    }
    return isValid;
  } catch (e) {
    print('An error occurred while checking Turkish ID - $e');
    return false;
  }
}

///* Info: Generates valid random TC ID.
///* Params: [skipRealCitizen] is a key that controls not to create a real citizen ID. If it is true, ID will start 0, it is not correct on real life, [computeFake] is a key that controls compute Fake TC ID or returns a print ready value.
///* Returns: String?.
///* Notes:
String? generateID(bool skipRealCitizen, bool computeFake) {
  try {
    var controlKey = false; // Control key for do -while.
    final int size = 11; // Size is final.
    math.Random random = math.Random(); // Random Generator.
    var generatedNum = ''; // Generated number.

    if (skipRealCitizen == true &&
        computeFake == false) // Fake ID starts with 0.
    {
      print(
          'Generating fake TC ID starts with "0", so it is hard to find any match. So, the process takes a little longer. Please wait.');
      do {
        var tcList = [
          for (var i = 0; i < size; i++) 0
        ]; // Fill the list with 0.

        // Creator logic

        for (var i = 1; i < size - 2; i++) {
          tcList[i] = random.nextInt(10); // Generate number for index 2-11.
        }

        var c1o1 = tcList[1] + tcList[3] + tcList[5] + tcList[7];
        var c1o2 =
            (tcList[0] + tcList[2] + tcList[4] + tcList[6] + tcList[8]) * 7 -
                c1o1;

        tcList[9] = c1o2 % 10;

        var c2o1 = (tcList[0] +
            tcList[1] +
            tcList[2] +
            tcList[3] +
            tcList[4] +
            tcList[5] +
            tcList[6] +
            tcList[7] +
            tcList[8] +
            tcList[9]);

        tcList[10] = c2o1 % 10;

        //
        var buffer = StringBuffer(); // String buffer for add int to a string.
        buffer.writeAll(tcList); // Write to buffer

        var isValidInt = int.tryParse(buffer.toString());
        var value = isValidInt.toString().padLeft(11, "0"); // Add 0 to left.

        if (isValidInt != null &&
            controlID(value, true, false) ==
                true) // Not null means valid integer && ID is correct.
        {
          generatedNum = value; // Set number.
          controlKey = true; // Stop loop.
        }
      } while (controlKey == false);
      print('Generated valid fake TC ID is: $generatedNum');
    } else if ((skipRealCitizen == false && computeFake == true) ||
        (skipRealCitizen == true && computeFake == true)) // Print Ready Fake ID
    {
      generatedNum = "02345678982";
      print('Print ready valid fake TC ID is: $generatedNum');
    } else {
      do {
        var tcList = [
          for (var i = 0; i < size; i++) 0
        ]; // Fill the list with 0.

        // Creator logic

        tcList[0] = random.nextInt(10) +
            1; // from 1 upto 9 included. First num must not be zero.

        for (var i = 1; i < size; i++) {
          tcList[i] = random.nextInt(10); // Generate number for index 2-9.
        }

        //
        var buffer = StringBuffer(); // String buffer for add int to a string.
        buffer.writeAll(tcList); // Write to buffer

        var isValidInt = int.tryParse(buffer.toString());
        var value = isValidInt.toString();
        if (isValidInt != null &&
            controlID(value, skipRealCitizen,
                false)) // Not null means valid integer && ID is correct.
        {
          generatedNum = value; // Set number.
          controlKey = true; // Stop loop.
        }
      } while (controlKey == false);
      print('Generated valid random TC ID is: $generatedNum');
    }

    return generatedNum;
  } catch (e) {
    print('An error occurred while generating valid Turkish ID - $e');
    return null;
  }
}

/// * Info: Validate that Turkish ID number with given credentials from Web API.
/// * Params: [id] is TC ID, [name] is user name, [surname] is user surname, [birthYear] is user birth year, [skipRealCitizen] is a key that controls not to create a real citizen ID. If it is true, ID will start 0, it is not correct on real life.
/// * Returns: boolean.
/// * Notes:
Future<bool> validateID(String id, String name, String surname, int birthYear,
    bool skipRealCitizen) async {
  try {
    bool result = false;

    if (controlID(id, skipRealCitizen, false) == true) {
      var soap12Envelope =
          '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ws="http://tckimlik.nvi.gov.tr/WS">\n<soap:Header/>\n<soap:Body>\n<ws:TCKimlikNoDogrula>\n<ws:TCKimlikNo>$id</ws:TCKimlikNo>\n<ws:Ad>${name.toLowerCase()}</ws:Ad>\n<ws:Soyad>${surname.toLowerCase()}</ws:Soyad>\n<ws:DogumYili>$birthYear</ws:DogumYili>\n</ws:TCKimlikNoDogrula>\n</soap:Body>\n</soap:Envelope>';

      http.Response response = await http.post(
          Uri(
              scheme: "https",
              host: "tckimlik.nvi.gov.tr",
              path: "Service/KPSPublic.asmx"),
          headers: {
            "Content-Type": "application/soap+xml; charset=utf-8",
          },
          body: utf8.encode(soap12Envelope),
          encoding: Encoding.getByName("UTF-8"));

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) // OK
      {
        //string to XML document
        final doc = xml.XmlDocument.parse(response.body)
            .findAllElements('TCKimlikNoDogrulaResult')
            .first;

        result = doc.innerText.parseBool();
      }
    }
    print(
        'Person --> ID: $id, Name: ${name.toLowerCase()}, Surname: ${surname.toLowerCase()}, Birth Year: $birthYear validation result via Web API = $result');

    return result;
  } catch (e) {
    print('An error occurred while validating Turkish ID - $e');
    return false;
  }
}

/// * Info: Validates Person and ID Card with given credentials from Web API.
/// * Params: [id] is TC ID, [name] is user name, [surname] is user surname, [noSurname] is person have surname or not, [birthDay] is user birth day, [noBirthDay] is person have birth day or not, [birthMonth] is user birth month, [noBirthMonth] is person have birth month or not, [oldWalletSerial] is pold wallet serial code, [oldWalletNo] is old wallet number, [newidCardSerial] is new TC Id Card serial number, [skipRealCitizen] is a key that controls not to create a real citizen ID. If it is true, ID will start 0, it is not correct on real life.
/// * Returns: boolean.
/// * Notes: Returns always 'false' due to response from Web API. Service may have been stopped from authorities after Turkish people info leak.
Future<bool> validatePersonAndCard(
    String id,
    String name,
    String surname,
    bool noSurname,
    int birthDay,
    bool noBirthDay,
    int birthMonth,
    bool noBirthMonth,
    int birthYear,
    String oldWalletSerial,
    int oldWalletNo,
    String newidCardSerial,
    bool skipRealCitizen) async {
  try {
    bool result = false;

    if (controlID(id, skipRealCitizen, false) == true) {
      var soap12Envelope =
          '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ws="http://tckimlik.nvi.gov.tr/WS">\n<soap:Header/>\n<soap:Body>\n<ws:KisiVeCuzdanDogrula>\n<ws:TCKimlikNo>$id</ws:TCKimlikNo>\n<ws:Ad>${name.toLowerCase()}</ws:Ad>\n<ws:Soyad>${surname.toLowerCase()}</ws:Soyad>\n<ws:SoyadYok>$noSurname</ws:SoyadYok>\n<ws:DogumGun>$birthDay</ws:DogumGun>\n<ws:DogumGunYok>$noBirthDay</ws:DogumGunYok>\n<ws:DogumAy>$birthMonth</ws:DogumAy>\n<ws:DogumAyYok>$noBirthMonth</ws:DogumAyYok>\n<ws:DogumYil>$birthYear</ws:DogumYil>\n<ws:CuzdanSeri>${oldWalletSerial.toLowerCase()}</ws:CuzdanSeri>\n<ws:CuzdanNo>$oldWalletNo</ws:CuzdanNo>\n<ws:TCKKSeriNo>${newidCardSerial.toLowerCase()}</ws:TCKKSeriNo>\n</ws:KisiVeCuzdanDogrula>\n</soap:Body>\n</soap:Envelope>';

      http.Response response = await http.post(
          Uri(
              scheme: "https",
              host: "tckimlik.nvi.gov.tr",
              path: "Service/KPSPublicV2.asmx"),
          headers: {
            "Content-Type": "application/soap+xml; charset=utf-8",
          },
          body: utf8.encode(soap12Envelope),
          encoding: Encoding.getByName("UTF-8"));

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) // OK
      {
        //string to XML document
        final doc = xml.XmlDocument.parse(response.body)
            .findAllElements('KisiVeCuzdanDogrulaResult')
            .first;

        result = doc.innerText.parseBool();
      }
    }
    print(
        'Person and Card --> ID: $id, Name: ${name.toLowerCase()}, Surname: ${surname.toLowerCase()}, Birth Year: $birthYear, Birth Month: $birthMonth, Birth Day: $birthDay,  Old Wallet No: $oldWalletNo,  Old Wallet Serial: ${oldWalletSerial.toLowerCase()},  New ID Card Serial: ${newidCardSerial.toLowerCase()} validation result via Web API = $result');

    return result;
  } catch (e) {
    print('An error occurred while validating Person and Card - $e');
    return false;
  }
}

/// * Info: Validate that Foreign ID number given by Turkish authorities with given credentials from Web API.
/// * Params: [id] is TC ID, [name] is user name, [surname] is user surname, [birthYear] is user birth year, [birthMonth] is user birth month, [birthDay] is user birth day, [skipRealCitizen] is a key that controls not to create a real citizen ID. If it is true, ID will start 0, it is not correct on real life.
/// * Returns: boolean.
/// * Notes:

Future<bool> validateForeignID(String id, String name, String surname,
    int birthYear, int birthMonth, int birthDay, bool skipRealCitizen) async {
  try {
    bool result = false;

    if (controlID(id, skipRealCitizen, false) == true) {
      var soap12Envelope =
          '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ws="http://tckimlik.nvi.gov.tr/WS">\n<soap:Header/>\n<soap:Body>\n<ws:YabanciKimlikNoDogrula>\n<ws:KimlikNo>$id</ws:KimlikNo>\n<ws:Ad>${name.toLowerCase()}</ws:Ad>\n<ws:Soyad>${surname.toLowerCase()}</ws:Soyad>\n<ws:DogumGun>$birthDay</ws:DogumGun>\n<ws:DogumAy>$birthMonth</ws:DogumAy>\n<ws:DogumYil>$birthYear</ws:DogumYil>\n</ws:YabanciKimlikNoDogrula>\n</soap:Body>\n</soap:Envelope>';

      http.Response response = await http.post(
          Uri(
              scheme: "https",
              host: "tckimlik.nvi.gov.tr",
              path: "Service/KPSPublicYabanciDogrula.asmx"),
          headers: {
            "Content-Type": "application/soap+xml; charset=utf-8",
          },
          body: utf8.encode(soap12Envelope),
          encoding: Encoding.getByName("UTF-8"));

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) // OK
      {
        //string to XML document
        final doc = xml.XmlDocument.parse(response.body)
            .findAllElements('YabanciKimlikNoDogrulaResult')
            .first;

        result = doc.innerText.parseBool();
      }
    }
    print(
        'Foreign Person --> ID: $id, Name: ${name.toLowerCase()}, Surname: ${surname.toLowerCase()}, Birth Year: $birthYear validation result via Web API = $result');

    return result;
  } catch (e) {
    print('An error occurred while validating Foreign ID - $e');
    return false;
  }
}

/// String bool extension.
extension BoolParsing on String {
  /// Parse String to bool.
  bool parseBool() {
    try {
      if (toLowerCase() == "true" || toLowerCase() == "false") {
        return (toLowerCase() == "true" ? true : false);
      } else {
        throw ("$this can not be parsed to boolean.");
      }
    } catch (e) {
      print("$this can not be parsed to boolean.");
      return false;
    }
  }
}
