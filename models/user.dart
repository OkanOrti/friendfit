import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? gender;
  final String? phone;
  final String? birthDate;
  final String? email;
  final String? photoUrl;
  final String? displayName;
  final String? bio;
  final bool? isAdmin;
  final bool? isDietician;
  final bool? isProMember;
  final DateTime? proStartDate;
  final DateTime? proEndDate;

  User(
      {this.id,
      this.username,
      this.firstname,
      this.lastname,
      this.gender,
      this.phone,
      this.birthDate,
      this.email,
      this.photoUrl,
      this.displayName,
      this.bio,
      this.isAdmin,
      this.isDietician,
      this.isProMember,
      this.proStartDate,
      this.proEndDate});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: (doc.data() as Map).containsKey('id') ? doc['id'] : null,
      email: (doc.data() as Map).containsKey('email') ? doc['email'] : null,
      username:
          (doc.data() as Map).containsKey('username') ? doc['username'] : null,
      firstname: (doc.data() as Map).containsKey('firstname')
          ? doc['firstname']
          : null,
      lastname:
          (doc.data() as Map).containsKey('lastname') ? doc['lastname'] : null,
      gender: (doc.data() as Map).containsKey('gender') ? doc['gender'] : null,
      phone: (doc.data() as Map).containsKey('phone') ? doc['phone'] : null,
      birthDate: (doc.data() as Map).containsKey('birthDate')
          ? doc['birthDate']
          : null,
      photoUrl:
          (doc.data() as Map).containsKey('photoUrl') ? doc['photoUrl'] : null,
      displayName: (doc.data() as Map).containsKey('displayName')
          ? doc['displayName']
          : null,
      bio: (doc.data() as Map).containsKey('bio') ? doc['bio'] : null,
      isAdmin:
          (doc.data() as Map).containsKey('isAdmin') ? doc['isAdmin'] : null,
      /*  isDietician: doc['isDietician'] ?? false,
      isProMember: doc['isProMember'] ?? false,
      proStartDate: doc['proStartDate'] ?? DateTime(1900),
      proEndDate: doc['proEndDate'] ?? DateTime(1900),*/
    );
  }
}
