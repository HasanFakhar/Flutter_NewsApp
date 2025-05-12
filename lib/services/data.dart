import 'package:news_app/models/category_model.dart';

List<CategoryModel> getCategories(){

  List<CategoryModel> category=[];

  CategoryModel categoryModel= new CategoryModel('Business','images/business.jpg');
  category.add(categoryModel);

  CategoryModel categoryModel2= new CategoryModel('Entertainment','images/entertainment.jpg');
  category.add(categoryModel2);

  CategoryModel categoryModel3= new CategoryModel('Building','images/building.jpg');
  category.add(categoryModel3);

  CategoryModel categoryModel4= new CategoryModel('General','images/general.jpg');
  category.add(categoryModel4);

  CategoryModel categoryModel5= new CategoryModel('Health','images/health.jpg');
  category.add(categoryModel5);

  CategoryModel categoryModel6= new CategoryModel('Science','images/science.jpg');
  category.add(categoryModel6);

  CategoryModel categoryModel7= new CategoryModel('Sport','images/sport.jpg');
  category.add(categoryModel7);



return category;


}