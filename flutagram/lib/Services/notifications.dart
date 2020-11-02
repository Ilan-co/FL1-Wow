import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutagram/Services/preferences.dart';
import 'package:http/http.dart' as http;

class NotificationsServices {
  final String serverToken =
      'AAAAo2gPmLM:APA91bFVOmlsn4QYLoZV-NvVqQDyr0tt2rDmmeKayAa6Wg-ppGqJH-bbgw5tD4jPur6KwEWYp4y31qDd_Xv3xlx2Aw9VBrnwyGWK2sb3ZT42H7xkx8nKWaPHzWj8lO_Qffyn7vANgpe0';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final PreferencesServices _preferencesServices = PreferencesServices();

  Future<void> sendNotificationsNewFollower(String uidDest) async {
    await _firebaseMessaging.requestNotificationPermissions();
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Un nouvel utilisateur s\'est abonné',
            'title': 'Nouvel abonné'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done'
          },
          'to': uidDest,
        },
      ),
    );
  }

  Future<void> sendNotificationsNewPost() async {
    await _firebaseMessaging.requestNotificationPermissions();
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Nouveau post',
            'title':
                'Un utilisateur que vous suivez a publié une nouvelle photo'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done'
          },
          'to': '/topics/${await _preferencesServices.getUID}',
        },
      ),
    );
  }
}
