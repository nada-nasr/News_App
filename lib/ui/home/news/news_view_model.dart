import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/NewsResponse.dart';

class NewsViewModel extends ChangeNotifier{
  //todo: hold data, handle logic
  List<News>? newsList;
  String? errorMessage;

  void getNewsBySourceId(String sourceId) async{
    //todo: reinitialize:
    newsList =null;
    errorMessage = null;
    notifyListeners();

    try {
      var response = await ApiManager.getNewsBySourceId(sourceId);
      if(response?.status == "error"){
        //todo: server => error
        errorMessage = response!.message!;
      }else{
        //todo: server => success
        newsList = response!.articles;
      }
    } catch(e){
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}