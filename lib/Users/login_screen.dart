// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Products/store_page.dart';
import 'package:flutterproject/Users/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var ispwdhidden = true.obs;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();

  Widget build(BuildContext context) {
    double width_var = MediaQuery.of(context).size.width;
    double height_var = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('background.jpg'), fit: BoxFit.cover)),
            child: Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: height_var * 0.1,
                      ),
                      Text(
                        "E-Commerce Shop",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'LittlePat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height_var * 0.2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            "Connectez-vous",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height_var * 0.01,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Veuillez saisir votre email!");
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Veuillez saisir un email valide!");
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1)),
                          hintText: "Adresse e-mail*",
                        ),
                      ),
                      SizedBox(
                        height: height_var * 0.02,
                      ),
                      Obx(
                        () => TextFormField(
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Veuillez saisir votre mot de passe");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Veuillez saisir un mot de passe valide(6.Chara Minimum)");
                            }
                          },
                          controller: PasswordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.key),
                            suffix: InkWell(
                              child: Icon(ispwdhidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onTap: () {
                                ispwdhidden.value = !ispwdhidden.value;
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 1)),
                            hintText: "Mot de passe*",
                          ),
                          obscureText: ispwdhidden.value,
                        ),
                      ),
                      SizedBox(
                        height: height_var * 0.05,
                      ),
                      ElevatedButton(
                        child: Text("SE CONNECTER"),
                        onPressed: () {
                          Login(emailController.text, PasswordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                            padding: EdgeInsets.symmetric(
                                horizontal: width_var * 0.25,
                                vertical: height_var * 0.01),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: height_var * 0.16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          Text(
                            "Pas encore inscrit?",
                            style: TextStyle(),
                            textAlign: TextAlign.end,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(RegistreScreen());
                            },
                            child: Text(
                              "Inscrivez-vous ?",
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Login(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Connexion réussie!"),
                Get.to(ProductListView()),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
