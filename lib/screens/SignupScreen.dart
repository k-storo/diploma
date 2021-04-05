import 'package:ar_navigator/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatelessWidget {
  static const String idScreen = "signupScreen";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 60, left: 60),
                    child: Column(
                      children: [
                        //name
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3)),
                          child: TextField(
                            controller: nameTextEditingController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: Icon(
                                Icons.verified_user_outlined,
                                color: Colors.yellow[600],
                              ),
                              hintText: "Ім'я",
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
                        //phone
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3)),
                          child: TextField(
                            controller: phoneTextEditingController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: Icon(
                                Icons.contact_phone_outlined,
                                color: Colors.yellow[600],
                              ),
                              hintText: "Номер телефону",
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
                            'Реєстрація',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (nameTextEditingController.text.length < 4) {
                              displayToastMessage(
                                  "Ім'я має містити хоча б 4 символи", context);
                            } else if (!emailTextEditingController.text
                                .contains("@")) {
                              displayToastMessage("Некоректна пошта", context);
                            } else if (phoneTextEditingController
                                .text.isEmpty) {
                              displayToastMessage(
                                  "Номер телефону обов'язковий!", context);
                            } else if (passwordTextEditingController
                                    .text.length <
                                7) {
                              displayToastMessage(
                                  "Пароль має містити більше 6 символів",
                                  context);
                            } else {
                              registerNewUser(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 320,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white60, width: 1)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      "Зареєстровані? Увійдіть",
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
  void registerNewUser(BuildContext context) async {
    final User user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Помилка: " + errMsg.toString(), context);
    }))
        .user;

    if (user != null) {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "password": passwordTextEditingController.text.trim(),
        "places": {
          "home": {
            "longitude": 0.001,
            "latitude": 0.001,
          },
          "education": {
            "longitude": 0.001,
            "latitude": 0.001,
          },
          "work": {
            "longitude": 0.001,
            "latitude": 0.001,
          }
        }
        //save user
      };
      usersRef.child(user.uid).set(userDataMap);
      displayToastMessage("Вас зареєстровано!", context);
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.idScreen, (route) => false);
    } else {
      displayToastMessage("Користувача не зареєстровано!", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
