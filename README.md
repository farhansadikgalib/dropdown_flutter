# Dropdown Flutter

**DropdownFlutter** designed to enhance your Flutter application, offers highly customizable dropdowns with advanced features including list data search, network search, and multiple-selection.

## Features

Lots of properties to use and customize dropdown widget as per your need. Also usable under Form widget for required validation.

- Dropdown Flutter using constructor DropdownFlutter<T>().
- Dropdown Flutter with search field using named constructor DropdownFlutter<T>.search().
- Dropdown Flutter with search request field using named constructor DropdownFlutter<T>.searchRequest().
- Multi select Dropdown Flutter using named constructor DropdownFlutter<T>.multiSelect().
- Multi select Dropdown Flutter with search field using named constructor DropdownFlutter<T>.multiSelectSearch().
- Multi select Dropdown Flutter with search request field using named constructor DropdownFlutter<T>.multiSelectSearchRequest().

## Preview
<img src="https://raw.githubusercontent.com/farhansadikgalib/dropdown_flutter/main/screenshots/preview.gif" width="300"/>


<hr>

## Getting started

1. Add the latest version of package to your `pubspec.yaml` (and run `flutter pub get`):

```dart
dependencies:
  dropdown_flutter: 1.0.1
```

2. Import the package and use it in your Flutter App.

```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
```

<hr>

## Example usage

### **1. Dropdown Flutter**
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<String> _list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
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

### **2. Dropdown Flutter with custom type model**
Let's start with the type of object we are going to work with:
```dart
class Job {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() {
    return name;
  }
}
```
Whenever you are going to work with custom type model `T`, your model must override the default `toString()` method and return the property inside that you want to display as list item otherwise the dropdown list item would show `Instance of [model name]`.

Now the widget:

```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<Job> _list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
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
### **3. Dropdown Flutter with multiple selection**
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<Job> _list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
  ];

class MultiSelectDropDown extends StatelessWidget {
  const MultiSelectDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Job>.multiSelect(
        items: _jobItems,
        initialItems: _jobItems.take(1).toList(),
        onListChanged: (value) {
          log('changing value to: $value');
        },
      );
  }
}
```

### **4. Dropdown Flutter with search:** *A Dropdown Flutter with the possibility to filter the items.*
First, let's enhance our Job model with more functionality:
```dart
class Job with DropdownFlutterListFilter {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() {
    return name;
  }

  @override
  bool filter(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }
}
```
If the filter on the object is more complex, you can add the `DropdownFlutterListFilter` mixin to it, which gives you access to the `filter(query)` method, and by this the items of the list will be filtered.

Now the widgets:

#### SearchDropdown
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<Job> _list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
  ];

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

#### MultiSelectSearchDropdown
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<Job> _list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
  ];

class MultiSelectSearchDropdown extends StatelessWidget {
  const SearchDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Job>.multiSelectSearch(
      hintText: 'Select job role',
      items: _list,
      onListChanged: (value) {
        log('changing value to: $value');
      },
    );
  }
}
```

### **5. Dropdown Flutter with search request:** *A Dropdown Flutter with a search request to load the items.*
Let's use a personalized object for the items:
```dart
class Pair {
  final String text;
  final IconData icon;
  const Pair(this.text, this.icon);

  @override
  String toString() {
    return text;
  }
}
```

Now the widgets:

#### SearchRequestDropdown
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<Pair> _list = [
    Pair('Developer', Icons.developer_board),
    Pair('Designer', Icons.deblur_sharp),
    Pair('Consultant', Icons.money_off),
    Pair('Student', Icons.edit),
  ];

class SearchRequestDropdown extends StatelessWidget {
  const SearchRequestDropdown({Key? key}) : super(key: key);

  // This should be a call to the api or service or similar
  Future<List<Pair>> _getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _list.where((e) {
        return e.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
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

#### MultiSelectSearchRequestDropdown
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<Pair> _list = [
    Pair('Developer', Icons.developer_board),
    Pair('Designer', Icons.deblur_sharp),
    Pair('Consultant', Icons.money_off),
    Pair('Student', Icons.edit),
  ];

class MultiSelectSearchRequestDropdown extends StatelessWidget {
  const MultiSelectSearchRequestDropdown({Key? key}) : super(key: key);

  // This should be a call to the api or service or similar
  Future<List<Pair>> _getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _list.where((e) {
        return e.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Pair>.multiSelectSearchRequest(
      futureRequest: _getFakeRequestData,
      hintText: 'Search job role',
      onListChanged: (value) {
        log('changing value to: $value');
      },
    );
  }
}
```

### **6. Dropdown Flutter with validation:** *A Dropdown Flutter with validation.*

#### ValidationDropdown
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<String> _list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
  ];

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
            // Run validation on item selected
            validateOnChange: true,
            // Function to validate if the current selected item is valid or not
            validator: (value) => value == null ? "Must not be null" : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

#### MultiSelectValidationDropdown
```dart
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const List<String> _list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
  ];

class MultiSelectValidationDropdown extends StatelessWidget {
  MultiSelectValidationDropdown({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownFlutter<String>.multiSelect(
            hintText: 'Select job role',
            items: _list,
            onListChanged: (value) {
              log('changing value to: $value');
            },
            listValidator: (value) => value.isEmpty ? "Must not be null" : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Customization
For a complete customization of the package, go to the [example](https://github.com/farhansadikgalib/dropdown_flutter/tree/main/example).

## Issues & Feedback

Please file an [issue](https://github.com/farhansadikgalib/dropdown_flutter/issues) to send feedback or report a bug. Thank you!

