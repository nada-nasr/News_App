import '../../../../model/NewsResponse.dart';

abstract class NewsStates {} //parent class

class NewsLoadingState extends NewsStates {
  bool isLoadMore;

  NewsLoadingState({this.isLoadMore = false});
}

class NewsErrorState extends NewsStates {
  String errorMessage;

  NewsErrorState({required this.errorMessage});
}

class NewsSuccessState extends NewsStates {
  List<News> newsList;
  bool hasMore;

  NewsSuccessState({required this.newsList, required this.hasMore});
}
