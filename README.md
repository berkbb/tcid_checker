
# TC ID Checker for Dart & Flutter

Checks that Turkish ID number is valid or not.

## Features

* Determines that given TC ID is valid or not based on rules.

[pub.dev](https://pub.dev/packages/tcid_checker) 


## How to Work

```dart
import 'package:tcid_checker/tcid_checker.dart' as IDChecker;

void main(List<String> arguments) {
 bool result = IDChecker.CheckID(11111111111); // Checks TC ID is valid or not based on rules.
}
```


## Usage
 
1. Add this to your package's pubspec.yaml file:

```dart
tcid_checker: ^1.0.0
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



