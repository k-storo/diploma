import 'package:ar_navigator/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ar_navigator/screens/HomeScreen.dart';
import 'package:ar_navigator/screens/LoginScreen.dart';
import 'package:ar_navigator/screens/SignupScreen.dart';
import 'package:provider/provider.dart';
//import 'package:dcdg/dcdg.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'AR-Navigator',
        theme: ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : HomeScreen.idScreen,
        routes: {
          SignupScreen.idScreen: (context) => SignupScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          HomeScreen.idScreen: (context) => HomeScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
