import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/models/delivery_address.dart';
import 'package:smartcafes/services/firebaseapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveryAddress with ChangeNotifier {
  // ADD DELIVERY ADDRESS
  Future addDeliveryAddress(DeliveryAddressModel deliveryAddressModel) async {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.addDeliveryAddress(uID, deliveryAddressModel.toJson());
  }

  // STREAM DELIVERY ADDRESS
  Stream<QuerySnapshot> fetchDeliveryAddress() {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.streamDeliveryAddress(uID);
  }

  // EDIT DELIVERYaDDRESS
  Future editsmartcafesAddress(
      String deliveryId, DeliveryAddressModel deliveryModel) async {
    final _firebaseApi = FirebaseApi();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final uID = AuthenticationService(_auth).getCurrentUID();
    return _firebaseApi.editsmartcafesAddress(
        uID, deliveryId, deliveryModel.toJson());
  }

  // GET DELIVERY LOCATION
  Stream<QuerySnapshot> fetchDeliveryLocation() {
    final _firebaseApi = FirebaseApi();
    return _firebaseApi.fetchDeliveryLocation();
  }
}
