import 'dart:convert';
import 'dart:io';
import 'package:dailynews/apiKey.dart';
import 'package:dailynews/models/newsmodel.dart';
import 'package:http/http.dart';

class News {
  List<ArticleModel> datatobesavedin = <ArticleModel>[];
  final apiKey = apis().getApiKey();

  Future<void> getNews() async {
    var response = await get(
      Uri.parse('http://newsapi.org/v2/top-headlines?country=in'),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          // initliaze our model class

          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );

          datatobesavedin.add(articleModel);
        }
      });
    }
  }
}

class CategoryNews {
  List<ArticleModel> datatobesavedin = [];
  final apiKey = apis().getApiKey();

  Future<void> getNews(String category) async {
    category = category.toLowerCase();
    var response = await get(
      Uri.parse(
          'http://newsapi.org/v2/top-headlines?country=in&category=$category'),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          // initliaze our model class

          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );
          datatobesavedin.add(articleModel);
        }
      });
    }
  }
}
