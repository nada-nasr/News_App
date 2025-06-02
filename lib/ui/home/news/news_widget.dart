import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/di/di.dart';
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
  ScrollController scrollController = ScrollController();
  NewsViewModel viewModel = NewsViewModel(
      newsRepository: injectNewsRepository());

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (viewModel.state is NewsLoadingState) {
      final languageProvider = Provider.of<LanguageProvider>(
          context, listen: false);
      final currentLanguage = languageProvider.currentLocal;
      viewModel.getNews(widget.source, currentLanguage);
    }
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source.id != oldWidget.source.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.minScrollExtent);
        }
        final languageProvider = Provider.of<LanguageProvider>(
            context, listen: false);
        final currentLanguage = languageProvider.currentLocal;
        viewModel.resetAndFetchNewsForNewSource(
            widget.source, currentLanguage);
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    viewModel.close(); // Dispose the ViewModel
    super.dispose();
  }

  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final languageProvider = Provider.of<LanguageProvider>(
          context, listen: false);
      final currentLanguage = languageProvider.currentLocal;
      viewModel.loadMore(widget.source, currentLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLocal;

    return BlocProvider<NewsViewModel>(
      create: (context) => viewModel,
      child: BlocBuilder<NewsViewModel, NewsStates>(
        builder: (context, state) {
          List<News> newsListToDisplay = [];
          bool isLoadingMore = false;
          bool hasMoreNews = false;

          newsListToDisplay = viewModel.allNews;

          if (state is NewsLoadingState) {
            isLoadingMore = state.isLoadMore;

            if (!isLoadingMore && newsListToDisplay.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.greyColor),
              );
            }
          } else if (state is NewsSuccessState) {
            hasMoreNews = state.hasMore;
          } else if (state is NewsErrorState) {
            // If there's an error and no news was loaded previously, show error message
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
                        viewModel.getNews(
                            widget.source, currentLanguage);
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
            hasMoreNews =
            false; // On error during load more, assume no more to prevent infinite attempts
          } else if (state is NewsLoadingState) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.greyColor),
            );
          }

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
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index < newsListToDisplay.length) {
                return NewsItem(news: newsListToDisplay[index]);
              } else {
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