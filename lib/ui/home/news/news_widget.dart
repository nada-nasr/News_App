import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../providers/language_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import 'news_item.dart';

class NewsWidget extends StatefulWidget {
  Source source;

  NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final googleTranslator = GoogleTranslator();
  List<News> newsList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true; // To check if there are more pages to load
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    fetchNews();
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if the source has changed
    if (widget.source.id != oldWidget.source.id) {
      // Reset state and fetch news for the new source
      scrollController.removeListener(onScroll); // Remove old listener
      scrollController.dispose(); // Dispose old controller
      scrollController = ScrollController(); // Create new controller
      scrollController.addListener(onScroll); // Add new listener

      newsList.clear();
      currentPage = 1;
      isLoading = false;
      hasMore = true;
      fetchNews(isInitialFetch: true); // Fetch news for the new source
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLocal;
    return FutureBuilder<NewsResponse?>(
      future: fetchAndTranslateNews(
        widget.source.id ?? '',
        currentLanguage,
        currentPage,
      ),
      builder: (context, snapshot) {
        //todo:loading
        if (newsList.isEmpty && isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.greyColor),
          );
        } else if (newsList.isEmpty && !isLoading && !hasMore) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No news available for this source',
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineLarge,
              ),
              ElevatedButton(
                onPressed: () {
                  fetchNews();
                },
                child: Text(
                  'Try Again',
                  style: AppStyles.medium20Black,
                ),
              ),
            ],
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index == newsList.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child:
                  isLoading
                      ? CircularProgressIndicator(
                    color: AppColors.greyColor,
                  )
                      : (hasMore
                      ? Container()
                      : Text(
                    'No more news',
                    style:
                    Theme
                        .of(context)
                        .textTheme
                        .headlineLarge,
                  )),
                ),
              );
            }
            return NewsItem(news: newsList[index]);
          },
          itemCount:
          newsList.length +
              (hasMore ? 1 : 0), // Add 1 for loading indicator
        );
      },
    );
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
      print('Translation error: $e');
      return text ?? '';
    }
  }

  Future<NewsResponse?> fetchAndTranslateNews(String sourceId,
      String languageCode,
      int page,) async {
    final response = await ApiManager.getNewsBySourceId(
      sourceId: sourceId,
      language: languageCode,
      page: page,
    );
    if (response?.articles != null) {
      List<News> translatedArticles = [];
      for (var article in response!.articles!) {
        final translatedTitle = await translateText(
          article.title,
          languageCode,
        );
        final translatedDescription = await translateText(
          article.description,
          languageCode,
        );
        final translatedContent = await translateText(
          article.content,
          languageCode,
        );
        final translatedUrl = await translateText(article.url, languageCode);

        translatedArticles.add(
          article.copyWith(
            title: translatedTitle,
            description: translatedDescription,
            content: translatedContent,
            url: translatedUrl,
          ),
        );
      }
      return NewsResponse(
        status: response.status,
        code: response.code,
        message: response.message,
        articles: translatedArticles,
      );
    }
    return response;
  }

  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMore) {
      loadMoreNews();
    }
  }

  Future<void> fetchNews({bool isInitialFetch = true}) async {
    if (isInitialFetch) {
      setState(() {
        currentPage = 1;
        newsList.clear();
        hasMore = true;
      });
    }

    setState(() {
      isLoading = true;
    });

    final languageProvider = Provider.of<LanguageProvider>(
        context, listen: false);
    final currentLanguage = languageProvider.currentLocal;

    try {
      final response = await fetchAndTranslateNews(
        widget.source.id ?? '',
        currentLanguage,
        currentPage,
      );
      if (response?.status == 'ok' && response?.articles != null) {
        setState(() {
          newsList.addAll(response!.articles!);
          if (response.articles!.isEmpty || response.articles!.length < 10) {
            // Assuming 10 news per page
            hasMore = false;
          } else {
            currentPage++;
          }
        });
      } else if (response?.status != 'ok') {
        setState(() {
          hasMore = false;
        });
        if (response?.message != null) {
          print("Server error: ${response?.message}");
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadMoreNews() async {
    if (!isLoading && hasMore) {
      await fetchNews(isInitialFetch: false);
    }
  }
}
