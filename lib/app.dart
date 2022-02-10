import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wiredash/wiredash.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _navigatorKey = GlobalKey<NavigatorState>();

    return Wiredash(
        projectId: 'cookbook-khc6a8h',
        secret: 'GuFept3iNxn4-4skMS9hoBwmFGoL7YbS',
        navigatorKey: _navigatorKey,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'The Cookbook',
          navigatorKey: _navigatorKey,
          home: const HomeScreen(),
          builder: EasyLoading.init(),
        )
      );
  }
}
