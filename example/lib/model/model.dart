import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<JobType> jobItems = [
  JobType('Student', Icons.school),
  JobType('Designer', Icons.design_services),
  JobType('Developer', Icons.developer_mode),
  JobType('Consultant', Icons.account_balance),
];

class JobType with CustomDropdownListFilter {
  final String name;
  final IconData icon;

  const JobType(this.name, this.icon);

  @override
  String toString() {
    return name;
  }

  @override
  bool filter(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }
}
