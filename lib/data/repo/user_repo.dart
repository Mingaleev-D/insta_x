import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_x/data/models/user_entity.dart';

abstract class UserRepo {
  Stream<User?> get currentUser;

  Future<void> signIn({required String email, required String password});

  Future<void> logOut();

  Future<UserEntity> signUp(
      {required UserEntity user, required String password});

  Future<void> resetPassword({required String email});

  Future<void> setUserData({required UserEntity user});

  Future<UserEntity> getUserEntity({required String uid});
}

class FirebaseUserRepo implements UserRepo {
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');

  @override
  Stream<User?> get currentUser {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  FirebaseUserRepo({required FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserEntity> signUp(
      {required UserEntity user, required String password}) async {
    try {
      UserCredential _userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      user = user.copyWith(
        uid: _userCredential.user!.uid,
      );
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUserEntity({required String uid}) async {
    try {
      // await userCollection
      //     .doc(uid)
      //     .snapshots()
      //     .map((event) => UserEntity.fromMap(event.data()!));
      return userCollection
          .doc(uid)
          .get()
          .then((value) => UserEntity.fromMap(value.data()!));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData({required UserEntity user}) async {
    try {
      await userCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
