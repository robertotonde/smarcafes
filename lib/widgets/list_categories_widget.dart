import 'package:smartcafes/screens/categories/popular_appliances.dart';
import 'package:smartcafes/screens/categories/popular_drinks.dart';
import 'package:smartcafes/screens/categories/popular_foods.dart';
import 'package:smartcafes/screens/categories/popular_offers.dart';
import 'package:smartcafes/screens/categories/popular_stationeries.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListCategoriesWidget extends StatelessWidget {
  const ListCategoriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: white.withOpacity(0.2),
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PopularOffers()));
              },
              child: Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: ListTile(
                    title: Text(
                      'Popular Offers',
                      style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: grey6),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent,
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PopularFood()));
              },
              child: Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: ListTile(
                    title: Text(
                      'Popular Food',
                      style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: grey6),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent,
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PopularDrinks()));
              },
              child: Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: ListTile(
                    title: Text(
                      'Popular Drinks',
                      style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: grey6),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent,
                    )),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
