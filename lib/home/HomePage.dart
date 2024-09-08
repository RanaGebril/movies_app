import 'package:flutter/material.dart';
import 'package:movies_app/AppColors.dart';
import 'package:movies_app/browes_screen/Browse.dart';
import 'package:movies_app/home/new_reals.dart';
import 'package:movies_app/home/popular-UI.dart';
import 'package:movies_app/home/recommended.dart';
import 'package:movies_app/watch_list/WatchList.dart';
import 'package:movies_app/api_manager.dart';
import 'package:movies_app/search_screen/search_provider.dart';
import 'package:movies_app/search_screen/search_tab.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primary,
      body: FutureBuilder(
        future: ApiManager.getPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var popularMovies = snapshot.data?.results ?? [];

          return Stack(
            children: [
           PopularUi(),
              Positioned(
                top: 350,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.grey[850],
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: NewReals(),
                      ),
                      SizedBox(height: 15),
                      Recommended()
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: Container(
        color: Color(0xff1a1a1a),
        child: Row(
          children: [
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomePage.routeName);
              },
              icon: Icon(Icons.home_sharp, color: Colors.white),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchTab(
                  searchProvider: Provider.of<SearchProvider>(context, listen: false),
                ),
                );//
              },
              icon: Icon(Icons.search, color: Colors.white),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Browse.routeName);
              },
              icon: Icon(Icons.movie_creation, color: Colors.white),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, WatchListScreen.routeName);
              },
              icon: Icon(Icons.collections_bookmark, color: Colors.white),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
