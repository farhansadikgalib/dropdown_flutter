import 'package:dropdown_flutter_example/theme.dart';
import 'package:dropdown_flutter_example/widgets/controller_validation_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/decorated_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/modern_ux_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/multi_select_controller_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/multi_select_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/search_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/search_request_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/simple_dropdown.dart';
import 'package:dropdown_flutter_example/widgets/validation_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dropdown Flutter',
      themeMode: _mode,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: Home(onToggleTheme: _toggleTheme, mode: _mode),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key, required this.onToggleTheme, required this.mode});

  final VoidCallback onToggleTheme;
  final ThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // Mark plus wordmark, centred as one unit.
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [scheme.primary, scheme.tertiary],
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              const Text('Dropdown Flutter'),
            ],
          ),
          leading: const SizedBox.shrink(),
          leadingWidth: 8,
          actions: [
            IconButton(
              tooltip: 'Toggle theme',
              onPressed: onToggleTheme,
              icon: Icon(
                mode == ThemeMode.light
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(58),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  labelColor: scheme.onPrimary,
                  unselectedLabelColor: scheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(height: 38, text: 'Single'),
                    Tab(height: 38, text: 'Multi'),
                    Tab(height: 38, text: 'Modern UX'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [_SingleTab(), _MultiTab(), _ModernTab()],
        ),
      ),
    );
  }
}

const _padding = EdgeInsets.fromLTRB(16, 8, 16, 32);
const _gap = SizedBox(height: 14);

/// Caps content width and centres it, so the gallery stays readable on
/// tablets and desktop rather than stretching edge to edge.
class _CenteredList extends StatelessWidget {
  const _CenteredList({required this.listKey, required this.children});

  final String listKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          key: ValueKey(listKey),
          padding: _padding,
          children: children,
        ),
      ),
    );
  }
}

class _SingleTab extends StatelessWidget {
  const _SingleTab();

  @override
  Widget build(BuildContext context) {
    return _CenteredList(
      listKey: 'single-tab-list',
      children: [
        const DemoCard(
          icon: Icons.list_alt_rounded,
          title: 'Simple dropdown',
          subtitle: 'A short list of strings with an initial selection.',
          child: SimpleDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.search_rounded,
          title: 'Search dropdown',
          subtitle: 'Filter a long local list as you type.',
          child: SearchDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.cloud_outlined,
          title: 'Network search',
          subtitle: 'Debounced async lookup against a directory.',
          child: SearchRequestDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.palette_outlined,
          title: 'Fully decorated',
          subtitle: 'Custom fill, shadow, search field and rows.',
          child: DecoratedDropdown(),
        ),
        _gap,
        DemoCard(
          icon: Icons.rule_rounded,
          title: 'Form validation',
          subtitle: 'Drops into a Form and validates on submit.',
          child: ValidationDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.settings_remote_rounded,
          title: 'Controller + validation',
          subtitle: 'Read and clear the selection from code.',
          child: ControllerValidationDropdown(),
        ),
      ],
    );
  }
}

class _MultiTab extends StatelessWidget {
  const _MultiTab();

  @override
  Widget build(BuildContext context) {
    return _CenteredList(
      listKey: 'multi-tab-list',
      children: [
        const DemoCard(
          icon: Icons.checklist_rounded,
          title: 'Multi select',
          subtitle: 'Assign several teammates at once.',
          child: MultiSelectDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.manage_search_rounded,
          title: 'Multi select + search',
          subtitle: 'Multi selection over a filtered list.',
          child: MultiSelectSearchDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.travel_explore_rounded,
          title: 'Multi select network search',
          subtitle: 'Async lookup with multiple selections.',
          child: MultiSelectSearchRequestDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.brush_outlined,
          title: 'Decorated multi select',
          subtitle: 'Dark surface with custom checkbox rows.',
          child: MultiSelectDecoratedDropdown(),
        ),
        _gap,
        DemoCard(
          icon: Icons.fact_check_outlined,
          title: 'Multi select validation',
          subtitle: 'Requires at least one selection.',
          child: MultiSelectValidationDropdown(),
        ),
        _gap,
        const DemoCard(
          icon: Icons.tune_rounded,
          title: 'Multi select controller',
          subtitle: 'Add, remove and clear from code.',
          child: MultiSelectControllerDropdown(),
        ),
      ],
    );
  }
}

class _ModernTab extends StatelessWidget {
  const _ModernTab();

  @override
  Widget build(BuildContext context) {
    return _CenteredList(
      listKey: 'modern-tab-list',
      children: const [
        DemoCard(
          icon: Icons.auto_awesome_outlined,
          title: 'Grouped + keyboard + haptics',
          subtitle: 'Team headers, arrow-key nav and recents.',
          child: ModernUxDropdown(),
        ),
        _gap,
        DemoCard(
          icon: Icons.text_fields_rounded,
          title: 'Match highlighting',
          subtitle: 'Emphasises the matched text as you type.',
          child: HighlightSearchDropdown(),
        ),
        _gap,
        DemoCard(
          icon: Icons.done_all_rounded,
          title: 'Select all',
          subtitle: 'A select-all / clear-all row above the list.',
          child: SelectAllDropdown(),
        ),
      ],
    );
  }
}
