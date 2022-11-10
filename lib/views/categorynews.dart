import 'package:dailynews/helper/newsdata.dart';
import 'package:dailynews/models/newsmodel.dart';
import 'package:dailynews/views/homepage.dart';
import 'package:flutter/material.dart';

class CategoryFragment extends StatefulWidget {
  String category;

  CategoryFragment({super.key, required this.category});

  @override
  State<CategoryFragment> createState() => _CategoryFragmentState();
}

class _CategoryFragmentState extends State<CategoryFragment> {
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  getNews() async {
    CategoryNews newsData = CategoryNews();
    await newsData.getNews(widget.category);
    setState(() {
      _loading = false;
    });
    articles = newsData.datatobesavedin;
  }

  @override
  void initState() {
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.toUpperCase(),
          style: const TextStyle(color: Colors.blueAccent),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: _loading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
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
              ),
            ),
    );
  }
}
