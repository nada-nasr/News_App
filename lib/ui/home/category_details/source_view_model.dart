import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/SourceResponse.dart';

class SourceViewModel extends ChangeNotifier{
  //todo: hold data, handle logic
  List<Source>? sourcesList;
  String? errorMessage;

  void getSources(String categoryId) async{
    //todo: reinitialize:
    sourcesList =null;
    errorMessage = null;
    notifyListeners();

    try{
    var response = await ApiManager.getSources(categoryId);
    if(response?.status == 'error'){
      //todo: server => error
      errorMessage = response!.message!;
    }else{
      //todo: server => success
      sourcesList = response!.sources!;
    }
  } catch(e){
      //todo: error
      errorMessage = e.toString();
    }
    notifyListeners();
    }
}