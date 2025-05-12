import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../models/slider_model.dart';
import '../services/news.dart';
import '../services/slider_data.dart';
import 'article_view.dart';

class AllNews extends StatefulWidget {
  final String newsCategory;
  final List<ArticleModel> articles;
  
  const AllNews({super.key, required this.newsCategory, required this.articles});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter'),
            Text(
              'News',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.articles.length,
          itemBuilder: (context, index) {
            return BlogTile(
              desc: widget.articles[index].description,
              imageUrl: widget.articles[index].urlToImage!.replaceAll(RegExp(r'(?<!:)//'), '/'),
              title: widget.articles[index].title,
              url: widget.articles[index].url,
            );
          }
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  String? title, desc, imageUrl, url;
  BlogTile({required this.desc, required this.imageUrl, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url!)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    title!,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    desc!,
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

