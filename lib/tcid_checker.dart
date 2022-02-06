/// Support for doing something awesome.
///
/// More dartdocs go here.
library tcid_checker;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

/// * Info: Checks that Turkish ID number is correct or not.
/// * Params: [id] is TC ID.
/// * Returns: boolean.
bool controlID(int id) {
  try {
    bool c1 = false;
    bool c2 = false;
    bool c3 = false;
    var idString = id.toString();
    if (idString.length == 11 &&
        idString[0] != '0') // If length is 11 and first number is not equal 0.
    {
      int first10Sum = 0; // First 10 digit sum.

      for (int i = 0; i < 10; i++) {
        first10Sum = first10Sum + int.parse(idString[i]);
      }

      int sum1 = int.parse(idString[0]) +
          int.parse(idString[2]) +
          int.parse(idString[4]) +
          int.parse(idString[6]) +
          int.parse(idString[
              8]); // Sum of numbers at 1., 3., 5., 7. and 9. positions.

      int multiply1 = sum1 * 7; // Multiply sum1 with 7.

      int sum2 = int.parse(idString[1]) +
          int.parse(idString[3]) +
          int.parse(idString[5]) +
          int.parse(
              idString[7]); // Sum of numbers at 2., 4., 6. and 8. positions.

      int multiply2 = sum2 * 9; // Multiply sum2 with 9.

      int operation1 = first10Sum % 10; // mod10 of first10sum.

      int operation2 = (multiply1 + multiply2) %
          10; // mod10 of Multiply multiply1 and multiply1.

      int operation3 = (sum1 * 8) % 10; // mod10 Multiply sum1 and 8.

      if (operation1 ==
          int.parse(
              idString[10])) //If operation1 is equal to 11th digit of the ID.

      {
        c1 = true;
      }

      if (operation2 ==
          int.parse(
              idString[9])) //If operation2  is equal to 10th digit of the ID.

      {
        c2 = true;
      }

      if (operation3 ==
          int.parse(idString[
              10])) //If operation3 mod 10 is equal to 11th digit of the ID.

      {
        c3 = true;
      }
    }

    bool isValid = c1 & c2 & c3;

    print('TC ID: $id is ${isValid == true ? 'correct' : 'wrong'}.');
    return isValid;
  } catch (e) {
    print('An error occurred while checking Turkish ID - $e');
    return false;
  }
}

/// * Info: Validate that Turkish ID number with given credentials from Web API.
/// * Params: [id] is TC ID, [name] is user name, [surname] is user surname, [birthYear] is user birth year.
/// * Returns: boolean.
Future<bool> validateID(
    int id, String name, String surname, int birthYear) async {
  try {
    bool result = false;

    if (controlID(id) == true) {
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
/// * Params: [id] is TC ID, [name] is user name, [surname] is user surname, [noSurname] is person have surname or not, [birthDay] is user birth day, [noBirthDay] is person have birth day or not, [birthMonth] is user birth month, [noBirthMonth] is person have birth month or not, [oldWalletSerial] is pold wallet serial code, [oldWalletNo] is old wallet number, [newidCardSerial] is new TC Id Card serial number.
/// * Returns: boolean.
/// * Warning: Returns always 'false' due to response from Web API. Service may have been stopped from authorities after Turkish people info leak.
Future<bool> validatePersonAndCard(
    int id,
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
    String newidCardSerial) async {
  try {
    bool result = false;

    if (controlID(id) == true) {
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
/// * Params: [id] is TC ID, [name] is user name, [surname] is user surname, [birthYear] is user birth year, [birthMonth] is user birth month, [birthDay] is user birth day.
/// * Returns: boolean.
Future<bool> validateForeignID(int id, String name, String surname,
    int birthYear, int birthMonth, int birthDay) async {
  try {
    bool result = false;

    if (controlID(id) == true) {
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
