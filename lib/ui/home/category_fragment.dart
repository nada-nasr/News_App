import 'package:flutter/material.dart';
import 'package:news_app/model/category.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';

class CategoryFragment extends StatelessWidget {
  static const String routeName = 'CategoryFragment';
  List<Category> categoriesList = [];
  Function onButtonClick;

  CategoryFragment({super.key, required this.onButtonClick});


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var themeProvider = Provider.of<ThemeProvider>(context);
    var languageProvider = Provider.of<LanguageProvider>(context);
    categoriesList = Category.getCategoriesList(themeProvider.isDarkMode());
    return Container(
      margin:EdgeInsets.symmetric(
          horizontal: width*0.02,
          vertical: height*0.02
      ) ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)!.good_morning,
          style: Theme.of(context).textTheme.headlineMedium),
          Text(AppLocalizations.of(context)!.here_is_some_news,
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: height*0.02),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Stack(
                        alignment: (index % 2 == 0)
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft,
                        children: [
                          Image.asset(categoriesList[index].image),
                          languageProvider.currentLocal == 'en'
                              ? Container(
                            padding: EdgeInsets.only(
                              left: width * 0.03,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.02
                            ),
                            width: width * 0.38,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(84),
                                color: AppColors.greyColor
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.view_all,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headlineMedium),
                                  CircleAvatar(
                                    backgroundColor: Theme
                                        .of(context)
                                        .primaryColor,
                                    child: IconButton(
                                        onPressed: () {
                                          //todo: category details
                                          onButtonClick(categoriesList[index]);
                                        },
                                        icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Theme
                                                .of(context)
                                                .indicatorColor)
                                    ),
                                  )
                                ]),
                          )
                              : Container(
                            padding: EdgeInsets.only(
                              right: width * 0.03,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.02
                            ),
                            width: width*0.38,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(84),
                                color: AppColors.greyColor
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.view_all,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headlineMedium),
                                  CircleAvatar(
                                    backgroundColor: Theme
                                        .of(context)
                                        .primaryColor,
                                    child: IconButton(
                                        onPressed: () {
                                          //todo: category details
                                          onButtonClick(categoriesList[index]);
                                        },
                                        icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Theme
                                                .of(context)
                                                .indicatorColor)
                                    ),
                                  )
                                ]),
                          )
                        ]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height*0.02);
                  },
                  itemCount: categoriesList.length)
          )
        ]),
    );
  }
}
