
# TC ID Checker for Dart & Flutter

 Determines that given TC ID is correct or wrong based on rules.

## Features

* Determines that given TC ID is correct or wrong based on rules.
* If correct, you can use online validation functions.
* Generates valid random TC ID.

[pub.dev](https://pub.dev/packages/tcid_checker) 


## How to Work

* The ones digit of the sum of the first 10 digits gives the 11th digit.

* The ones digit of 7 times the sum of the 1st, 3rd, 5th, 7th and 9th digits plus 9 times the sum of the 2nd, 4th, 6th and 8th digits gives the 10th digit.

* The ones digit of 8 times the sum of the 1st, 3rd, 5th, 7th and 9th digits gives the 11th digit.

* A built-in control ID function in all validate functions with given credentials via Web API supplied by General Directorate of Population and Citizenship Affairs of the Republic of Turkey.
  
*  Generates valid random TC ID when you want.


## Usage
 
1. Add this to your package's pubspec.yaml file:

```dart
tcid_checker: ^2.0.2
```

2. Save the pubspec.yaml file. Or alternatively you can use this code snippet on console:

```dart
pub get
```

with Flutter:

```dart
flutter pub get
```

3. Import it from code file:

```dart
import 'package:tcid_checker/tcid_checker.dart';
```

## License

* This project is licensed under the MIT License.



