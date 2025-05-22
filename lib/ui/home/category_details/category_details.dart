import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../api/api_manager.dart';
import '../../../model/SourceResponse.dart';
import '../../../model/category.dart';
import '../../../providers/language_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import '../category_details/source_tab_widget.dart';

class CategoryDetails extends StatefulWidget {
  static const String routeName = 'CategoryDetails';

  final Category category;

  const CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  final googleTranslator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLocal;

    return FutureBuilder<SourceResponse?>(
      future: fetchAndTranslateSources(widget.category.id, currentLanguage),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.greyColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something Went Wrong', style: AppStyles.medium20Black),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('Try Again', style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge),
                  ),
                ],
            ),
          );
        } else if (snapshot.data?.status != 'ok') {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!.message!, style: Theme
                      .of(context)
                      .textTheme
                      .headlineLarge),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('Try again', style: AppStyles.medium20Black),
                  ),
                ],
            ),
          );
        }

        var sourcesList = snapshot.data?.sources ?? [];
        return SourceTabWidget(sourcesList: sourcesList);
      },
    );
  }

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      if (text.isEmpty) {
        return '';
      }
      final translation = await googleTranslator.translate(
          text, to: targetLanguage);
      return translation.text;
    } catch (e) {
      print(e);
      return text;
    }
  }

  Future<SourceResponse?> fetchAndTranslateSources(String categoryId,
      String languageCode) async {
    final response = await ApiManager.getSources(
        categoryId: categoryId, language: languageCode);
    if (response?.sources != null) {
      List<Source> translatedSources = [];
      for (var source in response!.sources!) {
        final translatedName = await translateText(
            source.name ?? '', languageCode);
        final translatedDescription = await translateText(
            source.description ?? '', languageCode);
        translatedSources.add(source.copyWith(
          name: translatedName,
          description: translatedDescription,
        ));
      }
      // Create a new SourceResponse with the translated list of sources
      return SourceResponse(
        status: response.status,
        code: response.code,
        message: response.message,
        sources: translatedSources,
      );
    }
    return response;
  }
}