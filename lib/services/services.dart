// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:proj_cat/screens/login_screen.dart';
import 'package:proj_cat/services/helperfunctions.dart';

Future<User> googleSign() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

  var _authentication = await _googleSignInAccount!.authentication;
  var _credential = GoogleAuthProvider.credential(
    idToken: _authentication.idToken,
    accessToken: _authentication.accessToken,
  );

  User? user = (await _auth.signInWithCredential(_credential)).user;
  HelperFunctions.saveUserLoggedInSharedPreference(true);
  user!.updatePhotoURL(user.photoURL);
  return user;
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      Data.image = "";
      Data.userName = "Anon";
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  } catch (e) {
    var ef = e;
  }
}

Future<bool> createAccountEmail(
    String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var photo = "";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      // ignore: deprecated_member_use
      user.updateProfile(displayName: name);
      user.updatePhotoURL(photo);
      user.updateDisplayName(name);

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": name,
        "email": email,
        "status": "Unavalible",
        "uid": _auth.currentUser!.uid,
      });
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> logInEmail(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          // ignore: deprecated_member_use
          .then((value) => user.updateProfile(displayName: value['name']));
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> isEmailRegistered(String email) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();
  final List<DocumentSnapshot> documents = result.docs;
  if (documents.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}


Future<bool> setBookmarks(String sourceName, String imageUrl, String title,
    String description, String url, String author, String publishDate) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('bookmarks')
        .doc(title)
        .set({
      "sourceName": sourceName,
      "imageUrl": imageUrl,
      "title": title,
      "description": description,
      "url": url,
      "author": author,
      "publishDate": publishDate,
    });
    return true;
  } catch (e) {
    return false;
  }
}

delete(String title) {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('bookmarks')
      .doc(title)
      .delete();
}

class Data {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static List<String> bookmark = [];
  static String userName = "Anon";
  static String api = "";
  static getUsername() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userName = user.displayName.toString();
    }
  }

  static String image = "";
  static getImage() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      image = user.photoURL.toString();
    }
  }

  getApiId() {
    _firestore.collection('api').doc('api-id').get().then((value) {
      api = value['api'];
      print(api);
    });
  }

  getBookmark(String description) {
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('bookmarks')
        .doc(description)
        .get()
        .then((value) {
      bookmark.add(value['description']);
      print("This is a");
      print(bookmark);
    });
  }

  static String getDate(String date) {
    return DateFormat.yMMMd().format(DateTime.parse(date)).toString();
  }
}