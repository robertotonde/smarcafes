import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcafes/services/firebaseapi.dart';
import 'package:flutter/material.dart';

class CategoryListFirestoreModel extends ChangeNotifier {
  final _firebaseApi = FirebaseApi();

  // FETCH POPULAR DRINKS CATEGORY
  Stream<QuerySnapshot> fetchPopularDrinksCategory() {
    return _firebaseApi.streamPopularDrinkCategory();
  }

  // FETCH POPULAR FOOD CATEGORY
  Stream<QuerySnapshot> fetchPopularFoodCategory() {
    return _firebaseApi.streamPopularFoodCategory();
  }

// FETCH POPULAR APPLIANCES CATEGORY
  Stream<QuerySnapshot> fetchPopularAppliancesCategory() {
    return _firebaseApi.streamPopularAppliancesCategory();
  }

  // FETCH POPULAR OFFERS CATEGORY
  Stream<QuerySnapshot> fetchPopularOffersCategory() {
    return _firebaseApi.streamPopularOffersCategory();
  }

  // FETCH  DRINKS CATEGORY
  Stream<QuerySnapshot> fetchDrinksCategory() {
    return _firebaseApi.streamDrinkCategory();
  }

  // FETCH  FOOD CATEGORY
  Stream<QuerySnapshot> fetchFoodCategory() {
    return _firebaseApi.streamFoodCategory();
  }

// FETCH  APPLIANCES CATEGORY
  Stream<QuerySnapshot> fetchAppliancesCategory() {
    return _firebaseApi.streamAppliancesCategory();
  }

  // FETCH  STATIONERY CATEGORY
  Stream<QuerySnapshot> fetchStationeryCategory() {
    return _firebaseApi.streamStationeryCategory();
  }

  // FETCH  OFFER CATEGORY
  Stream<QuerySnapshot> fetchOfferCategory() {
    return _firebaseApi.streamOfferCategory();
  }

  // FETCH SEARCHED FOOD
  Stream<QuerySnapshot> fetchSearchedFoodCategory(String keyword) {
    return _firebaseApi.streamSearchFoodCategory(keyword);
  }

  // FETCH SEARCHED DRINKS
  Stream<QuerySnapshot> fetchSearchedDrinksCategory(String keyword) {
    return _firebaseApi.streamSearchDrinksCategory(keyword);
  }

  // FETCH SEARCHED APPLIACES
  Stream<QuerySnapshot> fetchSearchedApplianccesCategory(String keyword) {
    return _firebaseApi.streamSearchAppliancesCategory(keyword);
  }

  // FETCH SEARCHED STATIONERY
  Stream<QuerySnapshot> fetchSearchedStaioneryCategory(String keyword) {
    return _firebaseApi.streamSearchStationeryCategory(keyword);
  }

  // FETCH SEARCHED OFFER
  Stream<QuerySnapshot> fetchSearchedOfferCategory(String keyword) {
    return _firebaseApi.streamSearchOfferCategory(keyword);
  }
}
