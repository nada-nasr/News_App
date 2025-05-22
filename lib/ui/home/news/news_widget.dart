import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/providers/language_provider.dart';
import 'package:news_app/ui/home/news/news_item.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';

class NewsWidget extends StatefulWidget {
  final Source source;

  const NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final GoogleTranslator googleTranslator = GoogleTranslator();
  ScrollController scrollController = ScrollController();
  List<News> newsList = [];
  bool isLoading = false;
  bool hasMore = true; // Indicates if there are more pages to load from the API
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchDataByPage();
    scrollController.addListener(() =>
        scrollListener()); // Listener for scroll events
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source.id != oldWidget.source.id) {
      resetAndFetchNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //todo:loading
        if (isLoading && newsList.isEmpty)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.greyColor),
            ),
          )
        else
          if (newsList.isEmpty && !isLoading && !hasMore) // No data found
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No news found for this source.',
                      style: AppStyles.medium20Black),
                  ElevatedButton(
                  onPressed: () {
                    resetAndFetchNews();
                  },
                    child: Text('Try Again', style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge),
                  )
                ],
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  newsList.clear();
                  currentPage = 1;
                  hasMore = true;
                  isLoading = false;
                  return fetchDataByPage();
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: newsList.length + (hasMore || isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < newsList.length) {
                      return NewsItem(news: newsList[index]);
                    } else {
                      // Loading indicator at the bottom
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors
                              .greyColor),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
      ],
    );
  }

  void resetAndFetchNews() {
    setState(() {
      newsList.clear();
      isLoading = false;
      hasMore = true;
      currentPage = 1;
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });
    fetchDataByPage();
  }

  scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent &&
        newsList.isNotEmpty && hasMore && !isLoading) {
      fetchDataByPage(isLoadMore: true);
      print("Reached bottom, fetching more news.");
    }
  }

  fetchDataByPage({bool isLoadMore = false}) async {
    if (isLoading || !hasMore) {
      print(
          "fetchDataByPage skipped. isLoading: $isLoading, hasMore: $hasMore");
      return;
    }

    setState(() {
      isLoading = true;
      if (!isLoadMore) {
        newsList.clear();
        currentPage = 1;
        hasMore = true;
      }
    });

    final languageProvider = Provider.of<LanguageProvider>(
        context, listen: false);
    final languageCode = languageProvider.currentLocal;
    final int pageToFetch = isLoadMore ? currentPage : 1;

    try {
      NewsResponse? response = await ApiManager.getNewsBySourceId(
        sourceId: widget.source.id ?? '',
        language: 'en',
        page: pageToFetch,
      );

      if (response != null && response.articles != null &&
          response.articles!.isNotEmpty) {
        List<News> translatedArticles = [];
        for (var article in response.articles!) {
          final translatedTitle = await translateText(
              article.title, languageCode);
          final translatedDescription = await translateText(
              article.description, languageCode);
          final translatedContent = await translateText(
              article.content, languageCode);

          translatedArticles.add(article.copyWith(
            title: translatedTitle,
            description: translatedDescription,
            content: translatedContent,
          ));
          await Future.delayed(const Duration(milliseconds: 50));
        }

        setState(() {
          newsList.addAll(translatedArticles);
          currentPage++;
          if (response.articles!.length < 20) {
            hasMore = false;
            print("No more data (articles < 20).");
          }
        });
      } else {
        setState(() {
          hasMore = false;
          print("No articles returned from API.");
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        hasMore = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> translateText(String? text, String targetLanguage) async {
    try {
      if (text == null || text.isEmpty) {
        return '';
      }
      final translation = await googleTranslator.translate(
          text, to: targetLanguage);
      return translation.text;
    } catch (e) {
      print(e);
      return text ?? '';
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(() => scrollListener());
    scrollController.dispose();
    super.dispose();
  }
}
