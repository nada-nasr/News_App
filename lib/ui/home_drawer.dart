import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app/ui/widget/drawer_item.dart';
import 'package:news_app/utils/app_assets.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class HomeDrawer extends StatefulWidget {
  final Function onDrawerMenuClick;
   HomeDrawer({super.key, required this.onDrawerMenuClick});


  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String? selectedLanguage;
  ThemeMode? selectedTheme;

  @override
  void initState() {
    super.initState();
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    selectedLanguage = languageProvider.currentLocale.languageCode;
    selectedTheme = themeProvider.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: height * 0.25,
          color: AppColors.whiteColor,
          child: Text("News App", style: AppStyles.bold24Black),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.02,
            vertical: height * 0.02,
          ),
          child: Row(
            children: [
              Image.asset(AppAssets.homeDrawer),
              TextButton(
                child: Text(AppLocalizations.of(context)!.go_to_home
                , style: AppStyles.bold20white),
                onPressed: () {
                  //todo: go to home screen
                  widget.onDrawerMenuClick();

                },
              ),
            ],
          ),
        ),
        Divider(
          color: AppColors.whiteColor,
          indent: width * 0.04,
          endIndent: width * 0.04,
        ),
        DrawerItem(image: AppAssets.themeIcon, text: AppLocalizations.of(context)!.theme),
        Container(
          margin: EdgeInsets.symmetric(horizontal: height * 0.02),
          child: DropdownMenu(
            width: 270,
            expandedInsets: EdgeInsets.zero,
            menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.whiteColor)),
            textStyle: AppStyles.bold20white,
            trailingIcon: Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.whiteColor,
              size: 34,
            ),
            selectedTrailingIcon: Icon(
              Icons.arrow_drop_up_rounded,
              color: AppColors.whiteColor,
              size: 34,
            ),
            initialSelection: selectedTheme,
            onSelected: (ThemeMode? value) {
              if (value != null) {
                setState(() {
                  selectedTheme = value; // Update the state
                });
                themeProvider.changeTheme(value);
              }
            },
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.whiteColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.whiteColor, width: 2),
              ),
            ),
            dropdownMenuEntries: <DropdownMenuEntry<ThemeMode>>[
              DropdownMenuEntry<ThemeMode>(
                value: ThemeMode.light,
                label: AppLocalizations.of(context)!.light,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    AppColors.blackColor,
                  ),
                  backgroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
                ),
              ),
              DropdownMenuEntry<ThemeMode>(
                value: ThemeMode.dark,
                label: AppLocalizations.of(context)!.dark,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    AppColors.blackColor,
                  ),
                  backgroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        Divider(
          color: AppColors.whiteColor,
          indent: width * 0.04,
          endIndent: width * 0.04,
        ),
        DrawerItem(image: AppAssets.langIcon, text: AppLocalizations.of(context)!.language),
        Container(
          margin: EdgeInsets.symmetric(horizontal: height * 0.02),
          child: DropdownMenu(
            expandedInsets: EdgeInsets.zero,
            width: 270,
            menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.whiteColor)),
            textStyle: AppStyles.bold20white,
            trailingIcon: Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.whiteColor,
              size: 34,
            ),
            selectedTrailingIcon: Icon(
              Icons.arrow_drop_up_rounded,
              color: AppColors.whiteColor,
              size: 34,
            ),
            initialSelection: selectedLanguage,
            onSelected: (String? value) {
              if (value != null) {
                setState(() {
                  selectedLanguage = value; // Update the state
                });
                languageProvider.changeLanguage(value);
              }
            },
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.whiteColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.whiteColor, width: 2),
              ),
            ),
            dropdownMenuEntries: <DropdownMenuEntry<String>>[
              DropdownMenuEntry<String>(
                value: 'en',
                label: AppLocalizations.of(context)!.english,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    AppColors.blackColor,
                  ),
                ),
              ),
              DropdownMenuEntry<String>(
                value: 'ar',
                label: AppLocalizations.of(context)!.arabic,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
