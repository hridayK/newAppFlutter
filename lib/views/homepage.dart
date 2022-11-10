import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailynews/models/categorymodel.dart';
import 'package:dailynews/views/categorynews.dart';
import 'package:dailynews/views/categorypage.dart';
import 'package:flutter/material.dart';
import 'package:dailynews/models/newsmodel.dart';
import 'package:dailynews/helper/newsdata.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get our categories list

  List<CategoryModel> categories = <CategoryModel>[];

  // get our newslist first

  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  getNews() async {
    News newsdata = News();
    await newsdata.getNews();
    articles = newsdata.datatobesavedin;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment
              .center, // this is to bring the row text in center
          children: const <Widget>[
            Text(
              "ABCD ",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: 70.0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    imageUrl: categories[index].imageUrl,
                    categoryName: categories[index].categoryName,
                  );
                },
              ),
            ),
            _loading == true
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return NewsTemplate(
                        title: articles[index].title,
                        description: articles[index].description,
                        url: articles[index].url,
                        urlToImage: articles[index].urlToImage,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryName, imageUrl;
  const CategoryTile(
      {super.key, required this.categoryName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                CategoryFragment(category: categoryName.toLowerCase()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 170,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 170,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsTemplate extends StatelessWidget {
  String title, description, url, urlToImage;

  NewsTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10.0),
        color: Colors.grey.shade200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: urlToImage,
                width: 380,
                height: 200,
                fit: BoxFit.cover,
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: EdgeInsets.all(4.0),
                child: Text(description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
