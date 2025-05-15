import 'package:flutter/material.dart';
import 'package:news_app/ui/home/category_details/category_details.dart';
import 'package:news_app/ui/home/category_fragment.dart';
import 'package:news_app/ui/home_drawer.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../model/category.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory == null
            ? AppLocalizations.of(context)!.home
            : selectedCategory!.title,
        style: Theme.of(context).textTheme.headlineLarge),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.blackColor,
        child: HomeDrawer(onDrawerMenuClick: onDrawerMenuClick,),
      ),
      body: selectedCategory == null
          ? CategoryFragment(onButtonClick: onCategoryClick)
          : CategoryDetails(category: selectedCategory!,)
    );
  }

  Category? selectedCategory;

  void onCategoryClick(Category newSelectedCategory){
    //todo: newSelectedCategory => user
    selectedCategory = newSelectedCategory;
    setState(() {});

  }

  void onDrawerMenuClick() {
    print("onDrawerMenuClick setState called");
    setState(() {
      selectedCategory = null; // Reset selectedCategory
    });
    Navigator.pop(context); // Close the drawer
  }
}
