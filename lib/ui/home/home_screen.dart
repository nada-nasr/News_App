import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app/ui/home/category_details/category_details.dart';
import 'package:news_app/ui/home/category_fragment.dart';
import 'package:news_app/ui/home_drawer.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../api/api_manager.dart';
import '../../model/category.dart';
import '../../providers/language_provider.dart';
import '../search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory == null
            ? AppLocalizations.of(context)!.home
            : selectedCategory!.title,
        style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SearchScreen(),), (
                  route) => false);
            },
          )
        ],
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

  void loadCategoryDetails(Category category) async {
    final languageProvider = Provider.of<LanguageProvider>(
        context, listen: false);
    final currentLanguage = languageProvider.currentLocale.languageCode;
    ApiManager.getSources(categoryId: category.id, language: currentLanguage);
  }

  void onCategoryClick(Category newSelectedCategory){
    //todo: newSelectedCategory => user
    selectedCategory = newSelectedCategory;
    loadCategoryDetails(newSelectedCategory);
    setState(() {});

  }

  void onDrawerMenuClick() {
    setState(() {
      selectedCategory = null; // Reset selectedCategory
    });
    Navigator.pop(context);
  }
}
