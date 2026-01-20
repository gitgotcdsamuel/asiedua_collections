// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:openfashion/navigation/favourites.dart';
import 'package:openfashion/screens/accountinfo.dart';
import 'package:openfashion/home/home.dart';
import 'package:openfashion/screens/products/cart.dart';
import 'package:openfashion/screens/products/category.dart';
import 'package:openfashion/screens/splash.dart';
import 'package:openfashion/widget/cartwidget.dart';


import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        
      ),
    );
  }
}
