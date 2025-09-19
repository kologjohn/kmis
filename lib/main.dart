import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksoftsms/controller/accountProvider.dart';
import 'package:ksoftsms/controller/loginprovider.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/routes.dart';
// ✅ import router
import 'controller/statsprovider.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Myprovider()),
        ChangeNotifierProvider(create: (context) => StatsProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kologsoft MIS',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFf3f4ff),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade900),
      ),
      routerConfig: router, //use GoRouter defined in routes.dart
    );
  }
}
