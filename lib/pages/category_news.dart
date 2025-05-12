import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/show_category.dart';
import '../services/show_category_news.dart';
import 'article_view.dart';
class CategoryNews extends StatefulWidget {
  String? name;
  CategoryNews({required this.name});
  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowModel> articles=[];
  bool  _loading =true ;

  getNews() async{
    ShowCategoryNews newsclass = ShowCategoryNews();
    await newsclass.getCategoryNews(widget.name!.toLowerCase());
    articles=newsclass.categories;
    setState(() {
      _loading=false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(
              widget.name!,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
        ,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount:articles.length,
            itemBuilder: (context,index){
              return ShowCategory(desc: articles[index].description ,Image: articles[index].urlToImage!.replaceAll(RegExp(r'(?<!:)//'), '/'),title: articles[index].title,url:articles[index].url ,);

            }),
      ),
    );
  }
}
class ShowCategory extends StatelessWidget {
String? Image,desc,title,url;

ShowCategory({this.Image, this.desc, this.title,this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url!)));

      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(imageUrl: Image!,width: MediaQuery.of(context).size.width,height: 200,fit: BoxFit.cover,)),
            SizedBox(height: 10,),
            Text(title!,
              maxLines: 2,
              style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
            Text(desc!, maxLines: 3,),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}
