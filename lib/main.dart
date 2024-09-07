import 'package:flutter/material.dart';
import 'package:movies_app/browes_screen/Browse.dart';
import 'package:movies_app/home/HomePage.dart';
import 'package:movies_app/watch_list/WatchList.dart';
import 'package:movies_app/my_theme_data.dart';
import 'package:movies_app/search_screen/search_provider.dart';
import 'package:movies_app/search_screen/search_tab.dart';
import 'package:provider/provider.dart';

void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return MultiProvider(
      providers: [
      ChangeNotifierProvider(
      create: (context) => SearchProvider(),
  ),
  ],
  child:  MaterialApp(
   initialRoute: HomePage.routeName,
   routes: {
    HomePage.routeName: (context) => HomePage(),
    WatchListScreen.routeName:(context) => WatchListScreen(),
    Browse.routeName:(context) => Browse(),
    //SearchTab.routeName:(context) => SearchTab(),

   },
   debugShowCheckedModeBanner: false,
  themeMode: ThemeMode.dark,
   darkTheme: MyThemeData.appTheme,
  )
  );
 }
}
