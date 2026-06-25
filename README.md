# Dropdown Flutter

A highly customizable Flutter dropdown package with search, network search, multi-select, and validation support.

<img src="https://raw.githubusercontent.com/farhansadikgalib/dropdown_flutter/main/screenshots/preview.gif" width="300"/>

## Features

- Highly customizable - Style it your way
- Search support - Local and network search
- Multi-select - Select multiple items
- Form validation - Built-in validation support
- Custom models - Use any data type
- Modern UX (all opt-in) - Haptic feedback, keyboard navigation, search-term
  highlighting, grouped sections, recent selections, select-all and a
  configurable open/close animation

## Installation

```yaml
dependencies:
  dropdown_flutter: ^1.1.0
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

## Modern UX features (opt-in)

Every feature below is **off by default** — existing usage is unaffected. Enable
only what you need.

### Haptic feedback

```dart
DropdownFlutter<String>(
  items: items,
  enableHapticFeedback: true, // light impact on open, click on select
  onChanged: (value) => print(value),
)
```

### Keyboard navigation

Arrow Up/Down to move the highlight, Enter to select, Escape to close.

```dart
DropdownFlutter<String>(
  items: items,
  enableKeyboardNavigation: true,
  decoration: const CustomDropdownDecoration(
    listItemDecoration: ListItemDecoration(highlightedColor: Color(0xFFE8F0FE)),
  ),
  onChanged: (value) => print(value),
)
```

### Search-term highlighting

```dart
DropdownFlutter<String>.search(
  items: items,
  highlightMatchedText: true,
  decoration: const CustomDropdownDecoration(
    listItemDecoration: ListItemDecoration(
      searchMatchTextStyle: TextStyle(fontWeight: FontWeight.w700),
    ),
  ),
  onChanged: (value) => print(value),
)
```

### Grouped sections

```dart
DropdownFlutter<String>(
  items: items,
  groupBy: (item) => item.startsWith('A') ? 'A' : 'Other',
  // groupHeaderBuilder: (context, label) => MyHeader(label), // optional
  onChanged: (value) => print(value),
)
```

### Recent selections

```dart
DropdownFlutter<String>(
  items: items,
  recentSelectionsMaxCount: 3,
  initialRecentItems: const ['Engineer'],          // optional seed
  onRecentItemsChanged: (recents) => persist(recents), // optional persistence
  onChanged: (value) => print(value),
)
```

### Select all (multi-select)

```dart
DropdownFlutter<String>.multiSelect(
  items: items,
  showSelectAll: true,
  // selectAllText: 'Select all', clearAllText: 'Clear all', // optional
  onListChanged: (list) => print(list),
)
```

### Configurable animation

```dart
DropdownFlutter<String>(
  items: items,
  animationDuration: const Duration(milliseconds: 220),
  animationCurve: Curves.easeOutCubic,
  onChanged: (value) => print(value),
)
```

---

**Author:** [farhansadikgalib](https://github.com/farhansadikgalib)
