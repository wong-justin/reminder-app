# reminder-app

Task reminder app, made with Flutter.

## About

Simple productivity app to set reminders or to-dos and get 
notifications. Good for recurring tasks that may be forgotten, 
whether to build good habits or work on chores. 

No cluttering your master calendar with many mundane tasks.
No internet connection needed.

Features (_soon to be implemented_):
- notifications on tasks due
- recurring tasks
- to-do items without due date
- prioritization
- filter/search

Features later implemented with platform specific code:
- Additional interactivity on notifications 
(eg mark as done, remind me later buttons)
- More custom recurring options 
(eg first and last Monday of month, not just daily/weekly/monthly options. 
Maybe implement with custom platform code? (see some Android [example code](https://github.com/ppicas/flutter-android-background/blob/master/android/app/src/main/kotlin/com/example/background/Notifications.kt)
    used with MethodChannels.)
Maybe implement with [isolates](https://api.dart.dev/stable/2.0.0/dart-isolate/dart-isolate-library.html)
for each recurring task? 
Each tracks its own notification schedule and schedules one new notification once previous is sent, 
    and one manager to tell when to stop/cancel/edit/proceed. 
Possibly only need Dart code that way, 
    no platform specific code necessary. 
    And it would avoid [problem of advance month (or higher unit) calculation.](https://github.com/MaikuB/flutter_local_notifications/issues/91)


## Usage

- [Install Flutter](https://flutter.dev/docs/get-started/install)
- `flutter devices` to make sure you have 
an actual Android device connected by USB or 
an Android emulator from AndroidStudio running (see [install page](https://flutter.dev/docs/get-started/install/windows) again).
- download this repo and `cd` into it.
- `flutter run`


