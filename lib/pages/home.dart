import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/pages/all_news.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/pages/category_news.dart';
import 'package:news_app/services/data.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:news_app/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/news.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<SliderModel> sliders =[];
  List<ArticleModel> articles=[];
  bool _loading=true;

  int activeIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    categories = getCategories();
    getNews();
    getSliders();
    super.initState();
  }
  getNews() async{
    News newsclass = News();
    await newsclass.getNews();
    articles=newsclass.news;
    setState(() {
      _loading=false;
    });

  }

  getSliders() async{
    Sliders slider = Sliders();
    await slider.getSliders();
    sliders=slider.sliders;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
      body: _loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                height: 60,
                child: ListView.builder(
                    // shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryTile(categories[index].categoryName,
                          categories[index].image);
                    }),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Breaking News!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllNews(
                              newsCategory: "Breaking",
                              articles: sliders.map((slider) => ArticleModel(
                                title: slider.title,
                                author: slider.author,
                                description: slider.description,
                                url: slider.url,
                                urlToImage: slider.urlToImage,
                                content: slider.content,
                              )).toList(),
                            ),
                          ),
                        );
                      },
                      child: Text("View All!",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              CarouselSlider.builder(itemCount: 5, itemBuilder: (context,index,realIndex){
                String res = sliders[index].urlToImage!;
                String res1 = sliders[index].title!;
        
                return buildImage(res, index, res1);
              }, options: CarouselOptions(
                height: 250,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                autoPlay: true,
                onPageChanged: (index,reason){
                  setState(() {
                      activeIndex=index;
                  });
                }
              )
              ),
              SizedBox(height: 30,),
              Center(child: buildIndicator()),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Trending News!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllNews(
                              newsCategory: "Trending",
                              articles: articles,
                            ),
                          ),
                        );
                      },
                      child: Text("View All!",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
             Container(
               child: ListView.builder(
                 physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                   itemCount:articles.length,
                   itemBuilder: (context,index){
                 return BlogTile(desc: articles[index].description ,imageUrl: articles[index].urlToImage!.replaceAll(RegExp(r'(?<!:)//'), '/'),title: articles[index].title,url: articles[index].url,);

               }),
             )
            ],
          ),
        ),
      ),
    );
  }
  Widget buildImage(String image,int index,String name)=>Container(
    margin: EdgeInsets.symmetric(horizontal: 5.0) ,
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: image,
            height:250,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
            ),
          )
        ),
        Container(
          height: 250,
          padding: EdgeInsets.only(left: 10),
          margin: EdgeInsets.only(top:170),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              )
          ),
        child:Center(
          child: Text(

            name,
            maxLines: 2,
            style: TextStyle(
                color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w500
            ),
          ),
        )
        )
    ]),
  );

  Widget buildIndicator() => AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: 5,
    effect: SlideEffect(dotWidth: 15,dotHeight: 15,activeDotColor: Colors.blue),
  );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  const CategoryTile(this.categoryName, this.image);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                "assets/${image}",
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Center(
                  child: Text(categoryName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }
}
class BlogTile extends StatelessWidget {
   String? title,desc,imageUrl,url;
  BlogTile({required this.desc,required this.imageUrl,required this.title,required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url!)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10) ,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl!,
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey[300],
                            child: Icon(Icons.error, size: 30, color: Colors.grey[600]),
                          ),
                        ),
                      )
                  ),
                  SizedBox(width: 8,),
                  Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width/1.8,
                          child: Text(title!,
                            maxLines: 2,
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 17),
                          )
                      ),
                      SizedBox(height: 7,),
                      Container(
                          width: MediaQuery.of(context).size.width/1.7,
                          child: Text(desc!,
                            maxLines: 3,
                            style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,fontSize: 16),
                          )
                      ),
                    ],
                  ),
                ],),
            ),
          ),
        ),
      ),
    );
  }
}
