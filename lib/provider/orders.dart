import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/models/order_model.dart';
import 'package:smartcafes/services/firebaseapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Orders with ChangeNotifier {
  // ADD ORDERS
  Future addOrders(OrderModel orderModel) async {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.addOrders(uID, orderModel.toJson());
  }

  // STREAM ORDERS
  Stream<QuerySnapshot> fetchOrders() {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.streamOrders(uID);
  }

  // DELETE CART
  Future deleteOrder(String orderID) async {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.deleteOrder(uID, orderID);
  }

  // EDIT Trades
  Future updateOrder(String orderID, OrderModel orderModel) async {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.updateOrder(uID, orderID, orderModel.toJson());
  }
}
