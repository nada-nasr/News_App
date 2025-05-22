
import 'SourceResponse.dart';

class NewsResponse {
  NewsResponse({
      this.status, 
      this.totalResults, 
      this.articles,
      this.code,
      this.message});

  NewsResponse.fromJson(dynamic json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = [];
      json['articles'].forEach((v) {
        articles?.add(News.fromJson(v));
      });
    }
  }
  String? status;
  int? totalResults;
  List<News>? articles;
  String? code;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['totalResults'] = totalResults;
    if (articles != null) {
      map['articles'] = articles?.map((v) => v.toJson()).toList();
    }
    map['code'] = code;
    map['message'] = message;
    return map;
  }

  NewsResponse copyWith({
    String? status,
    int? totalResults,
    List<News>? articles,
    String? code,
    String? message,
  }) {
    return NewsResponse(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      articles: articles ?? this.articles,
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }
}


class News {
  News({
      this.source, 
      this.author, 
      this.title, 
      this.description, 
      this.url, 
      this.urlToImage, 
      this.publishedAt, 
      this.content,});

  News.fromJson(dynamic json) {
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    //publishedAt = json['publishedAt'];
    publishedAt = json['publishedAt'] != null
        ? DateTime.tryParse(json['publishedAt'] as String)
        : null;
    content = json['content'];
  }
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;

  //String? publishedAt;
  DateTime? publishedAt;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (source != null) {
      map['source'] = source?.toJson();
    }
    map['author'] = author;
    map['title'] = title;
    map['description'] = description;
    map['url'] = url;
    map['urlToImage'] = urlToImage;
    //map['publishedAt'] = publishedAt;
    map['publishedAt'] = publishedAt?.toIso8601String();
    map['content'] = content;
    return map;
  }

  News copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    //String? publishedAt,
    DateTime? publishedAt,
    String? content,
  }) {
    return News(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

}
