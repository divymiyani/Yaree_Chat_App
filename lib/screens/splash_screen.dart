import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaree_chat_app/screens/HomeScreen.dart';
import 'package:yaree_chat_app/screens/auth/loginScreen.dart';
import '../../main.dart';
import '../api/apis.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        // SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.black),
      );

      if (APIs.auth.currentUser != null) {
        log('\n User: ${APIs.auth.currentUser}');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query..
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //body
      body: Stack(
        children: [
          //app logo
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/icon.png'),
          ),
          //google login button
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                "MADE BY YAREE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              )),
        ],
      ),
    );
  }
}
