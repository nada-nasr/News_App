import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app/ui/home/category_details/source_tab_name.dart';
import 'package:news_app/ui/home/news/news_widget.dart';
import 'package:news_app/utils/app_colors.dart';

import '../../../model/SourceResponse.dart';

class SourceTabWidget extends StatefulWidget {
  final List<Source> sourcesList; // Changed to final

  const SourceTabWidget({super.key, required this.sourcesList});

  @override
  State<SourceTabWidget> createState() => _SourceTabWidgetState();
}

class _SourceTabWidgetState extends State<SourceTabWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.sourcesList.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.no_sources_available_for_this_category,
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium,
        ),
      );
    }
    if (selectedIndex >= widget.sourcesList.length) {
      selectedIndex = 0;
    }

    return DefaultTabController(
        length: widget.sourcesList.length,
        initialIndex: selectedIndex,
        child: Column(
            children: [
              TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Theme
                      .of(context)
                      .indicatorColor,
                  dividerColor: AppColors.transparentColor,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  tabs: widget.sourcesList.map((source) {
                    return SourceTabName(
                        source: source,
                        isSelected: selectedIndex ==
                            widget.sourcesList.indexOf(source)
                    );
                  }).toList()
              ),
              Expanded(
                  child: NewsWidget(source: widget.sourcesList[selectedIndex]))

            ])
    );
  }
}