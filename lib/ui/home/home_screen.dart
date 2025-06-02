import 'package:flutter/material.dart';
import 'package:news_app/di/di.dart';
import 'package:news_app/ui/home/category_details/category_details.dart';
import 'package:news_app/ui/home/category_fragment.dart';
import 'package:news_app/ui/home_drawer.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../api/api_manager.dart';
import '../../l10n/app_localizations.dart';
import '../../model/category.dart';
import '../../providers/language_provider.dart';
import '../../repository/sources/dataSources/remote/source_remote_data_source.dart';
import '../../repository/sources/dataSources/remote/source_remote_data_source_impl.dart';
import '../../repository/sources/repository/source_repository.dart';
import '../../repository/sources/repository/source_repository_impl.dart';
import '../search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedLanguage;
  late SourceRepository sourceRepository;
  late SourceRemoteDataSource remoteDataSource;
  late ApiManager apiManager;

  @override
  Widget build(BuildContext context) {
    apiManager = ApiManager();
    remoteDataSource = SourceRemoteDataSourceImpl(apiManager: apiManager);
    sourceRepository = SourceRepositoryImpl(
        remoteDataSource: remoteDataSource,
        offlineDataSource: injectSourceOfflineDataSource());
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
    sourceRepository.getSources(
        categoryId: category.id,
        language: currentLanguage);
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
