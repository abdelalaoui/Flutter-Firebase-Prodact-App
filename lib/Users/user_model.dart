class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? lastname;
  String? number;
  String? adresse;
  String? img;

  UserModel({
    this.uid,
    this.email,
    this.firstname,
    this.lastname,
    this.number,
    this.adresse = '',
    this.img,
  });

//receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      number: map['number'],
      adresse: map['adresse'],
      img: map['img'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'number': number,
      'adresse': adresse,
      'img': img,
    };
  }


}
