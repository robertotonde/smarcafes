import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/models/cart_model.dart';
import 'package:smartcafes/models/delivery_address.dart';
import 'package:smartcafes/models/order_model.dart';
import 'package:smartcafes/provider/cart.dart';
import 'package:smartcafes/provider/delivery_address.dart';
import 'package:smartcafes/provider/orders.dart';
import 'package:smartcafes/screens/checkout/checkout_screen.dart';
import 'package:smartcafes/screens/homepage.dart';
import 'package:smartcafes/services/paymentapi.dart';
import 'package:smartcafes/services/send_email.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/input_field_widget.dart';
import 'package:smartcafes/widgets/list_orders_widget.dart';
import 'package:smartcafes/widgets/notification_budge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shoket/models/charge_response_model.dart';
import 'package:shoket/models/payment_model.dart';
import 'package:shoket/models/verify_response_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shoket/shoket.dart';

class MpesaCheckoutScreen extends StatefulWidget {
  const MpesaCheckoutScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MpesaCheckoutScreenState createState() => _MpesaCheckoutScreenState();
}

class _MpesaCheckoutScreenState extends State<MpesaCheckoutScreen> {
  bool isLoading = false;
  late Orders orderProvider;
  final _phoneController = TextEditingController();
  bool hasPaid = false;
  String provider = "Vodacom";
  String referenceid = "";
  final shoket = Shoket(apiKey: "sk_pgeTQfyYKNNgCh");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);
    final uID = Provider.of<AuthenticationService>(context).getCurrentUID();
    final deliveryAddress = Provider.of<DeliveryAddress>(context);
    final addOrder = Provider.of<Orders>(context, listen: false);

    DateTime nowDate =
        DateFormat("yyyy-MM-dd hh:mm").parse(DateTime.now().toString());

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: backColor,
        appBar: AppBar(
          backgroundColor: white.withOpacity(0.2),
          title: const Text(
            "Vodacom  Checkout",
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
                SizedBox(height: size.height * 0.05),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                      "Enter Vodacom number that you want to make payment with and check the total amount that you have to pay. Click PAY & ORDER and a Mpesa  dialog will appear on your device (number entered) enter your TigoPesa  pin to verify your payment. Thereafter, your order will be processed ASAP 😋",
                      style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          wordSpacing: 1,
                          color: grey6)),
                ),
                SizedBox(height: size.height * 0.15),
                InputFieldWidget(
                  obscureText: false,
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  hintText: "Phone Number",
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: deliveryAddress.fetchDeliveryAddress(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final deliveryAddress = snapshot.data!.docs
                            .map((deliveryAddress) =>
                                DeliveryAddressModel.fromMap(deliveryAddress
                                    .data() as Map<String, dynamic>))
                            .toList();

                        if (snapshot.data!.size == 0) {
                          return const Center(
                              child: Text("no delivery address"));
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final docSnapshot = deliveryAddress[index];
                              final deliveryAddressID =
                                  snapshot.data!.docs[index].id;

                              return const Center();
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                SizedBox(height: size.height * 0.03),
                SizedBox(
                  height: size.height / 13,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: cart.fetchCart(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final cart = snapshot.data!.docs
                              .map((cart) => CartModel.fromMap(
                                  cart.data() as Map<String, dynamic>))
                              .toList();

                          if (snapshot.data!.size == 0) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              // Add Your Code here.
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListOrdersWidget()));
                            });
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

                                      return Center(
                                          child: Container(
                                        color: Colors.green,
                                      ));
                                    }),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream:
                                      Provider.of<Cart>(context).fetchCart(),
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
                                          total += result.get("productPrice");
                                        }
                                        if (cartSnapshot.data!.size == 0) {
                                          return const CircularProgressIndicator();
                                        }
                                        return StreamBuilder<QuerySnapshot>(
                                            stream:
                                                Provider.of<DeliveryAddress>(
                                                        context)
                                                    .fetchDeliveryAddress(),
                                            builder:
                                                (context, deliverySnapshots) {
                                              if (deliverySnapshots.hasData) {
                                                final delivery = deliverySnapshots
                                                    .data?.docs
                                                    .map((deliveryAddress) =>
                                                        DeliveryAddressModel
                                                            .fromMap(
                                                                deliveryAddress
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>))
                                                    .toList();
                                                if (delivery!.isEmpty) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: const Center(
                                                      child: Text(
                                                        "No Address Can't Proceed Add One To Proceed Your Order On Checkout :)",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                            .map((deliveryAddress) =>
                                                                DeliveryAddressModel.fromMap(
                                                                    deliveryAddress
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>))
                                                            .toList();

                                                        final deliverySnapshot =
                                                            delivery[index];
                                                        var formatter =
                                                            NumberFormat();
                                                        return Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5,
                                                                    left: 20,
                                                                    right: 10,
                                                                    top: 15),
                                                            height:
                                                                size.height /
                                                                    15,
                                                            width: size.width,
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Total",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color(
                                                                            0xff2ec2f0),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: size
                                                                              .width *
                                                                          0.05,
                                                                    ),
                                                                    FittedBox(
                                                                      child:
                                                                          Text(
                                                                        "${formatter.format(total)} Tsh",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                  ],
                                                                ),
                                                                const VerticalDivider(
                                                                  color: Colors
                                                                      .white,
                                                                  thickness:
                                                                      0.5,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      size.width *
                                                                          0.2,
                                                                ),
                                                                isLoading ==
                                                                        true
                                                                    ? const Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      )
                                                                    : FittedBox(
                                                                        child:
                                                                            TextButton(
                                                                          onPressed: isLoading == true
                                                                              ? null
                                                                              : () async {
                                                                                  String userNumber = _phoneController.text;
                                                                                  var count = 0;
                                                                                  if (userNumber == '') {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                      content: Text(
                                                                                        "Phone Number is required not filled",
                                                                                        style: GoogleFonts.urbanist(
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontStyle: FontStyle.normal,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ));
                                                                                  } else {
                                                                                    if (userNumber[0] == "0") {
                                                                                      String string = userNumber.replaceFirst("0", "255");
                                                                                      userNumber = string;
                                                                                    }
                                                                                    if (userNumber[0] == "+") {
                                                                                      String string = userNumber.substring(1);
                                                                                      userNumber = string;
                                                                                    }
                                                                                    if (mounted) {
                                                                                      setState(() {
                                                                                        isLoading = true;
                                                                                      });
                                                                                    }
                                                                                    ChargeResponse? chargeResponse = await shoket.charge(Payment(amount: total.toString(), customerName: deliverySnapshot.userName, email: deliverySnapshot.email, numberUsed: userNumber, channel: "Tigo"));

                                                                                    if (chargeResponse != null) {
                                                                                      var chargeStatus = chargeResponse.data!.status;
                                                                                      print(chargeResponse.toJson());

                                                                                      print(chargeResponse.message);
                                                                                      showSimpleNotification(
                                                                                        Text(chargeResponse.message.toString()),
                                                                                        subtitle: Text(chargeResponse.message.toString()),
                                                                                        background: Colors.cyan.shade700,
                                                                                        duration: const Duration(seconds: 4),
                                                                                      );
                                                                                      var id = chargeResponse.reference;

                                                                                      Timer.periodic(const Duration(seconds: 10), (timer) async {
                                                                                        if (count <= 3) {
                                                                                          var verifyResponse = await shoket.verify(id!);

                                                                                          if (verifyResponse != null) {
                                                                                            print(isLoading);

                                                                                            print(verifyResponse.toJson());
                                                                                            print(verifyResponse.message);
                                                                                            showSimpleNotification(
                                                                                              Text(verifyResponse.data!.status.toString()),
                                                                                              subtitle: Text(verifyResponse.message.toString()),
                                                                                              background: Colors.cyan.shade700,
                                                                                              duration: const Duration(seconds: 4),
                                                                                            );
                                                                                            var verifyStatus = verifyResponse.data!.status!.toLowerCase();
                                                                                            if (verifyStatus == "fail") {
                                                                                              timer.cancel();

                                                                                              if (mounted) {
                                                                                                setState(() {
                                                                                                  isLoading = false;
                                                                                                  showSimpleNotification(
                                                                                                    Text(verifyResponse.data!.status.toString()),
                                                                                                    subtitle: Text(verifyResponse.message.toString()),
                                                                                                    background: Colors.cyan.shade700,
                                                                                                    duration: const Duration(seconds: 4),
                                                                                                  );
                                                                                                });
                                                                                              }
                                                                                            }
                                                                                            if (verifyStatus == "success") {
                                                                                              @override
                                                                                              void dispose() {
                                                                                                super.dispose();
                                                                                                timer.cancel();
                                                                                              }

                                                                                              dispose();

                                                                                              showSimpleNotification(
                                                                                                Text(verifyResponse.data!.status.toString()),
                                                                                                subtitle: Text(verifyResponse.message.toString()),
                                                                                                background: Colors.cyan.shade700,
                                                                                                duration: const Duration(seconds: 4),
                                                                                              );
                                                                                              DateTime nowDate = DateFormat("yyyy-MM-dd hh:mm").parse(DateTime.now().toString());
                                                                                              final addOrder = Orders();
                                                                                              for (var orders in cart) {
                                                                                                await addOrder.addOrders(OrderModel(orderStatusDescription: "Your order has been receieved successfully and our team is working on preparing it 👫", orderStatus: "Order Received", dateTime: nowDate, productDescription: orders.productDescription, productImage: orders.productImage, estimatedDelivery: orders.estimatedDelivery, productPrice: orders.productPrice, quantity: orders.quantity, email: deliverySnapshot.email, phoneNumber: deliverySnapshot.phoneNumber, college: deliverySnapshot.college, location: deliverySnapshot.location, userName: deliverySnapshot.userName, productName: orders.productName, hasPaid: true, reference: referenceid));
                                                                                              }

                                                                                              sendMessage() async {
                                                                                                var url = "https://secure-gw.fasthub.co.tz/fasthub/messaging/json/api";

                                                                                                var headers = {
                                                                                                  'content-type': 'application/json',
                                                                                                  "accept": "application/json",
                                                                                                };
                                                                                                var request = http.Request('POST', Uri.parse(url));

                                                                                                request.body = json.encode({
                                                                                                  'channel': {
                                                                                                    'channel': '119694',
                                                                                                    'password': "YmEzMWZlYzdkZTNkM2I4MTgwMjFlZmE4NTljNzdlMmU0MDc4YTc2YmFjNDU1MjBlOTA0OTk0ZjFjY2Y0MjA3Ng=="
                                                                                                  },
                                                                                                  'messages': [
                                                                                                    {
                                                                                                      'text': "New Order SMARTCAFES submitted by ${deliverySnapshot.userName}  here is the UID \n $uID",
                                                                                                      'msisdn': "255621251541",
                                                                                                      'source': 'Swahilies'
                                                                                                    }
                                                                                                  ]
                                                                                                });

                                                                                                request.headers.addAll(headers);

                                                                                                http.StreamedResponse response = await request.send();
                                                                                                if (response.statusCode == 200) {
                                                                                                  String responseString = await response.stream.bytesToString();

                                                                                                  return json.decode(responseString);
                                                                                                } else {
                                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                    content: Text(
                                                                                                      response.reasonPhrase.toString(),
                                                                                                      style: GoogleFonts.roboto(
                                                                                                        fontSize: 16,
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontStyle: FontStyle.normal,
                                                                                                        color: Colors.white,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ));
                                                                                                }
                                                                                              }

                                                                                              sendMessage();
                                                                                              await sendEmail(userName: deliverySnapshot.userName, userEmail: deliverySnapshot.email, college: deliverySnapshot.college, location: deliverySnapshot.location, userPhone: deliverySnapshot.phoneNumber, uID: uID, provider: provider);

                                                                                              final instance = FirebaseFirestore.instance;
                                                                                              final batch = instance.batch();

                                                                                              final FirebaseFirestore _db = FirebaseFirestore.instance;
                                                                                              var collection = _db.collection("Cart").doc(uID).collection("userCart");
                                                                                              var snapshots = await collection.get();
                                                                                              for (var doc in snapshots.docs) {
                                                                                                batch.delete(doc.reference);
                                                                                              }
                                                                                              await batch.commit();
                                                                                            } else {
                                                                                              count++;
                                                                                              print(count);

                                                                                              if (count > 3) {
                                                                                                if (mounted) {
                                                                                                  timer.cancel();

                                                                                                  setState(() {
                                                                                                    isLoading = false;
                                                                                                    showSimpleNotification(
                                                                                                      Text(verifyResponse.data!.status.toString()),
                                                                                                      subtitle: Text(" Sorry payment timeout. Try again or contact support"),
                                                                                                      background: Colors.cyan.shade700,
                                                                                                      duration: const Duration(seconds: 4),
                                                                                                    );
                                                                                                  });
                                                                                                }
                                                                                              }
                                                                                            }
                                                                                          } else {
                                                                                            if (mounted) {
                                                                                              timer.cancel();

                                                                                              setState(() {
                                                                                                isLoading = false;
                                                                                                showSimpleNotification(
                                                                                                  Text(verifyResponse!.data!.status.toString()),
                                                                                                  subtitle: Text(verifyResponse.message.toString()),
                                                                                                  background: Colors.cyan.shade700,
                                                                                                  duration: const Duration(seconds: 4),
                                                                                                );
                                                                                              });
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      });
                                                                                    } else {
                                                                                      if (mounted) {
                                                                                        setState(() {
                                                                                          isLoading = false;
                                                                                        });
                                                                                      }
                                                                                      showSimpleNotification(
                                                                                        Text(chargeResponse!.data!.status.toString()),
                                                                                        subtitle: Text(chargeResponse.message.toString()),
                                                                                        background: Colors.cyan.shade700,
                                                                                        duration: const Duration(seconds: 4),
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                },
                                                                          child: isLoading == true
                                                                              ? const Center(child: CircularProgressIndicator())
                                                                              : const FittedBox(
                                                                                  child: Text(
                                                                                    "PAY & ORDER",
                                                                                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
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
        ));
  }

  Future<void> paymentVerification(
      num total,
      DeliveryAddressModel deliverySnapshot,
      List<CartModel> cart,
      String uID,
      bool isLoading,
      String phone,
      GlobalKey<ScaffoldState> _scaffoldKey,
      BuildContext context) async {}
}
