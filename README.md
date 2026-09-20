<div align="center">

<img src="screenshots/logo.png" width="120" alt="Dropdown Flutter"/>

# Dropdown Flutter

**A customizable Flutter dropdown — search, network search, multi-select and form validation built in.**

[![pub version](https://img.shields.io/pub/v/dropdown_flutter?style=flat-square&color=0553B1&logo=dart)](https://pub.dev/packages/dropdown_flutter)
[![pub points](https://img.shields.io/pub/points/dropdown_flutter?style=flat-square&color=0553B1)](https://pub.dev/packages/dropdown_flutter/score)
[![likes](https://img.shields.io/pub/likes/dropdown_flutter?style=flat-square&color=0553B1)](https://pub.dev/packages/dropdown_flutter/score)
[![license](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

<img src="screenshots/preview.png" width="760" alt="Simple select, grouped sections and dark theme side by side"/>

</div>

## Install

Requires Flutter **3.27+** and Dart **3.6+**. The original
`custom_dropdown.dart` import remains supported.

```yaml
dependencies:
  dropdown_flutter: ^1.3.0
```

```dart
import 'package:dropdown_flutter/dropdown_flutter.dart';

DropdownFlutter<String>(
  hintText: 'Select priority',
  items: const ['Low', 'Medium', 'High', 'Urgent'],
  initialItem: 'Medium',                       // optional
  onChanged: (value) => print(value),
)
```

That is the whole setup — no builders, controllers or config required.

## Constructors

| Constructor | Use it for |
| --- | --- |
| `DropdownFlutter()` | A plain list of items |
| `.search()` | Filtering a local list as the user types |
| `.searchRequest()` | Fetching results from an API |
| `.multiSelect()` | Selecting several items with checkboxes |
| `.multiSelectSearch()` | Multi-select over a filtered local list |
| `.multiSelectSearchRequest()` | Multi-select over API results |

Choose the constructor for your data source and selection mode. Search options
apply to search constructors; select-all and list validation apply to multi-select.
The `multiSelect*` variants report through `onListChanged`; the rest use
`onChanged`.

## Screenshots

<div align="center">

| Multi-select | Grouped | Highlighting | Dark theme |
| :---: | :---: | :---: | :---: |
| <img src="screenshots/ss_3.jpg" width="190" alt="Multi select with avatars and checkboxes"/> | <img src="screenshots/ss_4.jpg" width="190" alt="Grouped sections with team headers"/> | <img src="screenshots/ss_5.jpg" width="190" alt="Search results with matched text highlighted"/> | <img src="screenshots/ss_6.jpg" width="190" alt="Dropdown following a dark theme"/> |

</div>

## Usage

### Search — local and network

Plain `String` items search out of the box. For your own type, mix in
`CustomDropdownListFilter` and decide what counts as a match.

```dart
class Member with CustomDropdownListFilter {
  const Member(this.name, this.role);
  final String name;
  final String role;

  // toString() supplies the row label; filter() decides what matches.
  @override
  String toString() => name;

  @override
  bool filter(String q) => name.toLowerCase().contains(q.toLowerCase()) ||
      role.toLowerCase().contains(q.toLowerCase()); // "engineer" finds them all
}

DropdownFlutter<Member>.search(items: members, onChanged: print);

DropdownFlutter<Member>.searchRequest(          // same, but from an API
  futureRequest: (query) async => api.searchMembers(query),
  futureRequestDelay: const Duration(milliseconds: 300),
  onChanged: print,
);
```


### Validation and controllers

```dart
final controller = SingleSelectController<String?>('Medium');
// MultiSelectController<String>(['Medium']) for multi-select

DropdownFlutter<String>(
  items: priorities,
  controller: controller,                       // read and set from anywhere
  validator: (value) => value == null ? 'Required' : null,
  validateOnChange: true,                       // listValidator for multi-select
  onChanged: print,
);

controller.value = 'High';
controller.clear();
```


### Custom rows

`toString()` gives the default label. For anything richer, supply a
`listItemBuilder` — `headerBuilder`, `hintBuilder` and `noResultFoundBuilder`
work the same way.

```dart
DropdownFlutter<Member>(
  items: members,
  listItemBuilder: (context, item, isSelected, onItemSelect) => Row(
    children: [
      CircleAvatar(child: Text(item.name[0])),
      const SizedBox(width: 12),
      Text(item.name),
    ],
  ),
  onChanged: print,
)
```


## Modern UX

The features below are opt-in. Default surfaces and text follow the app theme;
fields support Tab focus and Enter/Space activation. Escape dismisses a menu and
returns focus to the field. Multi-select menus include a selection count and
Done button by default; choices are applied immediately, and Done closes the menu.
Use `doneText` to localize its label or `showMultiSelectFooter: false` to hide it.

| Property | Effect |
| --- | --- |
| `groupBy` | Splits the list into labelled sections |
| `highlightMatchedText` | Emphasises the matched substring in results |
| `recentSelectionsMaxCount` | Pins recently picked items to the top |
| `showSelectAll` | Adds a select-all / clear-all row (multi-select) |
| `selectAllText` / `clearAllText` | Relabel that row |
| `enableKeyboardNavigation` | Arrow keys move, Enter selects, Escape closes |
| `enableHapticFeedback` | Light impact on open, click on select |
| `animationDuration` / `animationCurve` | Tunes the open/close animation |

```dart
DropdownFlutter<Member>(
  items: members,
  groupBy: (member) => member.team,             // any combination works
  recentSelectionsMaxCount: 3,
  enableKeyboardNavigation: true,
  onChanged: print,
)
```

## Styling

`decoration` covers colors, borders, shadows and text styles; the builders
replace widgets outright. Colors fall back to the ambient `ColorScheme`, so
dropdowns follow a dark theme with no extra configuration.

```dart
DropdownFlutter<String>(
  items: items,
  decoration: CustomDropdownDecoration(
    closedFillColor: const Color(0xFF1E1B33),
    closedBorderRadius: BorderRadius.circular(16),
    headerStyle: const TextStyle(color: Colors.white),
  ),
  onChanged: print,
)

final withIcon = base.copyWith(prefixIcon: const Icon(Icons.person));
```

Size is controlled by `overlayHeight`, `listItemPadding` and `listItemHeight`
— the last defaults to null so rows fit their content; setting it lets the list
scroll more efficiently. Menus also respect available viewport space and keyboard
insets, including short lists with tall custom rows.

## State and lifecycle

- Create controllers once in `State`, and dispose them in your `dispose()` method.
  The dropdown only disposes controllers it creates itself. Controllers may be
  replaced or removed during rebuilds.
- `initialItem` / `initialItems` seed an uncontrolled dropdown. Changing these
  properties resets its selection; with a controller, set `controller.value`.
  Do not supply both a controller and initial selection.
- Multi-select values are immutable, duplicate-free snapshots. Use `add`, `remove`,
  `clear`, or assign a new list to `value`; do not mutate `controller.value`.
- Local initial selections must all belong to `items`. Custom objects should
  implement consistent `==` and `hashCode`. Replace item lists when data changes.
  If a selected item is removed, clear/update the controller explicitly.
- `FormState.reset()` restores the initial selection (or the value present when
  a controller was attached) and clears errors. Disabled fields do not validate.
- Select-all acts on the current filtered/fetched results, preserving selections
  outside those results. Clear-all removes only the current results.
- Network search runs for nonempty queries. Clearing cancels pending debounce
  timers and restores the supplied seed `items`. Old requests may finish, but
  cannot overwrite newer results or update a disposed dropdown. Before typing,
  an empty remote menu shows `searchHintText` instead of a no-results message.
  Failed requests show a Retry action that repeats the current query. Customize
  or localize this state with `searchRequestErrorBuilder(context, error, retry)`;
  raw exception details are not displayed by the default UI.
- `closeDropDownOnClearFilterSearch` closes the menu when its clear button is used.
  Reduced-motion settings skip the menu animation.
- Builder callbacks have public types such as `DropdownListItemBuilder<T>` and
  `DropdownHeaderBuilder<T>` for reusable builders.

## Development

```sh
flutter pub get
flutter analyze
flutter test
cd example
flutter test
```

Run the package regression/UX suites and example gallery together on an Android
emulator (from `example/`):

```sh
flutter emulators --launch <emulator-id>
flutter test integration_test/dropdown_flutter_test.dart -d <device-id>
```

Use `flutter emulators` and `flutter devices` to find the IDs.
CI checks the minimum supported Flutter version and stable Flutter.

## All properties

| Group | Properties |
| --- | --- |
| **Items** | `items`, `initialItem` / `initialItems`, `excludeSelected`, and the `onChanged` / `onListChanged` callbacks |
| **Text** | `hintText`, `searchHintText`, `noResultFoundText`, `maxlines` (line limit on the closed header) |
| **Sizing** | `listItemHeight`, `overlayHeight`, `listItemPadding` / `itemsListPadding`, `closedHeaderPadding` / `expandedHeaderPadding` |
| **Behaviour** | `enabled`, `canCloseOutsideBounds`, `hideSelectedFieldWhenExpanded`, `closeDropDownOnClearFilterSearch`, `visibility` |
| **Control** | `controller` / `multiSelectController`, `overlayController`, `itemsScrollController` |
| **Async** | `futureRequest` / `futureRequestDelay`, `searchRequestLoadingIndicator`, `searchRequestErrorBuilder` |
| **Completion** | `showMultiSelectFooter`, `doneText` |
| **Recents** | `initialRecentItems`, `onRecentItemsChanged` |
| **Validation** | `validator` / `listValidator`, `validateOnChange` |
| **Appearance** | `decoration` / `disabledDecoration` |
| **Builders** | `listItemBuilder`, `headerBuilder` / `headerListBuilder`, `hintBuilder`, `noResultFoundBuilder`, `groupHeaderBuilder` |

---

<div align="center">

### Made by [Farhan Sadik Galib](https://farhansadikgalib.com)

<a href="https://farhansadikgalib.com">
  <img src="https://img.shields.io/badge/Website-farhansadikgalib.com-4F46E5?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Website"/>
</a>
<a href="https://www.linkedin.com/in/farhansadikgalib/">
  <img src="https://img.shields.io/badge/LinkedIn-farhansadikgalib-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
</a>
<a href="https://github.com/farhansadikgalib">
  <img src="https://img.shields.io/badge/GitHub-farhansadikgalib-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"/>
</a>
<a href="https://pub.dev/publishers/farhansadikgalib.com/packages">
  <img src="https://img.shields.io/badge/pub.dev-packages-0553B1?style=for-the-badge&logo=dart&logoColor=white" alt="pub.dev"/>
</a>

If this package saved you time, consider starring the repo ⭐

See the [changelog](CHANGELOG.md) for release notes.
Released under the [MIT License](LICENSE).

</div>
