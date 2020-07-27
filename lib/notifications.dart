import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'main.dart';

void initNotificationPlugin() async {
    
    WidgetsFlutterBinding.ensureInitialized();
    
    final BehaviorSubject<String> selectNotificationSubject = 
        BehaviorSubject<String>();
    
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
        onSelectNotification: (String payload) async {
            if (payload != null) {
                print('notification payload: ' + payload);
            }
            selectNotificationSubject.add(payload);
            
            // listener for when user opens notification:
//            selectNotificationSubject.stream.listen((String payload) async {
//                // do something with payload
//            });
        }
    );
}
