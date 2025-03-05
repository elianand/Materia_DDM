import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class FirebaseUserDataSource {

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseUserDataSource(this._auth, this._firestore);

  Future<bool> loginWithCredentials(String email, String password) async {

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final fbUser = _auth.currentUser;

      if (fbUser == null) return false;

      return true;
    }catch(e) {
      debugPrint("WrongPass");
      return false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<String?> getUserId() async {
    final fbUser = _auth.currentUser;

    if (fbUser == null) {return null;}

    return fbUser.uid;

  }

  Future<UserModel?> getUserData() async {

    try {
      final fbUser = _auth.currentUser;

      if (fbUser == null) return null;

      final snapshot = await _firestore
          .collection('users')
          .where('idUser', isEqualTo: fbUser.uid)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return UserModel.fromFirestore(snapshot.docs.first, null);
    }catch(e) {
      debugPrint("Error in firestore userDataSource");
      return null;
    }
  }

  
  Future<void> createAccountWithCredentials(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }

  Future<void> updateUserDataWithId(String userId, UserModel user) async {
    
    try{

      final fbUser = _auth.currentUser;
      if (fbUser == null) return;

      final querySnapshot = await _firestore
        .collection("users")
        .where("idUser", isEqualTo: userId)
        .get();

      if (querySnapshot.docs.isEmpty) {return;}
        
      final userDoc = querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>;


      // Actualiza los datos del usuario
      await userDoc.reference.update(user.toFirestore());
      
    }catch(e) {
      debugPrint("Error in firestore userDataSource");
      return;
    }
  }


  Future<void> userlogout() async {
    try{
      await _auth.signOut();
    }catch(e) {
      debugPrint("Error in firestore userDataSource");
      return;
    }
  }

}