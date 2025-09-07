# Dropdown Flutter

**DropdownFlutter** enhances your Flutter app with customizable dropdowns, including search, network search, multi-select, and validation features.

---

## Table of Contents
1. [Features](#features)
2. [Preview](#preview)
3. [Getting Started](#getting-started)
4. [Usage Examples](#usage-examples)
    - [Simple Dropdown](#simple-dropdown)
    - [Custom Model Dropdown](#custom-model-dropdown)
    - [Multi-Select Dropdown](#multi-select-dropdown)
    - [Search Dropdown](#search-dropdown)
    - [Search Request Dropdown](#search-request-dropdown)
    - [Validation Dropdown](#validation-dropdown)
5. [Model Requirements](#model-requirements)
6. [Contributing](#contributing)
7. [License](#license)

---

## Features
- Highly customizable dropdown widget
- Searchable dropdowns
- Network search support
- Multi-select dropdowns
- Form validation support

---

## Preview
<img src="https://raw.githubusercontent.com/farhansadikgalib/dropdown_flutter/main/screenshots/preview.gif" width="300"/>

---

## Getting Started
Add the latest version to your `pubspec.yaml`:
```yaml
dependencies:
  dropdown_flutter: 1.0.1
```
Run `flutter pub get` and import:
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
```

---

## Usage Examples

### Simple Dropdown
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<String> _list = [
  'Engineer',
  'Artist',
  'Manager',
  'Intern',
];

class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>(
      hintText: 'Select job role',
      items: _list,
      initialItem: _list[0],
      onChanged: (value) {
        log('changing value to: $value');
      },
    );
  }
}
```

### Custom Model Dropdown
Override `toString()` in your model to display custom text:
```dart
class Job {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() => name;
}
```
Usage:
```dart
const List<Job> _list = [
  Job('Engineer', Icons.engineering),
  Job('Artist', Icons.palette),
  Job('Manager', Icons.business_center),
  Job('Intern', Icons.school),
];

class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Job>(
      hintText: 'Select job role',
      items: _list,
      onChanged: (value) {
        log('changing value to: $value');
      },
    );
  }
}
```

### Multi-Select Dropdown
```dart
class MultiSelectDropDown extends StatelessWidget {
  const MultiSelectDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Job>.multiSelect(
      items: _list,
      initialItems: _list.take(1).toList(),
      onListChanged: (value) {
        log('changing value to: $value');
      },
    );
  }
}
```

### Search Dropdown
Add the `DropdownFlutterListFilter` mixin for custom filtering:
```dart
class Job with DropdownFlutterListFilter {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() => name;

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());
}
```
Usage:
```dart
class SearchDropdown extends StatelessWidget {
  const SearchDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Job>.search(
      hintText: 'Select job role',
      items: _list,
      excludeSelected: false,
      onChanged: (value) {
        log('changing value to: $value');
      },
    );
  }
}
```

### Search Request Dropdown
Async search example:
```dart
class Pair {
  final String text;
  final IconData icon;
  const Pair(this.text, this.icon);

  @override
  String toString() => text;
}

const List<Pair> _list = [
  Pair('Developer', Icons.developer_board),
  Pair('Designer', Icons.deblur_sharp),
  Pair('Consultant', Icons.money_off),
  Pair('Student', Icons.edit),
];

class SearchRequestDropdown extends StatelessWidget {
  const SearchRequestDropdown({Key? key}) : super(key: key);

  Future<List<Pair>> _getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _list.where((e) => e.text.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Pair>.searchRequest(
      futureRequest: _getFakeRequestData,
      hintText: 'Search job role',
      items: _list,
      onChanged: (value) {
        log('changing value to: $value');
      },
    );
  }
}
```

### Validation Dropdown
Single-select validation:
```dart
class ValidationDropdown extends StatelessWidget {
  ValidationDropdown({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownFlutter<String>(
            hintText: 'Select job role',
            items: _list,
            onChanged: (value) {
              log('changing value to: $value');
            },
            validateOnChange: true,
            validator: (value) => value == null ? "Must not be null" : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
              },
              child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Model Requirements
- Override `toString()` in your model to display custom text in dropdowns.
- For advanced filtering, use the `DropdownFlutterListFilter` mixin and implement the `filter(query)` method.

---

## Contributing
Contributions are welcome! Please open issues or submit pull requests for improvements.

---

## License
Distributed under the MIT License. See [LICENSE](LICENSE) for details.
