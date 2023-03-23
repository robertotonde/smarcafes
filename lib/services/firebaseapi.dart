import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // STREAM POPULAR DRINKS CATEGORY METHOD
  Stream<QuerySnapshot> streamPopularDrinkCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Drinks")
        .where("popular", isEqualTo: true)
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM POPULAR FOOD CATEGORY METHOD
  Stream<QuerySnapshot> streamPopularFoodCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Food")
        .where("popular", isEqualTo: true)
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM POPULAR APPLIANCES CATEGORY METHOD
  Stream<QuerySnapshot> streamPopularAppliancesCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Appliances")
        .where("popular", isEqualTo: true)
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM POPULAR OFFERS CATEGORY METHOD
  Stream<QuerySnapshot> streamPopularOffersCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Promotions")
        .where("popular", isEqualTo: true)
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM  DRINKS CATEGORY METHOD
  Stream<QuerySnapshot> streamDrinkCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Drinks")
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM  FOOD CATEGORY METHOD
  Stream<QuerySnapshot> streamFoodCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Food")
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM  OFFER CATEGORY METHOD
  Stream<QuerySnapshot> streamOfferCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Promotions")
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM  APPLIANCES CATEGORY METHOD
  Stream<QuerySnapshot> streamAppliancesCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Appliances")
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM  STATIONERY CATEGORY METHOD
  Stream<QuerySnapshot> streamStationeryCategory() {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Stationery")
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM SEARCH FOOD CATEGORY METHOD
  Stream<QuerySnapshot> streamSearchFoodCategory(String keyword) {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Food")
        .where("searchKeyword", arrayContains: keyword)
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM SEARCH APPLIANCES CATEGORY METHOD
  Stream<QuerySnapshot> streamSearchAppliancesCategory(String keyword) {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Appliances")
        .where("searchKeyword", arrayContains: keyword)
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // STREAM SEARCH DRINKS CATEGORY METHOD
  Stream<QuerySnapshot> streamSearchDrinksCategory(String keyword) {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Drinks")
        .where("searchKeyword", arrayContains: keyword)
        .orderBy("productName", descending: false)
        .snapshots();
  }

// STREAM SEARCH STATIONERY CATEGORY METHOD
  Stream<QuerySnapshot> streamSearchStationeryCategory(String keyword) {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Stationery")
        .where("searchKeyword", arrayContains: keyword)
        .orderBy("productName", descending: false)
        .snapshots();
  }

// STREAM OFFER  CATEGORY METHOD
  Stream<QuerySnapshot> streamSearchOfferCategory(String keyword) {
    return _db
        .collection('Categories')
        .doc("4GmEQCYU7UARAyNRzq2K")
        .collection("Promotions")
        .where("searchKeyword", arrayContains: keyword)
        .orderBy("productName", descending: false)
        .snapshots();
  }

  // ADD TO CART
  Future<void> addCart(String uID, Map<String, Object?> cart) {
    return _db.collection("Cart").doc(uID).collection("userCart").add(cart);
  }

  // STREAM CART METHOD
  Stream<QuerySnapshot> streamCart(String uID) {
    return _db.collection("Cart").doc(uID).collection("userCart").snapshots();
  }

  // DELETE CART METHOD
  Future<void> deleteCart(String uID, String cartID) {
    return _db
        .collection("Cart")
        .doc(uID)
        .collection("userCart")
        .doc(cartID)
        .delete();
  }

  // ADD DELIVERY ADDRESS
  Future<void> addDeliveryAddress(
      String uID, Map<String, Object?> deliveryAddress) {
    return _db
        .collection("DeliveryAddress")
        .doc(uID)
        .collection("deliveryAddress")
        .add(deliveryAddress);
  }

  // STREAM DELIVERY ADDRESS METHOD
  Stream<QuerySnapshot> streamDeliveryAddress(String uID) {
    return _db
        .collection("DeliveryAddress")
        .doc(uID)
        .collection("deliveryAddress")
        .snapshots();
  }

  // EDIT DELIVERY ADDRESS METHOD
  Future<void> editsmartcafesAddress(
      String uID, String deliveryID, Map<String, Object?> deliveryaddress) {
    return _db
        .collection("DeliveryAddress")
        .doc(uID)
        .collection("deliveryAddress")
        .doc(deliveryID)
        .update(deliveryaddress);
  }

  // ADD ORDER
  Future<void> addOrders(String uID, Map<String, Object?> orders) {
    return _db
        .collection("Orders")
        .doc(uID)
        .collection("userOrders")
        .add(orders);
  }

  // STREAM ORDERS
  Stream<QuerySnapshot> streamOrders(String uID) {
    return _db
        .collection("Orders")
        .doc(uID)
        .collection("userOrders")
        .orderBy("dateTime", descending: true)
        .snapshots();
  }

  // DELETE ORDER METHOD
  Future<void> deleteOrder(String uID, String orderID) {
    return _db
        .collection("Orders")
        .doc(uID)
        .collection("userOrders")
        .doc(orderID)
        .delete();
  }

  // UDATE ORDER METHOD
  Future<void> updateOrder(
      String uID, String orderID, Map<String, Object?> order) {
    return _db
        .collection("Orders")
        .doc(uID)
        .collection("userOrders")
        .doc(orderID)
        .update(order);
  }

// FETCH DELIVERY LOCATION

  Stream<QuerySnapshot> fetchDeliveryLocation() {
    return _db
        .collection("DeliveryAddress")
        .doc("locations")
        .collection("locations")
        .snapshots();
  }
}
