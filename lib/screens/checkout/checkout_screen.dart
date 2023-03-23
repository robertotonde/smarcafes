import 'package:smartcafes/screens/checkout/airtelmoney_checkout.dart';
import 'package:smartcafes/screens/checkout/cash.dart';
import 'package:smartcafes/screens/checkout/halopesa_checkout.dart';
import 'package:smartcafes/screens/checkout/mpesa_checkout.dart';
import 'package:smartcafes/screens/checkout/tigopesa_checkout.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backColor,
        appBar: AppBar(
          backgroundColor: white.withOpacity(0.2),
          title: const Text(
            "Checkout",
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
            child: Container(
              margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
              height: size.height,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Select Payment Method",
                      style: GoogleFonts.urbanist(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MpesaCheckoutScreen(),
                          ),
                        );
                      },
                      child: listCheckout("MPESA", voda)),
                  SizedBox(height: size.height * 0.018),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HalopesaCheckoutScreen(),
                          ),
                        );
                      },
                      child: listCheckout("HALOPESA", halotel)),
                  SizedBox(height: size.height * 0.018),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TigoPesaCheckoutScreen(),
                          ),
                        );
                      },
                      child: listCheckout("TIGOPESA", tigo)),
                  SizedBox(height: size.height * 0.018),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AirtelMoneyCheckoutScreen(),
                          ),
                        );
                      },
                      child: listCheckout("AIRTEL MONEY", airtel)),
                  SizedBox(height: size.height * 0.018),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CashCheckoutScreen(),
                          ),
                        );
                      },
                      child: listCheckout("PAY VIA CASH", cash)),
                ],
              ),
            ),
          ),
        ));
  }

  Card listCheckout(String provider, String image) {
    return Card(
      color: white.withOpacity(0.9),
      elevation: 0.0,
      child: ListTile(
        leading: Image.asset(
          image,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.15,
        ),
        title: Center(
          child: Text(provider,
              style: GoogleFonts.ubuntu(
                  fontSize: 16, fontWeight: FontWeight.bold, color: backColor)),
        ),
      ),
    );
  }
}
