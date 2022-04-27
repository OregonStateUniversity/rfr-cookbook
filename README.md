# Redmond Fire & Rescue Cookbook

<a href=https://github.com/osu-cascades/rfr-cookbook.git>theCookbook GitHub Repo</a>

The Redmond Fire & Rescue (RFR) cookbook is a mobile app that lists and displays RFR's field protocols as PDFs. Individuals who have access to the admin panel can add and remove files. 

## Language and Tools  <a href="https://flutter.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="25" height="25"/> </a> <a href="https://firebase.google.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="25" height="25"/> </a>

The app utalizes Flutter and Firebase Storage. 

### <a href=https://docs.flutter.dev/get-started/install> Get started with Flutter </a>

I recommend using VS Code instead of Android Studio for your dev environment. You will need to use Android studio to get 
started but beyond that, I found that VS Code was easier to use and runs much faster.

The Flutter documentation is great so be sure to utalize it. 

<a href="https://fluttercrashcourse.com/">Here is good flutter tutorial</a>.

### <a href="https://firebase.google.com/docs/flutter/setup?platform=ios">Get started with Firebase</a>

To view the pdfs from Firebase Storage in our app we used the <a href="https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/pdfviewer/pdfviewer-library.html">Syncfusion pdfviewer library</a>.

We also used Syncfusion for <a href="https://help.syncfusion.com/flutter/pdf-viewer/text-search#how-to-create-and-display-a-custom-search-toolbar-with-the-search-features">in text search</a>.

### <a href="https://wiredash.io/">Wiredash</a>

We are utilizing wiredash as a way to track feedback from users. 

## Deployment

When you are ready to distribute a new version of the application, your first step
is to bump the build number, or version number and build number, in _pubspec.yml_.

TODO

### Android / Google Play Store

TODO

### iOS / Apple App Store

Build a new "app archive" with `flutter build ipa`. 


&copy; 2021 A. Gilmore and M. Moylan.
