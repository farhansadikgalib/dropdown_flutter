# 1.1.0

Modern UX features — all opt-in and off by default, so existing usage is
unaffected:

- Haptic feedback on open and selection (`enableHapticFeedback`).
- Keyboard navigation: arrow keys to move, Enter to select, Escape to close
  (`enableKeyboardNavigation`, plus `ListItemDecoration.highlightedColor`).
- Search-term highlighting in results (`highlightMatchedText`, plus
  `ListItemDecoration.searchMatchTextStyle`).
- Grouped sections via `groupBy` (with an optional `groupHeaderBuilder`).
- Recent selections pinned at the top (`recentSelectionsMaxCount`,
  `initialRecentItems`, `onRecentItemsChanged`).
- Select-all / clear-all action row for multi-select (`showSelectAll`,
  `selectAllText`, `clearAllText`).
- Configurable open/close animation (`animationDuration`, `animationCurve`).
- Added widget tests for the new features and a "Modern UX" example tab.

# 1.0.0

- Highly Customizable dropdown widget released.

# 1.0.1

- Documentation updated.

# 1.0.2

- Bug fixes and performance improvements.

# 1.0.4

- Replaced deprecated `Color.withOpacity` with `Color.withValues` for forward compatibility with current Flutter.
- Removed the stale `animated_custom_dropdown` library name declaration.
- Upgraded `flutter_lints` and dev dependencies to their latest versions.
- Added widget tests covering rendering, selection, and search filtering.
- `flutter analyze` now reports no issues.

# 1.0.3

- Updated to support latest Android (API 35) and iOS (13.0+) versions
- Updated Gradle to 8.10 and AGP to 8.7.2
- Updated Kotlin to 2.0.21
- Updated to Java 17
- Updated iOS deployment target to 13.0 and Xcode 16.0 support
- Fixed text glyph clipping issue in dropdown list items
- Performance improvements and build optimizations
