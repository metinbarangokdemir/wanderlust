import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderlust/location.dart';
import 'package:wanderlust/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wanderlust/location.dart';
import 'package:wanderlust/weather.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<AuthProvider> providers = [EmailAuthProvider()];
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference emailRef =
        _firestore.collection('wanderlustCollection');
    var UsersRef = _firestore.collection('movies').doc('UserAuthentication');
    providers = [EmailAuthProvider()];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/mainpage',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            headerBuilder: (context, constraints, _) {
              return CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                  "https://render.fineartamerica.com/images/rendered/default/flat/round-beach-towel/images/artworkimages/medium/1/world-map-18-black-background-sharon-cummings.jpg?&targetx=-2&targety=183&imagewidth=788&imageheight=418&modelwidth=788&modelheight=788&backgroundcolor=000000&orientation=0",
                ),
              );
            },
            providers: providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/mainpage');
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Padding(
                padding: const EdgeInsets.only(right: 100.0),
                child: Center(
                  child: Text(
                    "Profile page",
                    style: GoogleFonts.robotoMono(color: Colors.white),
                  ),
                ),
              ),
            ),
            children: [Text("")],
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
        '/mainpage': (context) {
          return MainPage();
        },
        '/personalinfopage': (context) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                TextButton(
                    onPressed: () async {
                      var response = await UsersRef.get();
                      var veri = response.data();
                      print(veri);
                    },
                    child: Text("Email")),
                Text("Password"),
              ],
            ),
          );
        },
        '/findlocation': (context) {
          return findLocation();
        },
        '/weathershow': (context) {
          return ShowWeather();
        },
      },
    );
  }
}
