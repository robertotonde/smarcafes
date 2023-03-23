import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PackageDeliveryTrackingPage extends StatefulWidget {
  final String productImage;
  final String productName;
  final String quantity;
  final String orderStatus;
  final String orderStatusDescription;
  final String productPrice;
  final String userName;
  final String phoneNumber;
  final String college;
  final String location;
  const PackageDeliveryTrackingPage(
      {Key? key,
      required this.orderStatus,
      required this.quantity,
      required this.productPrice,
      required this.productName,
      required this.productImage,
      required this.orderStatusDescription,
      required this.userName,
      required this.phoneNumber,
      required this.college,
      required this.location})
      : super(key: key);

  @override
  _PackageDeliveryTrackingPageState createState() =>
      _PackageDeliveryTrackingPageState();
}

class _PackageDeliveryTrackingPageState
    extends State<PackageDeliveryTrackingPage> {
  final List<Map<String, dynamic>> orderStatus = [
    {
      "status": "Order Received",
      "description":
          "Your order has been receieved successfully and our team is working on preparing it 👫"
    },
    {
      "status": "Order Prepared",
      "description":
          "Your order has been successfully  prepared, our team is working on delivering it 📦"
    },
    {
      "status": "Order In Transit",
      "description": "Your order is on its way 🏇"
    },
    {
      "status": "Order Delivered",
      "description":
          "Thank you for choosing Chuo Mall 😍. Your order has been successfully delivered ✅"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int currentIndex = orderStatus
        .indexWhere((element) => element["status"] == widget.orderStatus);
    var _currentOrderStatus = orderStatus[currentIndex]["status"];

    bool activeOrder(String status) {
      if (_currentOrderStatus == status) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: white.withOpacity(0.2),
        title: Text(
          "${widget.productName} Order Tracking ",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                height: size.height / 6,
                decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 0.1),
                        Center(
                          child: Text(
                            "Product",
                            style: GoogleFonts.ubuntu(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff2ec2f0)),
                          ),
                        ),
                        const SizedBox(width: 0.1),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: size.height * 0.005),
                        Text(
                          widget.productName,
                          style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Text(
                          "${widget.productPrice} Tsh",
                          style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Text(
                          " X${widget.quantity}",
                          style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                height: size.height / 5,
                decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 0.1),
                        Center(
                          child: Text(
                            "Delivery Address",
                            style: GoogleFonts.ubuntu(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff2ec2f0)),
                          ),
                        ),
                        const SizedBox(width: 0.1),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: size.height * 0.005),
                        Text(
                          widget.userName,
                          style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Text(
                          widget.phoneNumber,
                          style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Text(
                          widget.college,
                          style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Text(
                          widget.location,
                          style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.005),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: SizedBox(
                  height: size.height / 2,
                  child: Stepper(
                    currentStep: currentIndex,
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        children: <Widget>[],
                      );
                    },
                    steps: [
                      Step(
                        title: Text(
                          'Order Received',
                          style: TextStyle(color: white),
                        ),
                        content: Text(
                          'Your order has been receieved successfully and our team is working on preparing it 👫',
                          style: TextStyle(color: white),
                        ),
                        isActive: activeOrder('Order Received'),
                        state: currentIndex == 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: Text(
                          'Order Prepared',
                          style: TextStyle(color: white),
                        ),
                        content: Text(
                          'Your order has been successfully  prepared, our team is working on delivering it 📦',
                          style: TextStyle(color: white),
                        ),
                        isActive: activeOrder('Order Prepared'),
                        state: currentIndex == 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: Text(
                          'Order In Transit',
                          style: TextStyle(color: white),
                        ),
                        content: Text(
                          'Your order is on its way 🏇',
                          style: TextStyle(color: white),
                        ),
                        state: currentIndex == 2
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: activeOrder('Order In Transit'),
                      ),
                      Step(
                        title: Text(
                          'Order Delivered',
                          style: TextStyle(color: white),
                        ),
                        content: Text(
                          'Thank you for choosing Chuo Mall 😍. Your order has been successfully delivered ✅',
                          style: TextStyle(color: white),
                        ),
                        state: currentIndex == 3
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: activeOrder('Order Delivered'),
                      ),
                    ],
                    type: StepperType.vertical,
                    onStepTapped: (step) {
                      setState(() {
                        currentIndex = step;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
