import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterproject/Users/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? name;
  String? lname;
  String? number;
  String? email;
  String? uid;
  String? adresse;
  String? img;

  @override
  void onInit() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      name = loggedInUser.firstname!;
      lname = loggedInUser.lastname!;
      number = loggedInUser.number!;
      email = loggedInUser.email!;
      uid = loggedInUser.uid;
      adresse = loggedInUser.adresse;
      img = loggedInUser.img;
      update();
    });
    super.onInit();
    ever(name as RxString, (value) {
      onInit();
    });
  }
}
