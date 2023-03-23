import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcafes/models/cart_model.dart';
import 'package:smartcafes/provider/cart.dart';
import 'package:smartcafes/screens/authentication/login_page.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/list_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ProductDescription extends StatefulWidget {
  String productName;
  String productImage;
  String productDescription;
  int productPrice;
  int estimatedDelivery;
  ProductDescription(
      {Key? key,
      required this.productName,
      required this.productImage,
      required this.productPrice,
      required this.estimatedDelivery,
      required this.productDescription})
      : super(key: key);

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  var formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    bool isLoading = false;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xff1d273d),
          centerTitle: true,
          title: Text(
            widget.productName,
            style: GoogleFonts.ubuntu(
                fontSize: 17, fontWeight: FontWeight.w500, color: white),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: size.height / 3.5,
              width: size.width,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.productImage,
                fadeInCurve: Curves.easeIn,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              height: size.height / 20,
              width: size.width,
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: RichText(
                text: TextSpan(
                  text: ' ',
                  children: [
                    TextSpan(
                        text: 'Price: ',
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: whiteopacity)),
                    TextSpan(
                        text: "${formatter.format(widget.productPrice)} Tsh",
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: grey6)),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Text("Description",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteopacity)),
              ),
            ),
            Container(
              height: size.height / 3.3,
              width: size.width,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    text: ' ',
                    children: [
                      TextSpan(
                          text: '',
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: whiteopacity)),
                      TextSpan(
                          text: widget.productDescription,
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: grey6)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Container(
              height: size.height / 35,
              width: size.width,
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: RichText(
                text: TextSpan(
                  text: ' ',
                  children: [
                    TextSpan(
                        text: 'Delivery: ',
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: whiteopacity)),
                    TextSpan(
                        text: widget.estimatedDelivery.toString(),
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: grey6)),
                  ],
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter myState) {
                        int price = widget.productPrice * quantity;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                child: Text(
                                  widget.productName,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w400,
                                    color: backColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Card(
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: widget.productImage,
                                ),
                                title: Text(
                                  "${formatter.format(price)} Tsh",
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w400,
                                    color: backColor,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline_sharp,
                                      ),
                                      iconSize: 40,
                                      color: Colors.red,
                                      splashColor: Colors.purple,
                                      onPressed: () {
                                        Future.delayed(Duration.zero, () async {
                                          myState(() {
                                            quantity = quantity - 1;
                                          });
                                        });
                                      },
                                    ),
                                    Text(
                                      quantity.toString(),
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w400,
                                        color: backColor,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline_sharp,
                                      ),
                                      iconSize: 40,
                                      color: Colors.green,
                                      splashColor: Colors.purple,
                                      onPressed: () {
                                        Future.delayed(Duration.zero, () async {
                                          myState(() {
                                            quantity++;
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            StreamBuilder<User?>(
                                stream:
                                    FirebaseAuth.instance.authStateChanges(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    User? user = snapshot.data;
                                    if (user == null) {
                                      return Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignIn()),
                                            );
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      backColor),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                              )),
                                          child: Text(
                                            "Login To Buy",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Center(
                                      child: ElevatedButton(
                                        onPressed: isLoading == true
                                            ? null
                                            : () async {
                                                myState(() {
                                                  isLoading = true;
                                                });
                                                final addCart =
                                                    Provider.of<Cart>(context,
                                                        listen: false);
                                                await addCart.addCart(CartModel(
                                                    productDescription: widget
                                                        .productDescription,
                                                    productImage:
                                                        widget.productImage,
                                                    estimatedDelivery: widget
                                                        .estimatedDelivery,
                                                    productPrice:
                                                        widget.productPrice *
                                                            quantity,
                                                    quantity: quantity,
                                                    productName:
                                                        widget.productName));
                                                // SchedulerBinding.instance!
                                                //     .addPostFrameCallback((_) {

                                                // });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MyListCartWidget()),
                                                );
                                                myState(() {
                                                  isLoading = false;
                                                });
                                              },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    backColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                            )),
                                        child: Text(
                                          isLoading == true
                                              ? "Adding..."
                                              : "Add To Cart",
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                          ],
                        );
                      });
                    });
              },
              child: Text(
                "BUY NOW",
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff122651),
                ),
              ),
            ),
          ],
        )));
  }
}
