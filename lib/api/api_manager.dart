import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/api/api_constants.dart';
import 'package:news_app/api/end_points.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/model/SourceResponse.dart';

class ApiManager{
  static Future<SourceResponse?> getSources(String categoryId) async {
    //https://newsapi.org/v2/top-headlines/sources?apiKey=fb5c1d9f790443fd88d0fbc326e23284
    Uri url = Uri.https(
        ApiConstants.serverName,
        EndPoints.sourceApi,
      {
        'apiKey' : ApiConstants.apiKey,
        'category' : categoryId,
        ///'language' : langId
      }
    );
    try {
      var response = await http.get(url);
      var bodyString = response.body; //string
      // String => json => object
      var json = jsonDecode(bodyString); // json
      return SourceResponse.fromJson(json);

      ///SourceResponse.fromJson(jsonDecode(response.body));
    }catch(e){
      throw e;
    }
  }

  //https://newsapi.org/v2/everything?q=bitcoin&apiKey=fb5c1d9f790443fd88d0fbc326e23284

static Future<NewsResponse?> getNewsBySourceId(String sourceId) async{
    Uri url = Uri.https(
      ApiConstants.serverName,
      EndPoints.newsApi,
      {
        'apiKey' : ApiConstants.apiKey,
        'sources' : sourceId
      }
    );
    try {
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return NewsResponse.fromJson(json);
    }catch(e){
      throw e;
    }
    
}
}