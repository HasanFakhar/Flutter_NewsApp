import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/slider_model.dart';

class Sliders {
  List<SliderModel> sliders = [];
  
  
  Future<void> getSliders() async {
    try {
      String url = 'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=02076782d78840d88393548bdec22a95';
      var response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["status"] == 'ok') {
          jsonData['articles'].forEach((element) {
            if (element["urlToImage"] != null && element["description"] != null) {
              // Clean and validate the image URL
              String imageUrl = element["urlToImage"].toString();
              // Remove any double slashes except after http(s):
              imageUrl = imageUrl.replaceAll(RegExp(r'(?<!:)//'), '/');
              
              SliderModel sliderModel = SliderModel(
                title: element["title"],
                author: element["author"],
                description: element["description"],
                url: element["url"],
                urlToImage: imageUrl,
                content: element["content"],
              );
              sliders.add(sliderModel);
            }
          });
        }
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching sliders: $e');
    }
  }
}