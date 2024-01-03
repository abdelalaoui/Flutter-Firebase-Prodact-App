// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Users/login_screen.dart';
import 'package:flutterproject/Users/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RegistreScreen extends StatelessWidget {
  RegistreScreen({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  var ispwdhidden = true.obs;
  final firstnameEC = TextEditingController();
  final lastnameEC = TextEditingController();
  final numberEC = TextEditingController();
  final mailEC = TextEditingController();
  final password1EC = TextEditingController();
  final password2EC = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;

  @override
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
                        "E-Commerce Shop ",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'LittlePat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height_var * 0.1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            "Crée votre Compte",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width_var * 0.46,
                            child: TextFormField(
                              validator: (value) {
                                RegExp regex = new RegExp(r'[A-Za-z]');
                                if (value!.isEmpty) {
                                  return ("Veuillez saisir un Nom");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Veuillez saisir un Nom  valide");
                                }
                              },
                              controller: lastnameEC,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1)),
                                hintText: "Nom*",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width_var * 0.46,
                            child: TextFormField(
                              validator: (value) {
                                RegExp regex = new RegExp(r'[A-Za-z]');
                                if (value!.isEmpty) {
                                  return ("Veuillez saisir un Prenom");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Veuillez saisir un Prenom valide");
                                }
                              },
                              controller: firstnameEC,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1)),
                                hintText: "Prenom*",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height_var * 0.01,
                      ),
                      TextFormField(
                        validator: (value) {
                          RegExp regex = new RegExp(r'^[0-9]{10}$');
                          if (value!.isEmpty) {
                            return ("Veuillez saisir yn numéro");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Veuillez saisir un numéro valide(10.Chara)");
                          }
                        },
                        controller: numberEC,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1)),
                          hintText: "Numéro de Téléphone*",
                        ),
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
                        controller: mailEC,
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
                        height: height_var * 0.01,
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
                          controller: password1EC,
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
                        height: height_var * 0.01,
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
                            if (value != password1EC.text) {
                              return ("Mot de passe différent ");
                            }
                          },
                          controller: password2EC,
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
                            hintText: "Comfirmer votre Mot de passe*",
                          ),
                          obscureText: ispwdhidden.value,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                      SizedBox(
                        height: height_var * 0.07,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _signup(mailEC.text, password1EC.text);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                            padding: EdgeInsets.symmetric(
                                horizontal: width_var * 0.33,
                                vertical: height_var * 0.01),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        child: Text("S'inscrire!'"),
                      ),
                      SizedBox(
                        height: height_var * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          Text(
                            "Vous avez déja un compte ?",
                            style: TextStyle(),
                            textAlign: TextAlign.end,
                          ),
                          InkWell(
                            onTap: (() {
                              Get.to(LoginScreen());
                            }),
                            child: Text(
                              "Connectez-vous ?",
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

  Future<void> _signup(String email, String password) async {
    if (!_formkey.currentState!.validate()) return;
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User user = userCredential.user!;
      final UserModel userModel = UserModel(
        email: user.email,
        uid: user.uid,
        firstname: firstnameEC.text,
        lastname: lastnameEC.text,
        number: numberEC.text,
      );

      print("this is the user map ${userModel.toMap()} //// ");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());

      Fluttertoast.showToast(msg: "Account created successfully :) ");
      // Get.off(HomeScreen());
    } catch (e) {
      print("Error during signup: $e");
      // Gérer les erreurs d'authentification ou de firestore ici
      // Afficher un message d'erreur à l'utilisateur si nécessaire
    }
  }
}
