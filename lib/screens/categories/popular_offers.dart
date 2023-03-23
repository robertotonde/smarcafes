import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcafes/models/product_model.dart';
import 'package:smartcafes/provider/product_categories.dart';
import 'package:smartcafes/screens/product_description.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PopularOffers extends StatefulWidget {
  const PopularOffers({Key? key}) : super(key: key);

  @override
  _PopularOffersState createState() => _PopularOffersState();
}

class _PopularOffersState extends State<PopularOffers> {
  var formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryListProvider =
        Provider.of<CategoryListFirestoreModel>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: white.withOpacity(0.2),
          title: const Text(
            "Popular Offers",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: backColor,
        body: StreamBuilder<QuerySnapshot>(
            stream: categoryListProvider.fetchOfferCategory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final popularProduct = snapshot.data!.docs
                    .map((product) => ProductModel.fromMap(
                        product.data() as Map<String, dynamic>))
                    .toList();
                if (snapshot.data!.size == 0) {
                  return const Center(child: Text("Sorry No Product"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.size,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final docSnapshot = popularProduct[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDescription(
                                  productImage: docSnapshot.productImage,
                                  productName: docSnapshot.productName,
                                  productPrice: docSnapshot.productPrice,
                                  productDescription:
                                      docSnapshot.productDescription,
                                  estimatedDelivery:
                                      docSnapshot.estimatedDelivery,
                                )));
                      },
                      child: tourMethod(
                        size,
                        docSnapshot.productImage,
                        docSnapshot.productName,
                        docSnapshot.productPrice,
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Container tourMethod(Size size, String image, String name, int price) {
    return Container(
      width: size.width / 2,
      height: size.height * 0.27,
      decoration: BoxDecoration(
        color: const Color(0xff1d273d),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 15),
      child: Stack(
        children: [
          SizedBox(
            height: size.height / 6,
            width: size.width,
            child: CachedNetworkImage(
              imageUrl: image,
              fadeInCurve: Curves.easeIn,
              fadeInDuration: const Duration(milliseconds: 250),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: size.height * 0.17,
            left: size.width * 0.01,
            child: Text(
              name,
              style: GoogleFonts.ubuntu(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: white,
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.22,
            left: size.width * 0.01,
            child: Text(
              "${formatter.format(price)} Tsh",
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xff2ec2f0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
