import 'package:news_app/utils/app_assets.dart';

class Category{
  String id;
  String title;
  String image;

  Category({required this.id, required this.title, required this.image});

  static List<Category> getCategoriesList(bool isDark){
    return [
      Category(id: 'general', title: 'General',
          image: isDark
              ? AppAssets.generalLight
              : AppAssets.generalDark),
      Category(id: 'business', title: 'Business',
          image: isDark
              ? AppAssets.businessLight
              : AppAssets.businessDark),
      Category(id: 'sports', title: 'Sports',
          image: isDark
              ? AppAssets.sportsLight
              : AppAssets.sportsDark),
      Category(id: 'technology', title: 'Technology',
          image: isDark
              ? AppAssets.technologyLight
              : AppAssets.technologyDark),
      Category(id: 'entertainment', title: 'Entertainment',
          image: isDark
              ? AppAssets.entertainmentLight
              : AppAssets.entertainmentDark),
      Category(id: 'health', title: 'Health',
          image: isDark
              ? AppAssets.healthLight
              : AppAssets.healthDark),
      Category(id: 'science', title: 'Science',
          image: isDark
              ? AppAssets.scienceLight
              : AppAssets.scienceDark),
    ];
  }


}