# flutter_agc_mockup_3_f23

The main changes in this version are:

* The use of [Riverpod](https://riverpod.dev/) for state management. The data model entities are now accessed using Providers. This gets us closer to the design pattern we will use when we actually have a back-end database.

* The ability to add and edit garden data using the Add Garden and Edit Garden pages. These pages implement forms using [Flutter Form Builder](https://pub.dev/packages/flutter_form_builder). 

* The ability to login as any defined user by entering their email. The password field is not checked, you can leave it blank. The signin page updates the currentUserID Riverpod provider with the email of the defined user for access by the rest of the app. If you enter an email that is not associated with a defined user (see the user_db.dart file), the UI will let you know and not let you proceed to the Home Page.

* The use of the [Flex Color Scheme](https://pub.dev/packages/flex_color_scheme) package to provide a custom color scheme. 

## Installation

After downloading, cd into the directory and invoke:

```
flutter run
```

On my platform, that brings up the iOS simulator and the following:

```
$ flutter run
Launching lib/main.dart on iPhone 13 Pro in debug mode...
Updating project for Xcode compatibility.
Upgrading project.pbxproj
Upgrading Runner.xcscheme
Running Xcode build...                                                  
 └─Compiling, linking and signing...                         3.7s
Xcode build done.                                           13.8s
[VERBOSE-2:FlutterDarwinContextMetalImpeller.mm(37)] Using the Impeller rendering backend.
Syncing files to device iPhone 13 Pro...                           138ms

Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on iPhone 13 Pro is available at: http://127.0.0.1:49989/eg6HXMzOw3I=/
The Flutter DevTools debugger and profiler on iPhone 13 Pro is available at:
http://127.0.0.1:9102?uri=http://127.0.0.1:49989/eg6HXMzOw3I=/
```

## Screenshots

Here are screen shots that illustrate the changes in this version of the mockup.

Click on any screen shot to see it full-size.

<p style="text-align: center">
  <img src="./README-screenshots/screen-1.png" width="20%">
&nbsp; &nbsp; 
  <img src="./README-screenshots/screen-2.png" width="20%">
&nbsp; &nbsp; 
  <img src="./README-screenshots/screen-3.png" width="20%">

  <img src="./README-screenshots/screen-4.png" width="20%">
</p>
