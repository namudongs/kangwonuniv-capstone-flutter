// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class MakeInput extends StatelessWidget {
  final String? label;
  final bool? obscureText;
  final TextEditingController? controller;

  const MakeInput({
    super.key,
    this.label,
    this.obscureText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label!,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText!,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(400)),
                borderRadius: BorderRadius.circular(10)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(400)),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
