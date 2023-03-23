import 'package:smartcafes/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/services/firebaseapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  // ADD CART
  Future addCart(CartModel cartModel) async {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.addCart(uID, cartModel.toJson());
  }

  // STREAM CART
  Stream<QuerySnapshot> fetchCart() {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.streamCart(uID);
  }

  // DELETE CART
  Future deleteCart(String cartID) async {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.deleteCart(uID, cartID);
  }
}
