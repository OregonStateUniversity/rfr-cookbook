import 'package:flutter/material.dart';
import 'package:rfr_cookbook/widgets/custom_animation.dart';
import 'config/styles.dart';
import 'screens/home_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wiredash/wiredash.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _navigatorKey = GlobalKey<NavigatorState>();
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Styles.themeColor
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false
      ..customAnimation = CustomAnimation();

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
