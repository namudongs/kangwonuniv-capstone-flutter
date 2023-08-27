import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearchTermChanged;

  const CustomSearchBar({super.key, required this.onSearchTermChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search by lname',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onSearchTermChanged,
    );
  }
}
