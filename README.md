# Redmond Fire & Rescue Cookbook

The Redmond Fire & Rescue (RFR) cookbook is a mobile app that lists and displays RFR's field protocols as PDFs. Individuals who have access to the admin panel can add and remove files. 

## Language and Tools

The app utalizes Flutter and Firebase Storage. 

To get started with flutter:
https://docs.flutter.dev/get-started/install

I recommend using VS Code instead of Android Studio for your dev environment. You will need to use Android studio to get started but beyond that, I found that VS Code was easier to use and runs much faster.

The Flutter documentation is great so be sure to utalize it. 

Here is another good resource for getting started:
https://fluttercrashcourse.com/


To get started with Firebase:
https://firebase.google.com/docs/flutter/setup?platform=ios

To view the pdfs from Firebase Storage in our app we used the Syncfusion pdfviewer library:
https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/pdfviewer/pdfviewer-library.html

We also used Syncfusion for in text search:
https://help.syncfusion.com/flutter/pdf-viewer/text-search#how-to-create-and-display-a-custom-search-toolbar-with-the-search-features

## Deployment

When you are ready to distribute a new version of the application, your first step
is to bump the build number, or version number and build number, in _pubspec.yml_.

TODO

### Android / Google Play Store

TODO

### iOS / Apple App Store

Build a new "app archive" with `flutter build ipa`. 


&copy; 2021 A. Gilmore and M. Moylan.
