import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcafes/models/order_model.dart';
import 'package:smartcafes/provider/orders.dart';
import 'package:smartcafes/screens/authentication/login_page.dart';
import 'package:smartcafes/screens/homepage.dart';
import 'package:smartcafes/screens/orderTracking/package_delivery_tracking.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListOrdersWidget extends StatelessWidget {
  ListOrdersWidget({
    Key? key,
  }) : super(key: key);
  var formatter = NumberFormat();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: white.withOpacity(0.2),
        title: const Text(
          "Orders",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
          return Future.value(false);
        },
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User? user = snapshot.data;
                if (user == null) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )),
                      child: Text(
                        "Login To View Orders",
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return SafeArea(
                    child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(), // new

                  children: [
                    SizedBox(
                      height: size.height / 1.4,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Provider.of<Orders>(context).fetchOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final orders = snapshot.data!.docs
                                  .map((orders) => OrderModel.fromMap(
                                      orders.data() as Map<String, dynamic>))
                                  .toList();

                              if (snapshot.data!.size == 0) {
                                return Center(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15, top: 15),
                                      height: size.height / 9,
                                      width: size.width / 2,
                                      decoration: BoxDecoration(
                                          color: white.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(children: [
                                        SizedBox(height: size.height * 0.01),
                                        Text(
                                          "NO ORDERS",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.add_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyHomePage()),
                                            );
                                          },
                                          label: Text(
                                            "Add One",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    // ignore: deprecated_member_use
                                                    Theme.of(context)
                                                        .accentColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])),
                                );
                              }

                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    final docSnapshot = orders[index];
                                    DateTime myDateTime = docSnapshot.dateTime;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PackageDeliveryTrackingPage(
                                                    orderStatus:
                                                        docSnapshot.orderStatus,
                                                    quantity: docSnapshot
                                                        .quantity
                                                        .toString(),
                                                    productPrice: docSnapshot
                                                        .productPrice
                                                        .toString(),
                                                    productName:
                                                        docSnapshot.productName,
                                                    productImage: docSnapshot
                                                        .productImage,
                                                    orderStatusDescription:
                                                        docSnapshot
                                                            .orderStatusDescription,
                                                    college:
                                                        docSnapshot.college,
                                                    location:
                                                        docSnapshot.location,
                                                    phoneNumber:
                                                        docSnapshot.phoneNumber,
                                                    userName:
                                                        docSnapshot.userName,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            // left: size.width * 0.02,
                                            top: size.height * 0.02),
                                        height: size.height / 5,
                                        decoration: BoxDecoration(
                                            color: white.withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Center(
                                                  child: Text(
                                                      docSnapshot.hasPaid ==
                                                              true
                                                          ? "PAID"
                                                          : "NOT PAID",
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: docSnapshot
                                                                      .hasPaid ==
                                                                  true
                                                              ? Colors.green
                                                              : Colors.red)),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: '',
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: white),
                                                      children: [
                                                        TextSpan(
                                                          text: myDateTime.day
                                                              .toString(),
                                                        ),
                                                        const TextSpan(
                                                          text: "-",
                                                        ),
                                                        TextSpan(
                                                          text: myDateTime.month
                                                              .toString(),
                                                        ),
                                                        const TextSpan(
                                                          text: "-",
                                                        ),
                                                        TextSpan(
                                                          text: myDateTime.year
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Card(
                                              color: Colors.transparent,
                                              elevation: 0.0,
                                              child: SizedBox(
                                                child: ListTile(
                                                  leading: CachedNetworkImage(
                                                    height: size.height * 0.36,
                                                    width: size.width * 0.15,
                                                    imageUrl: docSnapshot
                                                        .productImage,
                                                  ),
                                                  title: Text(
                                                      docSnapshot.productName,
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: grey6)),
                                                  subtitle: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "${formatter.format(docSnapshot.productPrice)} Tsh",
                                                          style: GoogleFonts.ubuntu(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .greenAccent)),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.01),
                                                      Text(
                                                          docSnapshot
                                                              .orderStatus,
                                                          style: GoogleFonts
                                                              .ubuntu(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .lime)),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.01),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PackageDeliveryTrackingPage(
                                                                          orderStatus:
                                                                              docSnapshot.orderStatus,
                                                                          quantity: docSnapshot
                                                                              .quantity
                                                                              .toString(),
                                                                          productPrice: docSnapshot
                                                                              .productPrice
                                                                              .toString(),
                                                                          productName:
                                                                              docSnapshot.productName,
                                                                          productImage:
                                                                              docSnapshot.productImage,
                                                                          orderStatusDescription:
                                                                              docSnapshot.orderStatusDescription,
                                                                          college:
                                                                              docSnapshot.college,
                                                                          location:
                                                                              docSnapshot.location,
                                                                          phoneNumber:
                                                                              docSnapshot.phoneNumber,
                                                                          userName:
                                                                              docSnapshot.userName,
                                                                        )),
                                                          );
                                                        },
                                                        child: FittedBox(
                                                          child: Text(
                                                            'Track',
                                                            style: GoogleFonts.ubuntu(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color(
                                                                    0xff2ec2f0)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.01),
                                                    ],
                                                  ),
                                                  trailing: Text(
                                                    "X${docSnapshot.quantity.toString()}",
                                                    style: const TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ],
                ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
