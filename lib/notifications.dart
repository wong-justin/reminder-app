import 'package:rxdart/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// notifications package documentation:
// https://pub.dev/documentation/flutter_local_notifications/latest/

import 'dart:async';

import 'main.dart';

// obj passed whenever handling notification actions
//  like scheduling, initialization, permissions, etc
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

//final BehaviorSubject<String> selectNotificationSubject = 
//    BehaviorSubject<String>();

void initNotificationPlugin() async {
    
    WidgetsFlutterBinding.ensureInitialized();
    
    NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    
    var initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');//app_icon');
    var initSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
    );
        
    var initSettings = InitializationSettings(
        initSettingsAndroid,
        initSettingsIOS
    );
        
    await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onSelectNotification: selectNotification,
    );
}

Future selectNotification(String payload) async {
    
    if (payload != null) {
        print('notification payload: ' + payload);
    }
//    selectNotificationSubject.add(payload);

}

// listener for when user opens notification:
//selectNotificationSubject.stream.listen((String payload) async {
//    // do something with payload
//});


void scheduleNotification(int id, 
                          String title, 
                          String body, 
                          DateTime scheduledDateTime,) async {
        
    await flutterLocalNotificationsPlugin.schedule(
        id,
        title,
        body,
        scheduledDateTime,
        _platformChannelSpecifics(),
//        androidAllowWhileIdle=true,
    );
}

// current implementation is crummy; only weekly and daily are feasible,
//  and it's inaccurate by many seconds.
// Need to try an isolate background solution,
//  chaining scheduling only one at a time off previous.
// Also, a question: recurring after marked done, 
//  or hard scheduling recur ignoring completions or lack thereof?
//  I would use both.
void scheduleRecurringNotification(int id,
                                   String title,
                                   String body,
                                   RepeatInterval repeatInterval,
                                   DateTime initialDateTime,) async {

    Time time = Time(initialDateTime.hour, 
                     initialDateTime.minute, 
                     0);
    Day day = Day(initialDateTime.weekday-1);
    
    switch (repeatInterval) {
        case RepeatInterval.Daily:
            await flutterLocalNotificationsPlugin.showDailyAtTime(
                id,
                title,
                body,
                time,
                _platformChannelSpecifics(),
            );
            print(time.hour);
            print(time.minute);
            break;
        case RepeatInterval.Weekly:
            await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
                id,
                title,
                body,
                day,
                time,
                _platformChannelSpecifics(),
            );
            print(day);
            print(time.hour);
            print(time.minute);
            break;
        default:
            print('Interval not recognized; recurring notification not scheduled.');
    }
}

NotificationDetails _platformChannelSpecifics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    return NotificationDetails(
        androidPlatformChannelSpecifics, 
        iOSPlatformChannelSpecifics
    );
}

void cancelNotification(int id) async {
    flutterLocalNotificationsPlugin.cancel(id);
}