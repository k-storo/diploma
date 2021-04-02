import 'package:ar_navigator/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "loginScreen";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      // <-- STACK AS THE SCAFFOLD PARENT
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage("assets/images/bg.jpg"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
            backgroundColor:
                Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  //logo
                  Image(
                    image: AssetImage("assets/images/logo.png"),
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 60, left: 60),
                    child: Column(
                      children: [
                        //email
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3)),
                          child: TextField(
                            controller: emailTextEditingController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: Icon(
                                Icons.email_outlined,
                                color: Colors.yellow[600],
                              ),
                              hintText: "Електронна пошта",
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //password
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3)),
                          child: TextField(
                            controller: passwordTextEditingController,
                            obscureText: true,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: Icon(
                                Icons.lock_outline,
                                color: Colors.yellow[600],
                              ),
                              hintText: "Пароль",
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //login
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 10),
                            shape: StadiumBorder(),
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          child: Text(
                            'Увійти',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (!emailTextEditingController.text
                                .contains("@")) {
                              displayToastMessage("Некоректна пошта", context);
                            } else if (passwordTextEditingController
                                .text.isEmpty) {
                              displayToastMessage(
                                  "Пароль обов'язковий!", context);
                            } else {
                              signinAndAuthanticateUser(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 320,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white60, width: 1)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, SignupScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      "Вперше тут? Реєстрація",
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void signinAndAuthanticateUser(BuildContext context) async {
    final User user = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Помилка: " + errMsg.toString(), context);
    }))
        .user;

    if (user != null) {
      usersRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.idScreen, (route) => false);
          displayToastMessage("Авторизовано", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage("Користувача не знайдено", context);
        }
      });
    } else {
      displayToastMessage("Помилка авторизації", context);
    }
  }
}
