import 'dart:developer';
import 'package:firebase_app/auth/login.dart';
import 'package:firebase_app/auth/signup.dart';
import 'package:firebase_app/helper/db_helper.dart';
import 'package:firebase_app/services/push_notifications_service.dart';
import 'package:firebase_app/ui/add_category.dart';
import 'package:firebase_app/ui/edit_category.dart';
import 'package:firebase_app/ui/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotificationsService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.amber,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.grey[100],
          iconTheme: const IconThemeData(
            color: Colors.amber,
          ),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.amber,
          ),
        ),
      ),
      getPages: [
        GetPage(
          name: "/signUp",
          page: (() => const Signup()),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 700),
        ),
        GetPage(
          name: FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified
              ? "/logIn"
              : '/',
          page: (() => const Login()),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 700),
        ),
        GetPage(
          name: FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified
              ? "/"
              : '/homePage',
          page: (() => const HomePage()),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 700),
        ),
        GetPage(
          name: "/addCategory",
          page: (() => const AddCategory()),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 700),
        ),
      ],
    );
  }
}
