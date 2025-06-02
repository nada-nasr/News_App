import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/repository/news/dataSources/remote/news_remote_data_source.dart';
import 'package:news_app/repository/news/dataSources/remote/news_remote_data_source_impl.dart';
import 'package:news_app/repository/news/repository/news_repository.dart';
import 'package:news_app/repository/news/repository/news_repository_impl.dart';
import 'package:translator/translator.dart';

import '../../../../model/NewsResponse.dart';
import '../../../../model/SourceResponse.dart';
import 'news_states.dart';

class NewsViewModel extends Cubit<NewsStates> {
  late NewsRepository newsRepository;
  late NewsRemoteDataSource remoteDataSource;
  late ApiManager apiManager;

  NewsViewModel() : super(NewsLoadingState()) {
    apiManager = ApiManager();
    remoteDataSource = NewsRemoteDataSourceImpl(apiManager: apiManager);
    newsRepository = NewsRepositoryImpl(remoteDataSource: remoteDataSource);
  }

  //todo: hold data, handle logic
  final googleTranslator = GoogleTranslator();
  List<News> allNews = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  int pageSize = 10;

  void getNews(
    Source source,
    String languageCode, {
    bool isLoadMore = false,
  }) async {
    if (isLoading || (!hasMore && !isLoadMore)) {
      return;
    }
    isLoading = true;
    emit(NewsLoadingState(isLoadMore: isLoadMore));

    if (!isLoadMore) {
      allNews.clear();
      currentPage = 1;
      hasMore = true;
    }
    try {
      var response = await newsRepository.getNewsBySourceId(
        sourceId: source.id ?? '',
        language: languageCode,
        pageSize: pageSize,
        page: currentPage,
      );
      if (response?.status == 'ok') {
        List<News> newArticles = [];
        for (var article in response!.articles!) {
          final translatedTitle = await translateText(
            article.title ?? '',
            languageCode,
          );
          final translatedDescription = await translateText(
            article.description ?? '',
            languageCode,
          );
          final translatedContent = await translateText(
            article.content ?? '',
            languageCode,
          );

          newArticles.add(
            article.copyWith(
              title: translatedTitle,
              description: translatedDescription,
              content: translatedContent,
            ),
          );
        }
        allNews.addAll(newArticles);
        currentPage++;
        hasMore = newArticles.length >= pageSize;
        emit(NewsSuccessState(newsList: allNews, hasMore: hasMore));
      } else {
        hasMore = false; // has more data
        emit(
          NewsErrorState(
            errorMessage:
                response?.message ?? 'Failed to load news. Please try again.',
          ),
        );
      }
    } catch (e) {
      hasMore = false;
      emit(NewsErrorState(errorMessage: e.toString()));
    } finally {
      isLoading = false;
    }
  }

  void loadMore(Source source, String languageCode) {
    if (hasMore && !isLoading) {
      getNews(source, languageCode, isLoadMore: true);
    }
  }

  void resetAndFetchNewsForNewSource(Source newSource, String languageCode) {
    allNews.clear();
    currentPage = 1;
    isLoading = false;
    hasMore = true;
    emit(NewsLoadingState());
    getNews(newSource, languageCode, isLoadMore: false);
  }

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      if (text.isEmpty) {
        return '';
      }
      final translation = await googleTranslator.translate(
        text,
        to: targetLanguage,
      );
      return translation.text;
    } catch (e) {
      e.toString();
      return text;
    }
  }
}
