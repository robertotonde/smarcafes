import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcafes/screens/authentication/login_page.dart';
import 'package:smartcafes/screens/checkout/checkout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcafes/models/cart_model.dart';
import 'package:smartcafes/models/delivery_address.dart';
import 'package:smartcafes/provider/cart.dart';
import 'package:smartcafes/provider/delivery_address.dart';
import 'package:smartcafes/provider/orders.dart';
import 'package:smartcafes/screens/homepage.dart';
import 'package:smartcafes/screens/orderTracking/add_delivery_address.dart';
import 'package:smartcafes/screens/orderTracking/edit_delivery_address.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class _CartDescription extends StatefulWidget {
  const _CartDescription({
    Key? key,
    required this.title,
    required this.price,
    required this.count,
  }) : super(key: key);

  final String title;
  final int price;
  final int count;

  @override
  State<_CartDescription> createState() => _CartDescriptionState();
}

class _CartDescriptionState extends State<_CartDescription> {
  var formatter = NumberFormat();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            "${formatter.format(widget.price)} Tsh",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.remove_circle_outline_sharp,
              //       size: 18, color: Colors.red),
              //   color: Colors.black,
              // ),

              const Text(
                "X",
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.count.toString(),
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // IconButton(
              //   onPressed: () {

              //   },
              //   icon: const Icon(Icons.add_circle_outline_sharp,
              //       size: 18, color: Colors.green),
              //   color: Colors.white,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.price,
    required this.count,
    required this.onPressed,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final int price;
  final int count;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _CartDescription(
              title: title,
              price: price,
              count: count,
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.delete_rounded,
              size: 18.0,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}

class MyListCartWidget extends StatefulWidget {
  const MyListCartWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MyListCartWidget> createState() => _MyListCartWidgetState();
}

class _MyListCartWidgetState extends State<MyListCartWidget> {
  bool isLoading = false;
  late Size orderSize;
  late Orders orderProvider;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);
    final deliveryAddress = Provider.of<DeliveryAddress>(context);

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: white.withOpacity(0.2),
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
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
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )),
                    child: Text(
                      "Login To View Cart",
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: deliveryAddress.fetchDeliveryAddress(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final deliveryAddress = snapshot.data!.docs
                                  .map((deliveryAddress) =>
                                      DeliveryAddressModel.fromMap(
                                          deliveryAddress.data()
                                              as Map<String, dynamic>))
                                  .toList();

                              if (snapshot.data!.size == 0) {
                                return Container(
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
                                        "NO DELIVERY ADDRESS",
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
                                                    const AddAddress()),
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
                                    ]));
                              }

                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    final docSnapshot = deliveryAddress[index];
                                    final deliveryAddressID =
                                        snapshot.data!.docs[index].id;

                                    return Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15, top: 15),
                                      height: size.height / 4,
                                      decoration: BoxDecoration(
                                          color: white.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(width: 0.1),
                                              Text(
                                                "Delivery Address",
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                        0xff2ec2f0)),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => EditAddress(
                                                            userName: docSnapshot
                                                                .userName,
                                                            phoneNumber:
                                                                docSnapshot
                                                                    .phoneNumber,
                                                            location:
                                                                docSnapshot
                                                                    .location,
                                                            email: docSnapshot
                                                                .email,
                                                            deliveryAddressId:
                                                                deliveryAddressID,
                                                            college: docSnapshot
                                                                .college)),
                                                  );
                                                },
                                                child: Text(
                                                  "Change",
                                                  // style: TextStyle(
                                                  //   color: Colors.teal.shade100,
                                                  //   fontWeight: FontWeight.bold,
                                                  //   fontSize: 17,
                                                  // ),
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal.shade100,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 0.1),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height: size.height * 0.01),
                                              Text(
                                                docSnapshot.userName,
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                docSnapshot.phoneNumber,
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                docSnapshot.email,
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                docSnapshot.college,
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                docSnapshot.location,
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        height: size.height / 2.1,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: cart.fetchCart(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final cart = snapshot.data!.docs
                                    .map((cart) => CartModel.fromMap(
                                        cart.data() as Map<String, dynamic>))
                                    .toList();

                                if (snapshot.data!.size == 0) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/emptycart",
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.add_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            await Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyHomePage()),
                                            );
                                          },
                                          label: Text(
                                            "Add Products",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
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
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(8.0),
                                          itemExtent: 106.0,
                                          itemCount: cart.length,
                                          itemBuilder: (context, index) {
                                            final docSnapshot = cart[index];
                                            final cartSnapshot =
                                                snapshot.data!.docs[index];

                                            return CustomListItem(
                                              onPressed: () {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Delete ${docSnapshot.productName}'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: isLoading == true
                                                            ? const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )
                                                            : Column(
                                                                children: <
                                                                    Widget>[
                                                                  const FittedBox(
                                                                    child: Text(
                                                                        'Are you sure you want to remove from your cart.'),
                                                                  ),
                                                                  FittedBox(
                                                                    child: Text(
                                                                      docSnapshot
                                                                          .productName,
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            isLoading == true
                                                                ? "Removing....."
                                                                : 'Confirm',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          onPressed:
                                                              isLoading == true
                                                                  ? null
                                                                  : () async {
                                                                      setState(
                                                                          () {
                                                                        isLoading =
                                                                            true;
                                                                      });
                                                                      final deleteCart = Provider.of<
                                                                              Cart>(
                                                                          context,
                                                                          listen:
                                                                              false);
                                                                      await deleteCart
                                                                          .deleteCart(
                                                                              cartSnapshot.id);
                                                                      final snackBar =
                                                                          SnackBar(
                                                                        content:
                                                                            Text('Product ${docSnapshot.productName} Removed Successfully!'),
                                                                      );
                                                                      Future.delayed(
                                                                          Duration
                                                                              .zero,
                                                                          () async {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackBar);
                                                                      });

                                                                      Navigator
                                                                          .pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const MyListCartWidget()),
                                                                      );
                                                                    },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              count: docSnapshot.quantity,
                                              price: docSnapshot.productPrice,
                                              thumbnail: CachedNetworkImage(
                                                  imageUrl:
                                                      docSnapshot.productImage),
                                              title: docSnapshot.productName,
                                            );
                                          }),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: Provider.of<Cart>(context)
                                            .fetchCart(),
                                        builder: (context, cartSnapshot) {
                                          if (cartSnapshot.hasData) {
                                            if (cartSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }
                                            if (cartSnapshot.data?.size == 0) {
                                              return const CircularProgressIndicator();
                                            } else {
                                              num total = 0;
                                              for (var result
                                                  in cartSnapshot.data!.docs) {
                                                total +=
                                                    result.get("productPrice");
                                              }
                                              if (cartSnapshot.data!.size ==
                                                  0) {
                                                return const CircularProgressIndicator();
                                              }
                                              return StreamBuilder<
                                                      QuerySnapshot>(
                                                  stream: Provider.of<
                                                              DeliveryAddress>(
                                                          context)
                                                      .fetchDeliveryAddress(),
                                                  builder: (context,
                                                      deliverySnapshots) {
                                                    if (deliverySnapshots
                                                        .hasData) {
                                                      final delivery = deliverySnapshots
                                                          .data?.docs
                                                          .map((deliveryAddress) =>
                                                              DeliveryAddressModel.fromMap(
                                                                  deliveryAddress
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>))
                                                          .toList();
                                                      if (delivery!.isEmpty) {
                                                        return Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      size.width *
                                                                          0.01),
                                                          child: const Center(
                                                            child: Text(
                                                              "No Address Can't Proceed Add One Above To Proceed Your Order On Checkout :)",
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: 1,
                                                          itemBuilder:
                                                              (context, index) {
                                                            if (deliverySnapshots
                                                                .hasData) {
                                                              final delivery = deliverySnapshots
                                                                  .data!.docs
                                                                  .map((deliveryAddress) => DeliveryAddressModel.fromMap(deliveryAddress
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>))
                                                                  .toList();
                                                              var formatter =
                                                                  NumberFormat();
                                                              var length =
                                                                  cartSnapshot
                                                                      .data!
                                                                      .size;
                                                              return Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: size
                                                                            .height *
                                                                        0.04,
                                                                    left: size
                                                                            .width *
                                                                        0.06,
                                                                    right: size
                                                                            .width *
                                                                        0.04,
                                                                    top: size
                                                                            .height *
                                                                        0.01,
                                                                  ),
                                                                  height:
                                                                      size.height /
                                                                          10,
                                                                  width: size
                                                                      .width,
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "Total ($length)",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0xff2ec2f0),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                size.width * 0.04,
                                                                          ),
                                                                          FittedBox(
                                                                            child:
                                                                                Text(
                                                                              "${formatter.format(total)} Tsh",
                                                                              style: const TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                size.width * 0.005,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const VerticalDivider(
                                                                        color: Colors
                                                                            .white,
                                                                        thickness:
                                                                            0.5,
                                                                      ),
                                                                      SizedBox(
                                                                        width: size.width *
                                                                            0.03,
                                                                      ),
                                                                      FittedBox(
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                                                                            );
                                                                            // final instance =
                                                                            //     FirebaseFirestore
                                                                            //         .instance;
                                                                            // final batch =
                                                                            //     instance
                                                                            //         .batch();
                                                                            // FirebaseAuth
                                                                            //     _auth =
                                                                            //     FirebaseAuth
                                                                            //         .instance;
                                                                            // final uID = AuthenticationService(
                                                                            //         _auth)
                                                                            //     .getCurrentUID();
                                                                            // final FirebaseFirestore
                                                                            //     _db =
                                                                            //     FirebaseFirestore
                                                                            //         .instance;
                                                                            // var collection = _db
                                                                            //     .collection(
                                                                            //         "Cart")
                                                                            //     .doc(uID)
                                                                            //     .collection(
                                                                            //         "userCart");
                                                                            // var snapshots =
                                                                            //     await collection
                                                                            //         .get();
                                                                            // for (var doc
                                                                            //     in snapshots
                                                                            //         .docs) {
                                                                            //   batch.delete(
                                                                            //       doc.reference);
                                                                            // }
                                                                            // await batch
                                                                            //     .commit();
                                                                          },
                                                                          child:
                                                                              const FittedBox(
                                                                            child:
                                                                                Text(
                                                                              "COMFIRM & PAY",
                                                                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(
                                                                                // ignore: deprecated_member_use
                                                                                Theme.of(context).accentColor),
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ));
                                                            } else {
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            }
                                                          });
                                                    } else {
                                                      return const CircularProgressIndicator();
                                                    }
                                                  });
                                            }
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                  ],
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
