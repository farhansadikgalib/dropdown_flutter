import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:flutter/cupertino.dart';

Future<List<JobType>> _getFakeRequestData(String query) async {
  return await Future.delayed(const Duration(seconds: 1), () {
    return jobItems.where((e) {
      return e.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  });
}

class SearchRequestDropdown extends StatelessWidget {
  const SearchRequestDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<JobType>.searchRequest(
      futureRequest: _getFakeRequestData,
      hintText: 'Search job role',
      onChanged: (value) {
        log('SearchRequestDropdown onChanged value: $value');
      },
      searchRequestLoadingIndicator: const Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class MultiSelectSearchRequestDropdown extends StatelessWidget {
  const MultiSelectSearchRequestDropdown({super.key});
  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<JobType>.multiSelectSearchRequest(
      futureRequest: _getFakeRequestData,
      hintText: 'Search job role',
      onListChanged: (value) {
        log('MultiSelectSearchDropdown onChanged value: $value');
      },
    );
  }
}
