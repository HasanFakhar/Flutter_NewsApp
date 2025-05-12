import 'dart:convert';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;

class News{

  List<ArticleModel> news=[];
  Future<void> getNews()async{
    try {
      
      String url='https://newsapi.org/v2/everything?q=tesla&from=2025-04-11&sortBy=publishedAt&apiKey=02076782d78840d88393548bdec22a95';

      var response= await http.get((Uri.parse(url)));

      if (response.statusCode == 200) {
        var jsonData=jsonDecode(response.body);
        if (jsonData["status"]=='ok'){
          jsonData['articles'].forEach((element){
            if (element["urlToImage"]!=null && element["description"]!=null){
              // Clean and validate the image URL
              String imageUrl = element["urlToImage"].toString();
              // Remove any double slashes except after http(s):
              imageUrl = imageUrl.replaceAll(RegExp(r'(?<!:)//'), '/');
              
              ArticleModel articleModel = new ArticleModel(
                title: element["title"],
                author: element["author"],
                description: element["description"],
                url: element["url"],
                urlToImage: imageUrl,
                content: element["content"],
              );
              news.add(articleModel);
            }
          });
        }
      } else {
        print('Error fetching news: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching news: $e');
    }
  }
}