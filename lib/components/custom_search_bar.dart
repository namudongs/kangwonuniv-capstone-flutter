import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearchTermChanged;

  const CustomSearchBar({Key? key, required this.onSearchTermChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '과목명',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onSearchTermChanged(controller.text);
          },
          child: const Text('검색'),
        ),
      ],
    );
  }
}
