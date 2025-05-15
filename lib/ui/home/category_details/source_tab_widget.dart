import 'package:flutter/material.dart';
import 'package:news_app/ui/home/news/news_widget.dart';
import 'package:news_app/ui/home/category_details/source_tab_name.dart';
import 'package:news_app/utils/app_colors.dart';

import '../../../model/SourceResponse.dart';
class SourceTabWidget extends StatefulWidget {
  List<Source> sourcesList;

   SourceTabWidget({super.key, required this.sourcesList});

  @override
  State<SourceTabWidget> createState() => _SourceTabWidgetState();
}

class _SourceTabWidgetState extends State<SourceTabWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.sourcesList.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Theme.of(context).indicatorColor,
              dividerColor: AppColors.transparentColor,
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
              },
                tabs: widget.sourcesList.map((source) {
                  return SourceTabName(
                      source: source,
                      isSelected: selectedIndex == widget.sourcesList.indexOf(source)
                  );
                }).toList()
            ),
            Expanded(child: NewsWidget(source: widget.sourcesList[selectedIndex]))

          ])
    );
  }
}

