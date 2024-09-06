import 'package:flutter/material.dart';
import 'package:movies_app/Browse.dart';
import 'package:movies_app/HomePage.dart';
import 'package:movies_app/WatchList.dart';
import 'package:movies_app/my_theme_data.dart';
import 'package:movies_app/search_provider.dart';
import 'package:movies_app/search_tab.dart';
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
    WatchKListScreen.routeName:(context) => WatchKListScreen(),
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
