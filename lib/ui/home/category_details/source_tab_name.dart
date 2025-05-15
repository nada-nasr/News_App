import 'package:flutter/material.dart';
import 'package:news_app/model/SourceResponse.dart';
class SourceTabName extends StatelessWidget {
  Source source;
  bool isSelected;
   SourceTabName({super.key, required this.source, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Text(
      source.name ?? '',
      style: isSelected ?
      Theme.of(context).textTheme.labelLarge :
      Theme.of(context).textTheme.labelMedium,
    );
  }
}
