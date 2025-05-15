
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  Function onButtonClick;
  String text;

  CustomElevatedButton({required this.onButtonClick, required this.text});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.02,
            horizontal: 100
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
      onPressed: () {
        onButtonClick();
      },
    );
  }
}
