# Dropdown Flutter

A highly customizable Flutter dropdown package with search, network search, multi-select, and validation support.

<img src="https://raw.githubusercontent.com/farhansadikgalib/dropdown_flutter/main/screenshots/preview.gif" width="300"/>

## Features

- Highly customizable - Style it your way
- Search support - Local and network search
- Multi-select - Select multiple items
- Form validation - Built-in validation support
- Custom models - Use any data type

## Installation

```yaml
dependencies:
  dropdown_flutter: ^1.0.3
```

## Quick Start

```dart
import 'package:dropdown_flutter/custom_dropdown.dart';

DropdownFlutter<String>(
  hintText: 'Select job role',
  items: ['Engineer', 'Designer', 'Manager'],
  onChanged: (value) {
    print('Selected: $value');
  },
)
```

## Usage

### 1. Simple Dropdown

```dart
DropdownFlutter<String>(
  hintText: 'Select job role',
  items: ['Engineer', 'Designer', 'Manager', 'Intern'],
  initialItem: 'Engineer',
  onChanged: (value) => print(value),
)
```

### 2. Custom Model

```dart
class Job {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() => name;
}

DropdownFlutter<Job>(
  hintText: 'Select job role',
  items: [
    Job('Engineer', Icons.engineering),
    Job('Designer', Icons.palette),
  ],
  onChanged: (value) => print(value),
)
```

### 3. Multi-Select

```dart
DropdownFlutter<String>.multiSelect(
  items: ['Engineer', 'Designer', 'Manager'],
  initialItems: ['Engineer'],
  onListChanged: (list) => print(list),
)
```

### 4. Search Dropdown

```dart
class Job with DropdownFlutterListFilter {
  final String name;
  const Job(this.name);

  @override
  String toString() => name;

  @override
  bool filter(String query) => 
      name.toLowerCase().contains(query.toLowerCase());
}

DropdownFlutter<Job>.search(
  hintText: 'Search job role',
  items: [Job('Engineer'), Job('Designer')],
  onChanged: (value) => print(value),
)
```

### 5. Network Search

```dart
DropdownFlutter<String>.searchRequest(
  futureRequest: (query) async {
    // Your API call here
    await Future.delayed(Duration(seconds: 1));
    return ['Engineer', 'Designer'].where(
      (item) => item.toLowerCase().contains(query.toLowerCase())
    ).toList();
  },
  hintText: 'Search job role',
  onChanged: (value) => print(value),
)
```

### 6. Form Validation

```dart
DropdownFlutter<String>(
  hintText: 'Select job role',
  items: ['Engineer', 'Designer', 'Manager'],
  validator: (value) => value == null ? 'Required' : null,
  validateOnChange: true,
  onChanged: (value) => print(value),
)
```

---

**Author:** [farhansadikgalib](https://github.com/farhansadikgalib)
