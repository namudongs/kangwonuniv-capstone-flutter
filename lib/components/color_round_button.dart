import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ColorRoundButton extends StatelessWidget {
  Function? tapFunc;
  String? title;
  Color? color;
  double? buttonWidth;
  double? buttonHeight;
  double? fontSize;

  ColorRoundButton({
    super.key,
    required this.tapFunc,
    required this.title,
    required this.color,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      padding: const EdgeInsets.only(top: 3, left: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(buttonHeight! / 2),
          border: const Border(
            bottom: BorderSide(color: Colors.black),
            top: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
          )),
      child: MaterialButton(
        minWidth: buttonWidth,
        height: 50,
        onPressed: tapFunc as void Function()?,
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Text(
          title!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      ),
    );
  }
}
