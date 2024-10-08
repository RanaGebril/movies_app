import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/browes_screen/Browse.dart';
import 'package:movies_app/firebase_options.dart';
import 'package:movies_app/home/HomePage.dart';
import 'package:movies_app/search_screen/search_provider.dart';
import 'package:movies_app/watch_list/WatchList.dart';
import 'package:movies_app/my_theme_data.dart';
import 'package:provider/provider.dart';
import 'movie _details/movie_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        )
      ],
      child: MaterialApp(
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          WatchListScreen.routeName: (context) => WatchListScreen(),
          Browse.routeName: (context) => Browse(),
          MovieDetailsScreen.routeName: (context) => MovieDetailsScreen(),
        },
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: MyThemeData.appTheme,
      ),
    );
  }
}
