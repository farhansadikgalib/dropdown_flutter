import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

/// A teammate that can be assigned to a task.
///
/// Implements [CustomDropdownListFilter] so search matches on both the name
/// and the role — typing "design" finds every designer, not just people whose
/// name contains it.
class Member with CustomDropdownListFilter {
  const Member(this.name, this.role, this.team);

  final String name;
  final String role;
  final String team;

  @override
  String toString() => name;

  @override
  bool filter(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || role.toLowerCase().contains(q);
  }
}

/// A realistic roster: enough people to make search and grouping meaningful,
/// spread across three teams so `groupBy` has something to show.
const List<Member> members = [
  Member('Ayesha Rahman', 'Product Designer', 'Design'),
  Member('Daniel Okafor', 'Design Lead', 'Design'),
  Member('Priya Nair', 'Frontend Engineer', 'Engineering'),
  Member('Marcus Chen', 'Backend Engineer', 'Engineering'),
  Member('Sofia Almeida', 'Mobile Engineer', 'Engineering'),
  Member('Tomas Novak', 'QA Engineer', 'Engineering'),
  Member('Hannah Weber', 'Product Manager', 'Product'),
  Member('Omar Haddad', 'Data Analyst', 'Product'),
];

/// Task priorities — a short, closed list, ideal for the simplest dropdown.
const List<String> priorities = ['Low', 'Medium', 'High', 'Urgent'];

/// Countries used by the search examples: long enough that filtering is the
/// natural way to find an entry.
const List<String> countries = [
  'Australia',
  'Bangladesh',
  'Brazil',
  'Canada',
  'Germany',
  'India',
  'Indonesia',
  'Japan',
  'Kenya',
  'Malaysia',
  'Mexico',
  'Netherlands',
  'Nigeria',
  'Pakistan',
  'Philippines',
  'Singapore',
  'South Korea',
  'Spain',
  'United Kingdom',
  'United States',
];

/// Groups a member by their team, used by the `groupBy` example.
String groupByTeam(Member member) => member.team;

/// Shared avatar bubble: initials on a tinted circle, coloured deterministically
/// from the name so each person keeps the same colour everywhere.
class MemberAvatar extends StatelessWidget {
  const MemberAvatar({super.key, required this.member, this.size = 34});

  final Member member;
  final double size;

  static const _palette = [
    Color(0xFF6366F1),
    Color(0xFF0EA5E9),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
  ];

  String get _initials {
    final parts = member.name.split(' ');
    return parts.length > 1
        ? '${parts.first[0]}${parts[1][0]}'
        : parts.first[0];
  }

  Color get _color => _palette[member.name.codeUnitAt(0) % _palette.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials,
        style: TextStyle(
          color: _color,
          fontSize: size * .38,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// A member row: avatar, name and role. Shared by the single- and multi-select
/// examples so the list looks the same everywhere.
class MemberTile extends StatelessWidget {
  const MemberTile({
    super.key,
    required this.member,
    this.trailing,
  });

  final Member member;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        MemberAvatar(member: member),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                member.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                member.role,
                style: TextStyle(
                  fontSize: 12.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
