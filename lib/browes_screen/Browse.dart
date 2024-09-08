import 'package:flutter/material.dart';
import 'package:movies_app/AppColors.dart';
import 'package:movies_app/browes_screen/BrowseCategory.dart';
import 'package:movies_app/browes_screen/DisplayingMoviesByCategory.dart';
import 'package:movies_app/browes_screen/categories.dart';
import 'package:movies_app/home/HomePage.dart';
import 'package:movies_app/nav_bar.dart';
import 'package:movies_app/search_screen/search_provider.dart';
import 'package:movies_app/search_screen/search_tab.dart';
import 'package:movies_app/watch_list/WatchList.dart';
import 'package:movies_app/api_manager.dart';
import 'package:provider/provider.dart';


class Browse extends StatefulWidget {
  static const String routeName = 'browse';

  const Browse({super.key});

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  late Future<BrowseCategory> _browseCategoryFuture;

  @override
  void initState() {
    super.initState();
    _browseCategoryFuture = ApiManager.getBrowseCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Browse Category'),
      ),
      backgroundColor: Appcolors.primary,
      body: FutureBuilder<BrowseCategory>(
        future: _browseCategoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.genres == null) {
            return Center(child: Text('No data available'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data!.genres!.length,
              itemBuilder: (context, index) {
                var genre = snapshot.data!.genres![index];
                String imageUrl = 'assets/images/Migration.jpg';

                return Categories(
                  imageUrl: imageUrl,
                  genreName: genre.name ?? '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesByCategoryScreen(
                          categoryId: genre.id!,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
