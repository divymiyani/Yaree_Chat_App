import 'dart:developer';
import 'dart:io';
// import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yaree_chat_app/api/apis.dart';
import 'package:yaree_chat_app/screens/HomeScreen.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';
// import '../HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\n User: ${user.user}');
        log('\n UserAdditionalInfo: ${user.additionalUserInfo}');

        // if((await a))
        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(' \n _signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Somhting Went Wrong (check Internet!)');
      return null;
    }
  }

  //sign out Function
  _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query..
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to  Yaree Chat App"),
      ),

      //body
      body: Stack(
        children: [
          //app logo
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: Duration(seconds: 2),
            child: Image.asset('images/icon.png'),
          ),

          //google login button
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.width * .2,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: StadiumBorder(),
                  elevation: 1),
              onPressed: () {
                _handleGoogleBtnClick();
              },

              //google icon
              icon: Image.asset('images/google.png', height: mq.height * .06),

              //login with google label
              label: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 19),
                  children: [
                    TextSpan(text: 'Login with '),
                    TextSpan(
                        text: 'Google',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
