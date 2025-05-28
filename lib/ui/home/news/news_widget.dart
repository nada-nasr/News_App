/*import 'package:flutter/material.dart';
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
}*/

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/ui/home/news/cubit/news_states.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import '../../../providers/language_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import 'cubit/news_view_model.dart';
import 'news_item.dart';

class NewsWidget extends StatefulWidget {
  Source source;

  NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  ScrollController scrollController = ScrollController();
  NewsViewModel viewModel = NewsViewModel();
  List<News> newsList = [];
  bool isLoadingMore = false;
  bool hasMoreNews = false;

  @override
  void initState() {
    super.initState();
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.currentLocal;
    scrollController.addListener(onScroll);
    viewModel.getNews(widget.source, currentLanguage);
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if the source has changed
    if (widget.source.id != oldWidget.source.id) {
      scrollController.jumpTo(scrollController.position.minScrollExtent); // Scroll to top
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final currentLanguage = languageProvider.currentLocal;
      viewModel.resetAndFetchNewsForNewSource(widget.source, currentLanguage);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLocal;
    return BlocProvider(
      create: (context) => viewModel,
      child: BlocBuilder<NewsViewModel, NewsStates>(
        builder: (context, state) {
          //todo:loading
          if (state is NewsLoadingState) {
            if (state.isLoadMore == false && newsList.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.greyColor,
                ),
              );
            }
            isLoadingMore = true;
            if (viewModel.allNews.isNotEmpty) {
              newsList = viewModel.allNews;
            }
          } else if (state is NewsSuccessState) {
            newsList = state.newsList;
            hasMoreNews = state.hasMore;
          }
          //todo: error => client
          else if (state is NewsErrorState) {
            if (newsList.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.getNews(widget.source, currentLanguage);
                    },
                    child: Text('Try Again',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineLarge),
                  )
                ],
              );
            }
          }

          newsList = viewModel.allNews;
          hasMoreNews = false;

          if (newsList.isEmpty && !isLoadingMore && !hasMoreNews) {
            return Center(
              child: Text(
                'No news available for this source.',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

        return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == newsList.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: isLoadingMore
                        ? CircularProgressIndicator(
                        color: AppColors.greyColor)
                        : (hasMoreNews
                        ? Container()
                        : Text('No more news',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge,
                    )),
                  ),
                );
              }
              return NewsItem(news: newsList[index]);
            },
            itemCount:newsList.length + (viewModel.hasMore ? 1 : 0), // Add 1 for loading indicator
          );
        },
      ),
    );
  }

  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent){
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final currentLanguage = languageProvider.currentLocal;
      viewModel.loadMore(widget.source, currentLanguage);

    }
    }
  }

*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/model/SourceResponse.dart';
import 'package:news_app/providers/language_provider.dart';
import 'package:news_app/ui/home/news/cubit/news_states.dart';
import 'package:news_app/ui/home/news/cubit/news_view_model.dart';
import 'package:news_app/ui/home/news/news_item.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../model/NewsResponse.dart';

class NewsWidget extends StatefulWidget {
  final Source source;

  const NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  ScrollController _scrollController = ScrollController();
  late NewsViewModel _newsViewModel;

  @override
  void initState() {
    super.initState();
    _newsViewModel = NewsViewModel();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger initial fetch ONLY if the ViewModel is in its initial state.
    // This prevents unnecessary re-fetches if didChangeDependencies is called for other reasons.
    if (_newsViewModel.state is NewsLoadingState) {
      final languageProvider = Provider.of<LanguageProvider>(
          context, listen: false);
      final currentLanguage = languageProvider.currentLocal;
      if (currentLanguage != null) {
        _newsViewModel.getNews(widget.source, currentLanguage);
      }
    }
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source.id != oldWidget.source.id) {
      // DEFER the scroll and fetch operation to after the current frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only jump if controller is attached and has clients
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        }
        final languageProvider = Provider.of<LanguageProvider>(
            context, listen: false);
        final currentLanguage = languageProvider.currentLocal;
        if (currentLanguage != null) {
          _newsViewModel.resetAndFetchNewsForNewSource(
              widget.source, currentLanguage);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _newsViewModel.close(); // Dispose the ViewModel
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final languageProvider = Provider.of<LanguageProvider>(
          context, listen: false);
      final currentLanguage = languageProvider.currentLocal;
      if (currentLanguage != null) {
        _newsViewModel.loadMore(widget.source, currentLanguage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLocal;

    return BlocProvider<NewsViewModel>(
      create: (context) => _newsViewModel,
      child: BlocBuilder<NewsViewModel, NewsStates>(
        builder: (context, state) {
          List<News> newsListToDisplay = [];
          bool isLoadingMore = false;
          bool hasMoreNews = false;

          // Access the accumulated news list from the ViewModel's public getter.
          newsListToDisplay = _newsViewModel.allNews;

          if (state is NewsLoadingState) {
            isLoadingMore = state.isLoadMore;

            // If it's an initial load and no news yet, show full screen loading
            if (!isLoadingMore && newsListToDisplay.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.greyColor),
              );
            }
          } else if (state is NewsSuccessState) {
            hasMoreNews = state.hasMore;
          } else if (state is NewsErrorState) {
            // If there's an error and no news was loaded previously, show a prominent error message
            if (newsListToDisplay.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (currentLanguage != null) {
                          _newsViewModel.getNews(
                              widget.source, currentLanguage);
                        }
                      },
                      child: Text(
                        'Try Again',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineLarge,
                      ),
                    ),
                  ],
                ),
              );
            }
            // If error during load more, show existing news and a subtle message (or nothing)
            print("Error during load more: ${state.errorMessage}");
            hasMoreNews =
            false; // On error during load more, assume no more to prevent infinite attempts
          } else if (state is NewsLoadingState) {
            // When the ViewModel is first created, show an initial loading indicator
            return Center(
              child: CircularProgressIndicator(color: AppColors.greyColor),
            );
          }

          // Handle cases where the list is empty after attempting to load (e.g., source has no articles)
          if (newsListToDisplay.isEmpty && !isLoadingMore && !hasMoreNews) {
            return Center(
              child: Text(
                'No news available for this source.',
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < newsListToDisplay.length) {
                return NewsItem(news: newsListToDisplay[index]);
              } else {
                // This is the last item for the loading/end-of-list indicator
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: isLoadingMore
                        ? CircularProgressIndicator(color: AppColors.greyColor)
                        : (hasMoreNews
                        ? Container() // If hasMore is true but not loading, don't show anything (wait for scroll)
                        : Text(
                      'No more news',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge,
                    )),
                  ),
                );
              }
            },
            itemCount: newsListToDisplay.length +
                (isLoadingMore || hasMoreNews ? 1 : 0),
          );
        },
      ),
    );
  }
}