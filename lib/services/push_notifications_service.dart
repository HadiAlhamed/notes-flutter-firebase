import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    firebaseMessaging.requestPermission();
    String? token = await firebaseMessaging.getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    print("!======================================! Token");
    print(token ?? "token is null");
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // await Firebase.initializeApp();
    print(message.notification?.title ?? "title is null");
  }
}
